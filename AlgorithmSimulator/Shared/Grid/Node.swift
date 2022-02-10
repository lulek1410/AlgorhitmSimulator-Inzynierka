//
//  Node.swift
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

class Node: Equatable, Comparable {
    
    var is_traversable: Bool = true
    var position: SCNVector3 = SCNVector3(0, 0, 0)
    var parent: Node?
    var distance: Float = Float.greatestFiniteMagnitude
    
    var r_parent: Node?
    var shape: SCNNode?
    var r_dist: Float = Float.greatestFiniteMagnitude
    var source_dist: Float = Float.greatestFiniteMagnitude
    init(position : SCNVector3) {
        self.position = position
    }
    static func == (lhs: Node, rhs: Node) -> Bool {
        return
            lhs.position.x == rhs.position.x &&
            lhs.position.y == rhs.position.y &&
            lhs.position.z == rhs.position.z
    }
    static func < (lhs: Node, rhs: Node) -> Bool {
        if lhs.r_dist != Float.greatestFiniteMagnitude && rhs.r_dist != Float.greatestFiniteMagnitude {
            return lhs.r_dist < rhs.r_dist
        }
        return lhs.distance < rhs.distance
    }
}
