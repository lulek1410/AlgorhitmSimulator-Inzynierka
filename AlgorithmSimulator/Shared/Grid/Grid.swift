//
//  Grid.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 19/08/2021.
//

import SceneKit

/// Navigation grid of nodes used to move through 3D space by an algorithm.
class Grid {
    
    /// All nodes present in grid.
    var nodes = [[[Node]]]()
    
    /// Size of grid in nodes
    var size : [Int] = [0, 0, 0] // width, height, length
    
    /// Coordinates of starting node
    var start_point = [-1, -1, -1]
    
    /// Coordinates of end node
    var end_point = [-1, -1, -1]
    
    /// Initializes Grid object based on given obstacles.
    ///
    /// - Parameters:
    ///     - obstacles: *All obstacles present in scene to be taken into consideration in grid generation*
    init(obstacles : [SCNNode], height: Int = -1) {
        generateGrid(obstacles: obstacles, height: height)
        includeObjects(obstacles: obstacles)
    }
    
    /// Sets all parameters of grid (generates grid)
    ///
    /// Grid height is based on highest point in given obstacles:
    ///   ~~~
    ///   if (obst.is_start || obst.is_end) {
    ///       height = Int(obst.position.y)
    ///   }
    ///   else if Int(obst.position.y + obst.height) > size[1] && obst.is_obstacle {
    ///       height = Int(obst.position.y + obst.height)
    ///   }
    ///   ~~~
    ///   Width and length are based on size of floor object
    ///
    /// - Parameters:
    ///     - obstacles: *All obstacles present in scene to be taken into consideration in grid generation*
    func generateGrid(obstacles : [SCNNode], height: Int){
        for obst in obstacles{
            //Get width and length form floor size
            if obst.is_floor {
                size[0] = Int(obst.width)
                // We take height because floor is rotated 90 degrees along x axis
                size[2] = Int(obst.height)
            }
            if height == -1 {
                if (obst.is_start || obst.is_end) {
                    if Int(obst.position.y) > size[1]{
                        size[1] = Int(obst.position.y)
                    }
                }
                else if Int(obst.position.y + obst.height) > size[1] && obst.is_obstacle {
                    size[1] = Int(obst.position.y + obst.height)
                }
                else if Int(obst.position.y + obst.radius) > size[1] && obst.is_obstacle {
                    size[1] = Int(obst.position.y + obst.height)
                }
            }
            else {
                size[1] = height
            }
        }
        for x in 0..<(size[0] + 1) {
            nodes.append([[Node]]())
            for y in 0..<(size[1] + 1) {
                nodes[x].append([Node]())
                for z in 0..<(size[2] + 1) {
                    nodes[x][y].append(Node(position: SCNVector3(x, y, z)))
                }
            }
        }
    }
    
    func getStartingPoint() -> Node?{
        guard let start_node = nodes[safe: start_point[0]]?[safe: start_point[1]]?[safe: start_point[2]] else {
            return nil
        }
        return start_node
    }
    
    func getEndingPoint() -> Node?{
        guard let end_node = nodes[safe: end_point[0]]?[safe: end_point[1]]?[safe: end_point[2]] else {
            return nil
        }
        return end_node
    }
    
    /// Includes given obstacles in grid.
    ///
    /// - Parameters:
    ///     - obstacles: *Obstacles to take into consideration in grid*
    private func includeObjects(obstacles : [SCNNode]) {
        for obstacle in obstacles {
            if obstacle.is_start || obstacle.is_end, checkPosition(obstacle: obstacle) {
                addStartEndPoint(obstacle: obstacle, is_start: obstacle.is_start);
            }
            
            else if !obstacle.is_floor && obstacle.is_obstacle{
                addObstacle(obstacle : obstacle)
            }
        }
    }
    
    /// Checks weather given obstacle is inside grid area.
    ///
    /// Grid area is defined as floor object as a base for 3D space and highest point in the scene as its height.
    ///
    ///
    /// - Parameters:
    ///     - obstacle: *object to check*
    ///
    /// - Returns: infromation weather object is inside area
    private func checkPosition(obstacle : SCNNode) -> Bool {
        if Int(obstacle.position.x) >= 0,
           Int(obstacle.position.y) >= 0,
           Int(-obstacle.position.z) >= 0 {
            if (obstacle.is_start || obstacle.is_end),
               Int(obstacle.position.x) <= size[0],
               Int(obstacle.position.y) <= size[1],
               Int(-obstacle.position.z) <= size[2] {
                
                return true
            }
            else if Int(obstacle.position.x + obstacle.width) <= size[0],
                    Int(obstacle.position.y + obstacle.height) <= size[1],
                    Int(-obstacle.position.z + obstacle.length) <= size[2]/2 {
                
                return true
            }
        }
        return false
    }
    
    /// Takes given object and makes nodes present inside it not traversable
    ///
    /// - Parameters:
    ///     - obstacle: *object to take into consideration in grid*
    private func addObstacle(obstacle : SCNNode) {
        let name = obstacle.name?.split(separator: " ")
        if name![0] == "Box" {
            addBox(box: obstacle)
        }
        else if name![0] == "Pyramid" {
            addPyramid(pyramid: obstacle, name: name!)
        }
        else if name![0] == "Sphere" {
            addSphere(sphere: obstacle)
        }
    }
    
    private func addBox(box: SCNNode){
        for pos_x in 0 ..< Int(box.width+1) {
            for pos_y in  0 ..< Int(box.height+1) {
                for pos_z in 0 ..< Int(box.length+1) {
                    let x = Int(box.position.x) + pos_x
                    let y = Int(box.position.y) + pos_y
                    let z = Int(-box.position.z) + pos_z
                    guard let node = nodes[safe: x]?[safe :y]?[safe :z] else {
                        continue
                    }
                    node.is_traversable = false
                }
            }
        }
    }
    
    private func addPyramid(pyramid: SCNNode, name: [String.SubSequence]){
        var pos_x_start : [Int] = []
        var pos_x_end : [Int] = []
        var pos_z_start : [Int] = []
        var pos_z_end : [Int] = []
        
        for y in 1 ..< Int(pyramid.height+2) {
            let num_descending : Double = (pyramid.width/pyramid.height) * (pyramid.height + 1 - CGFloat(y))
            let num_ascending : Double = (pyramid.width/pyramid.height) * CGFloat(y - 1)
            if name[2] == "left" {
                pos_x_start.append(0)
                pos_x_end.append(Int(ceil(num_descending)))
            }
            else {
                pos_x_start.append(Int(ceil(num_ascending)))
                pos_x_end.append(Int(pyramid.width))
            }
            if name[1] == "Bottom" {
                pos_z_start.append(0)
                pos_z_end.append(Int(ceil(num_descending)))
            }
            else {
                pos_z_start.append(Int(ceil(num_ascending)))
                pos_z_end.append(Int(pyramid.length))
            }
        }
        
        for pos_y in 0 ..< Int(pyramid.height+1) {
            for pos_x in pos_x_start[pos_y] ..< pos_x_end[pos_y] + 1 {
                for pos_z in pos_z_start[pos_y] ..< pos_z_end[pos_y] + 1 {
                    let x = Int(pyramid.position.x) + pos_x
                    let y = Int(pyramid.position.y) + pos_y
                    let z = Int(-pyramid.position.z) + pos_z
                    guard let node = nodes[safe: x]?[safe: y]?[safe: z] else {
                        continue
                    }
                    node.is_traversable = false
                }
            }
        }
    }
    
    private func addSphere(sphere: SCNNode){
        for pos_x in -Int(sphere.width)/2 ..< Int(sphere.width/2+1) {
            for pos_y in  -Int(sphere.height)/2 ..< Int(sphere.height/2+1) {
                for pos_z in -Int(sphere.length)/2 ..< Int(sphere.length/2+1) {
                    let x = Int(sphere.position.x) + pos_x
                    let y = Int(sphere.position.y) + pos_y
                    let z = Int(-sphere.position.z) + pos_z
                    if pow(CGFloat(pos_x), 2) + pow(CGFloat(pos_y), 2) + pow(CGFloat(pos_z), 2) <= pow(sphere.radius, 2) {
                        guard let node = nodes[safe: x]?[safe: y]?[safe: z] else {
                            continue
                        }
                        node.is_traversable = false
                    }
                }
            }
        }
    }
    
    /// Sets start and end nodes.
    ///
    /// - Parameters:
    ///     - obstacle: *object that is either start or end obstacle*
    ///     - is_start: *weather given objest is starting object*
    private func addStartEndPoint(obstacle : SCNNode, is_start : Bool){
        let position = [Int(obstacle.position.x), Int(obstacle.position.y), Int(-obstacle.position.z)]
        switch(is_start){
        case true :
            nodes[position[0]][position[1]][position[2]].is_starting = true;
            self.start_point = position
        case false:
            nodes[position[0]][position[1]][position[2]].is_end = true;
            self.end_point = position
        }
    }
}
