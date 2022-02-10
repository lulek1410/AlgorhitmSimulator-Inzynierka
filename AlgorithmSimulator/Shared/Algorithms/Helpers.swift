//
//  Helpers.swift
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

import Foundation
import SceneKit
func drawPathDynamicaly(algorithm_name: String, path_drawer: DrawPathDelegate, current_node: Node, display_all: Bool)
{
    if algorithm_name != "Bidirectional Dijkstra Start" && algorithm_name != "Bidirectional Dijkstra End"
    {
        DispatchQueue.main.sync{
            if (!display_all) {
                path_drawer.clearPath(name: "All")
            }
            path_drawer.drawPath(node: current_node, algorithm_name: algorithm_name)
        }
    }
    else {
        DispatchQueue.main.sync{
            if (!display_all){
                path_drawer.clearPath(name: algorithm_name)
            }
            path_drawer.drawPath(node: current_node, algorithm_name: algorithm_name)
        }
    }
}

func calculateDistance(pos_first: SCNVector3,
                       pos_second: SCNVector3,
                       altitude_change_cost_modifier: Float,
                       altitude_movement_cost_modifier: Float) -> Float{
    var result : Float
    result = sqrtf(powf(Float(pos_first.x - pos_second.x), 2) +
                   powf(Float(pos_first.y - pos_second.y), 2) +
                   powf(Float(pos_first.z - pos_second.z), 2))
    if pos_first.y != pos_second.y {
        result = result * altitude_change_cost_modifier
    }
    else if pos_first.y != 0 && pos_second.y != 0{
        result = result * altitude_movement_cost_modifier
    }
    return result
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

