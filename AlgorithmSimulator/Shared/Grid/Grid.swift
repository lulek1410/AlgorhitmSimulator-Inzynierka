//
//  Grid.swift
//  AlgorithmSimulator-macOS
//
//  Copyright (c) 2021 Jan Szewczyński
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

import SceneKit


class Grid {
    
    var nodes = [[[Node]]]()
    var size : [Int] = [0, 0, 0] // width, height, length
    var start_point = [-1, -1, -1]
    var end_point = [-1, -1, -1]
    
    init(obstacles : [SCNNode], height: Int = -1) {
        calculateGridSize(obstacles: obstacles, height: height)
        generateGrid(size: self.size)
        includeObjects(obstacles: obstacles)
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
    
    private func calculateGridSize(obstacles: [SCNNode], height: Int){
        for obst in obstacles{
            //Get width and length form floor size
            if obst.is_floor {
                size[0] = Int(obst.width)
                // We take height because floor is rotated 90 degrees along x axis
                size[2] = Int(obst.height)
            }
            if height == -1 {
                if ((obst.is_start || obst.is_end) && Int(obst.position.y) > size[1]) {
                    size[1] = Int(obst.position.y)
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
    }
    
    private func generateGrid(size: [Int]){
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
    private func addStartEndPoint(obstacle : SCNNode, is_start : Bool){
        let position = [Int(obstacle.position.x), Int(obstacle.position.y), Int(-obstacle.position.z)]
        switch(is_start){
        case true :
            self.start_point = position
        case false:
            self.end_point = position
        }
    }
}
