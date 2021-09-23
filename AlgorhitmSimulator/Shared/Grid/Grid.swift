//
//  Grid.swift
//  Test
//
//  Created by Janek on 19/08/2021.
//

import SceneKit

class Grid {
    var nodes = [[[Node]]]()
    var size : [Int] = [0, 0, 0] // width, height, length
    var start_point = [-1, -1, -1]
    var end_point = [-1, -1, -1]
    let grid_size = 1
    
    
    init(obstacles : [SCNNode]) {
        generateGrid(obstacles: obstacles)
        includeObjects(obstacles: obstacles)
    }
    
    func generateGrid(obstacles : [SCNNode]){
        for obst in obstacles{
            if obst.is_floor {
                size[0] = Int(obst.width)
                size[2] = Int(obst.height)
            }
            else if (obst.is_start || obst.is_end) {
                if Int(obst.position.y) > size[1]{
                    size[1] = Int(obst.position.y)
                }
            }
            else if Int(obst.position.y + obst.height) > size[1] && obst.is_obstacle {
                print(obst.position, obst.height)
                size[1] = Int(obst.position.y + obst.height)
            }
        }
        for x in 0..<(size[0] + 1)/grid_size {
            nodes.append([[Node]]())
            for y in 0..<(size[1] + 1)/grid_size {
                nodes[x].append([Node]())
                for z in 0..<(size[2] + 1)/grid_size {
                    nodes[x][y].append(Node(position: SCNVector3(x, y, z)))
                }
            }
        }
    }
    
    private func includeObjects(obstacles : [SCNNode]) {
        print(obstacles.count)
        for obstacle in obstacles {
            print(obstacle.position)
            if obstacle.is_start || obstacle.is_end, checkPosition(obstacle: obstacle) {
                addStartEndPoint(obstacle: obstacle, is_start: obstacle.is_start);
            }
            
            else if !obstacle.is_floor{
                addObstacle(obstacle : obstacle)
            }
        }
    }
    
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
    
    private func addObstacle(obstacle : SCNNode) {
        let name = obstacle.name?.split(separator: " ")
        if name![0] == "Box" {
            for pos_x in 0 ..< Int(obstacle.width+1) {
                for pos_y in  0 ..< Int(obstacle.height+1) {
                    for pos_z in 0 ..< Int(obstacle.length+1) {
                        let x = Int(obstacle.position.x) + pos_x
                        let y = Int(obstacle.position.y) + pos_y
                        let z = Int(-obstacle.position.z) + pos_z
                        guard let node = nodes[safe: x]?[safe :y]?[safe :z] else {
                            continue
                        }
                        node.is_traversable = false
                    }
                }
            }
        }
        else if name![0] == "Pyramid" {
            var pos_x_start : [Int] = []
            var pos_x_end : [Int] = []
            var pos_z_start : [Int] = []
            var pos_z_end : [Int] = []
            
            for y in 1 ..< Int(obstacle.height+2) {
                let num_descending : Double = (obstacle.width/obstacle.height) * (obstacle.height + 1 - CGFloat(y))
                let num_ascending : Double = (obstacle.width/obstacle.height) * CGFloat(y - 1)
                if name![2] == "left" {
                    pos_x_start.append(0)
                    pos_x_end.append(Int(ceil(num_descending)))
                }
                else {
                    pos_x_start.append(Int(ceil(num_ascending)))
                    pos_x_end.append(Int(obstacle.width))
                }
                if name![1] == "Bottom" {
                    pos_z_start.append(0)
                    pos_z_end.append(Int(ceil(num_descending)))
                }
                else {
                    pos_z_start.append(Int(ceil(num_ascending)))
                    pos_z_end.append(Int(obstacle.length))
                }
            }
            
            
//            if name![1] == "Bottom" {
//                if name![2] == "left"{
//                    for y in 1 ..< Int(obstacle.height+2) {
//                        pos_x_start.append(0)
//                        pos_x_end.append(Int(obstacle.width / obstacle.height) * (Int(obstacle.height) + 1 - y))
//
//                        pos_z_start.append(0)
//                        pos_z_end.append(Int(obstacle.length / obstacle.height) * (Int(obstacle.height) + 1 - y))
//                    }
//                }
//                else {
//                    for y in  1 ..< Int(obstacle.height+2) {
//                        pos_x_start.append(Int((obstacle.width/obstacle.height)) * (y - 1))
//                        pos_x_end.append(Int(obstacle.width))
//
//                        pos_z_start.append(0)
//                        pos_z_end.append(Int(obstacle.length / obstacle.height) * (Int(obstacle.height) + 1 - y))
//                    }
//                }
//            }
//            else {
//                if name![2] == "left" {
//                    for y in 1 ..< Int(obstacle.height+2) {
//                        pos_x_start.append(0)
//                        pos_x_end.append(Int(obstacle.width / obstacle.height) * (Int(obstacle.height) + 1 - y))
//
//                        pos_z_start.append(Int((obstacle.length / obstacle.height)) * (y - 1))
//                        pos_z_end.append(Int(obstacle.length))
//                    }
//                }
//                else {
//                    for y in 1 ..< Int(obstacle.height+2) {
//                        pos_x_start.append(Int((obstacle.width/obstacle.height)) * (y - 1))
//                        pos_x_end.append(Int(obstacle.width))
//
//                        pos_z_start.append(Int((obstacle.length / obstacle.height)) * (y - 1))
//                        pos_z_end.append(Int(obstacle.length))
//                    }
//                }
//            }
            
            
            
            for pos_y in 0 ..< Int(obstacle.height+1) {
                for pos_x in pos_x_start[pos_y] ..< pos_x_end[pos_y] + 1 {
                    for pos_z in pos_z_start[pos_y] ..< pos_z_end[pos_y] + 1 {
                        let x = Int(obstacle.position.x) + pos_x
                        let y = Int(obstacle.position.y) + pos_y
                        let z = Int(-obstacle.position.z) + pos_z
                        guard let node = nodes[safe: x]?[safe: y]?[safe: z] else {
                            continue
                        }
                        node.is_traversable = false
                    }
                }
            }
        }
    }
    
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
