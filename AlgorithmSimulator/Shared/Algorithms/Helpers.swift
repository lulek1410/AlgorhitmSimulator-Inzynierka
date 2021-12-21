//
//  Helpers.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 24/11/2021.
//

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

/// Calculates distance betwean 2 points in 3D space
///
/// - Parameters:
///     - pos_first: *position of first point*
///     - pos_second: *position of second point*
///     - altitude_cost_modifier: *value determining how distance is modified if nodes altitude changes*
/// - Returns: Distance betwean pos_first and pos_second
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

