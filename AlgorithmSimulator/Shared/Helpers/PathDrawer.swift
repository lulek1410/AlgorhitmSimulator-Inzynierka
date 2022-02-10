//
//  PathDrawer.swift
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

class PathDrawer{
    
    static let colors: [NSColor] = [NSColor.cyan, NSColor.orange, NSColor.green, NSColor.yellow, NSColor.systemIndigo]
    
    static func drawPath(node: Node, algorithm_name: String){
        if node.parent != nil && algorithm_name != "Bidirectional Dijkstra End"{
            drawPath(node1: node, node2: node.parent!, algorithm_name: algorithm_name)
            drawPath(node: node.parent!, algorithm_name: algorithm_name)
        }
        else if node.r_parent != nil {
            drawPath(node1: node, node2: node.r_parent!, algorithm_name: algorithm_name)
            drawPath(node: node.r_parent!, algorithm_name: algorithm_name)
        }
    }
    
    static func drawPath(node1: Node, node2: Node, algorithm_name: String){
        let color_num = pickColor(algorithm_name: algorithm_name)
        let pos1 = SCNVector3(x: node1.position.x, y: node1.position.y, z: -node1.position.z)
        let pos2 = SCNVector3(x: node2.position.x, y: node2.position.y, z: -node2.position.z)
        let path_node = SCNGeometry.cylinderLine(from: pos1, to: pos2, segments: 4, color: colors[color_num])
        path_node.path = algorithm_name
        node1.shape = path_node
    }
    
    static private func pickColor(algorithm_name: String) -> Int{
        switch(algorithm_name){
        case "A* Euclidean": return 0
        case "Dijkstra": return 1
        case "Dijkstra Threads": return 2
        case "Bidirectional Dijkstra Start": return 3
        case "Bidirectional Dijkstra End": return 3
        case "A* Diagonal": return 4
        default:
            return 0
        }
    }
}

extension SCNGeometry {
    class func cylinderLine(from: SCNVector3,
                            to: SCNVector3,
                            segments: Int,
                            color: NSColor) -> SCNNode {
        
        let x1 = from.x
        let x2 = to.x
        
        let y1 = from.y
        let y2 = to.y
        
        let z1 = from.z
        let z2 = to.z
        
        let distance =  sqrt((x2-x1) * (x2-x1) +
                                (y2-y1) * (y2-y1) +
                                (z2-z1) * (z2-z1))
        
        let cylinder = SCNCylinder(radius: 0.05,
                                   height: CGFloat(distance))
        
        cylinder.radialSegmentCount = segments
        
        cylinder.firstMaterial?.diffuse.contents = color
        
        let lineNode = SCNNode(geometry: cylinder)
        
        lineNode.position = SCNVector3(x: (from.x + to.x) / 2,
                                       y: (from.y + to.y) / 2,
                                       z: (from.z + to.z) / 2)
        
        lineNode.eulerAngles = SCNVector3(CGFloat.pi / 2,
                                          acos((to.z-from.z)/distance),
                                          atan2((to.y-from.y),(to.x-from.x)))
        
        return lineNode
    }
}


