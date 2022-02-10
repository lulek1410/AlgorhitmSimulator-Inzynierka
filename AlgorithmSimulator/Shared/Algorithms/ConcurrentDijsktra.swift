//
//  ConcurrentDijsktra.swift
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
import Foundation

func concurrentDijkstra(grid : Grid,
                        work_item : DispatchWorkItem,
                        altitude_change_cost_modifier : Float,
                        altitude_movement_cost_modifier: Float,
                        dynamic_path_display: Bool,
                        path_drawer: DrawPathDelegate,
                        display_all: Bool) -> Int{
    
    let nodes = grid.nodes
    var closed = [Node]()
    let lock = NSLock()
    var nodes_processed : Int = 0
    let group = DispatchGroup()
    
    var priority_queue : PriorityQueue<Node> = PriorityQueue<Node>(ascending: true)
    grid.getStartingPoint()!.distance = 0
    priority_queue.push(grid.getStartingPoint()!)
    
    while !priority_queue.isEmpty {
        if work_item.isCancelled{break}
        let min = priority_queue.pop()
        closed.append(min!)
        if dynamic_path_display || display_all{
            if (!display_all){
                Thread.sleep(forTimeInterval: 0.1)
            }
            drawPathDynamicaly(algorithm_name: "Dijkstra Threads",
                               path_drawer: path_drawer,
                               current_node: min!,
                               display_all: display_all)
        }
        if min == grid.getEndingPoint()! {
            return nodes_processed
        }
        for x in -1 ..< 2{
            group.enter()
            // Tworzenie wątków przetwarzających płaszczyzny 3x3 wezły
            DispatchQueue.global().async {
                var num_of_processed_nodes = 0
                let x_t = x
                for y in -1 ..< 2 {
                    for z in -1 ..< 2 {
                        guard let processed_node = nodes[safe:Int(min!.position.x)+x_t]?[safe:Int(min!.position.y)+y]?[safe:Int(min!.position.z)+z] else {
                            continue
                        }
                        // Sprawdzenie czy węzeł jest poprawny i odpowiedzni do dalszego przetwarzania
                        if processed_node.is_traversable && !closed.contains(processed_node) {
                            let new_dist = min!.distance +
                            calculateDistance(pos_first: min!.position,
                                              pos_second: processed_node.position,
                                              altitude_change_cost_modifier: altitude_change_cost_modifier,
                                              altitude_movement_cost_modifier: altitude_movement_cost_modifier)
                            
                            // Jeżeli nowy dystans jest krótszy od obecnego to zmieniamy go na nowy
                            if new_dist < processed_node.distance{
                                num_of_processed_nodes += 1
                                processed_node.distance = new_dist
                                processed_node.parent = min!
                                lock.lock()
                                priority_queue.push(processed_node)
                                lock.unlock()
                            }
                        }
                    }
                }
                lock.lock()
                nodes_processed += num_of_processed_nodes
                lock.unlock()
                group.leave()
            }
        }
        group.wait()
    }
    return nodes_processed
}
