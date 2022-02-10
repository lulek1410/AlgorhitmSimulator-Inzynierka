//
//  AStar.swift
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

func Astar(grid: Grid,
           work_item: DispatchWorkItem,
           altitude_change_cost_modifier: Float,
           altitude_movement_cost_modifier: Float,
           dynamic_path_display: Bool,
           path_drawer: DrawPathDelegate,
           heuristics_type: String,
           display_all: Bool) -> Int {
    
    let nodes = grid.nodes
    var nodes_processed : Int = 0
    
    let start_position = SCNVector3(grid.start_point[0], grid.start_point[1], grid.start_point[2])
    let end_position = SCNVector3(grid.end_point[0], grid.end_point[1], grid.end_point[2])
    
    nodes[grid.start_point[0]][grid.start_point[1]][grid.start_point[2]].distance =
    calculateDistance(pos_first: start_position,
                      pos_second: end_position,
                      altitude_change_cost_modifier: altitude_change_cost_modifier,
                      altitude_movement_cost_modifier: altitude_movement_cost_modifier)
    nodes[grid.start_point[0]][grid.start_point[1]][grid.start_point[2]].source_dist = 0
    
    
    var priority_queue : PriorityQueue<Node> = PriorityQueue<Node>(ascending: true, startingValues: [nodes[grid.start_point[0]][grid.start_point[1]][grid.start_point[2]]])
    
    var closed : [Node] = []
    
    while !priority_queue.isEmpty {
        if work_item.isCancelled {break}
        let min = priority_queue.pop()
        closed.append(min!)
        if dynamic_path_display || display_all{
            if (!display_all){
                Thread.sleep(forTimeInterval: 0.1)
            }
            drawPathDynamicaly(algorithm_name: "A*",
                               path_drawer: path_drawer,
                               current_node: min!,
                               display_all: display_all)
        }
        if min == nodes[grid.end_point[0]][grid.end_point[1]][grid.end_point[2]] {
            return nodes_processed
        }
        for x in -1 ..< 2{
            for y in -1 ..< 2 {
                for z in -1 ..< 2 {
                    guard let processed_node = nodes[safe:Int(min!.position.x)+x]?[safe:Int(min!.position.y)+y]?[safe:Int(min!.position.z)+z] else {
                        continue
                    }
                    // Sprawdzenie czy węzeł jest poprawny i odpowiedzni do dalszego przetwarzania
                    if !closed.contains(processed_node) && processed_node.is_traversable {
                        let new_dist_from_source = min!.source_dist +
                        calculateDistance(pos_first: min!.position,
                                          pos_second: processed_node.position,
                                          altitude_change_cost_modifier: altitude_change_cost_modifier,
                                          altitude_movement_cost_modifier: altitude_movement_cost_modifier)
                        
                        // Jeżeli nowy dystans jest krótszy od obecnego to zmieniamy go na nowy
                        if new_dist_from_source < processed_node.source_dist {
                            nodes_processed += 1
                            processed_node.parent = min
                            processed_node.source_dist = new_dist_from_source
                            processed_node.distance = processed_node.source_dist +
                            calculateHeuristics(heuristics_type: heuristics_type,
                                                pos_first: processed_node.position,
                                                pos_second: end_position,
                                                altitude_change_cost_modifier:  altitude_change_cost_modifier,
                                                altitude_movement_cost_modifier: altitude_movement_cost_modifier)
                            if !priority_queue.contains(processed_node) {
                                priority_queue.push(processed_node)
                            }
                        }
                    }
                }
            }
        }
    }
    return nodes_processed
}

func calculateHeuristics(heuristics_type: String,
                         pos_first: SCNVector3,
                         pos_second: SCNVector3,
                         altitude_change_cost_modifier: Float,
                         altitude_movement_cost_modifier: Float) -> Float {
    switch(heuristics_type){
    case "Euclidean": return calculateDistance(pos_first: pos_first,
                                               pos_second: pos_second,
                                               altitude_change_cost_modifier: altitude_change_cost_modifier,
                                               altitude_movement_cost_modifier: altitude_movement_cost_modifier)
                                                                                                                    
    case "Diagonal": return calculateDiagonal(pos_first: pos_first,
                                              pos_second: pos_second,
                                              altitude_change_cost_modifier: altitude_change_cost_modifier,
                                              altitude_movement_cost_modifier: altitude_movement_cost_modifier)
    default: return 0
    }
}

func calculateDiagonal(pos_first: SCNVector3,
                       pos_second: SCNVector3,
                       altitude_change_cost_modifier: Float,
                       altitude_movement_cost_modifier: Float) -> Float {
    let dx = abs(Float(pos_first.x - pos_second.x))
    let dy = abs(Float(pos_first.y - pos_second.y))
    let dz = abs(Float(pos_first.z - pos_second.z))
    let mid : Float = dx + dy + dz - max(dx, dy, dz) - min(dx, dy, dz)
    var result = max(dx, dy, dz) + mid * (sqrtf(2) - 1) + min(dx, dy, dz) * (sqrtf(3) - sqrtf(2))
    if pos_first.y != pos_second.y {
        result = result * altitude_change_cost_modifier
    }
    else if pos_first.y != 0 && pos_second.y != 0{
        result = result * altitude_movement_cost_modifier
    }
    return result
}
