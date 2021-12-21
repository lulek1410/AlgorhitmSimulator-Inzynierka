//
//  BidirectionalDijkstra.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 24/11/2021.
//

import Foundation
import SceneKit

func bidirectionalDijkstra(grid : Grid,
                           work_item : DispatchWorkItem,
                           altitude_change_cost_modifier : Float,
                           altitude_movement_cost_modifier: Float,
                           dynamic_path_display: Bool,
                           path_drawer: DrawPathDelegate, display_all: Bool) -> (Int, Node){
    let nodes = grid.nodes
    var closed_start = [Node]()
    var closed_end = [Node]()
    
    var mid: Node?
    
    var nodes_processed = 0;
    
    var queue_start : PriorityQueue<Node> = PriorityQueue<Node>(ascending: true)
    grid.getStartingPoint()!.distance = 0
    queue_start.push(grid.getStartingPoint()!)
    
    var queue_end : PriorityQueue<Node> = PriorityQueue<Node>(ascending: true)
    grid.getEndingPoint()!.r_dist = 0
    queue_end.push(grid.getEndingPoint()!)
    
    var current_min_cost_start: Float = 0
    var current_min_cost_end: Float = 0
    var min_cost: Float = Float.greatestFiniteMagnitude
    let min_unit_cost: Float = 0.0
    
    var run = true
    
    let group = DispatchGroup()
    let lock = NSLock()
    
    while run{
        if work_item.isCancelled {break}
        group.enter()
        DispatchQueue.global().async {
            guard let forward_next = queue_start.pop() else {
                run = false
                group.leave()
                return
            }
            if dynamic_path_display || display_all{
                if (!display_all){
                    Thread.sleep(forTimeInterval: 0.1)
                }
                lock.lock()
                drawPathDynamicaly(algorithm_name: "Bidirectional Dijkstra Start",
                                   path_drawer: path_drawer,
                                   current_node: forward_next,
                                   display_all: display_all)
                lock.unlock()
            }
            closed_start.append(forward_next)
            current_min_cost_start = forward_next.distance
            if current_min_cost_start + current_min_cost_end + min_unit_cost >= min_cost{
                run = false
            }
            
            let f_distance = forward_next.distance
            for x in -1 ..< 2{
                for y in -1 ..< 2 {
                    for z in -1 ..< 2 {
                        guard let processed_node = nodes[safe:Int(forward_next.position.x)+x]?[safe:Int(forward_next.position.y)+y]?[safe:Int(forward_next.position.z)+z] else {
                            continue
                        }
                        if !closed_start.contains(processed_node) && processed_node.is_traversable{
                            let edge_weight = calculateDistance(pos_first: forward_next.position,
                                                                pos_second: processed_node.position,
                                                                altitude_change_cost_modifier: altitude_change_cost_modifier,
                                                                altitude_movement_cost_modifier: altitude_movement_cost_modifier)
                            if f_distance + edge_weight + current_min_cost_end <= min_cost{
                                if processed_node.distance > f_distance + edge_weight {
                                    processed_node.distance = f_distance + edge_weight
                                    nodes_processed += 1
                                    queue_start.push(processed_node)
                                    processed_node.parent = forward_next
                                    if processed_node.r_dist != Float.greatestFiniteMagnitude {
                                        let new_cost = processed_node.distance + processed_node.r_dist
                                        lock.lock()
                                        if new_cost < min_cost{
                                            min_cost = new_cost
                                            mid = processed_node
                                        }
                                        lock.unlock()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            group.leave()
        }
        group.enter()
        DispatchQueue.global().async {
            guard let reverse_next = queue_end.pop() else {
                run = false
                group.leave()
                return
            }
            if dynamic_path_display || display_all{
                if (!display_all){
                    Thread.sleep(forTimeInterval: 0.1)
                }
                lock.lock()
                drawPathDynamicaly(algorithm_name: "Bidirectional Dijkstra End",
                                   path_drawer: path_drawer,
                                   current_node: reverse_next,
                                   display_all: display_all)
                lock.unlock()
            }
            closed_end.append(reverse_next)
            current_min_cost_end = reverse_next.r_dist
            if current_min_cost_end + current_min_cost_start + min_unit_cost >= min_cost{
                run = false
            }
            let r_distance = reverse_next.r_dist
            for x in -1 ..< 2{
                for y in -1 ..< 2 {
                    for z in -1 ..< 2 {
                        guard let processed_node = nodes[safe:Int(reverse_next.position.x)+x]?[safe:Int(reverse_next.position.y)+y]?[safe:Int(reverse_next.position.z)+z] else {
                            continue
                        }
                        if !closed_end.contains(processed_node) && processed_node.is_traversable{
                            let edge_weight = calculateDistance(pos_first: reverse_next.position,
                                                                pos_second: processed_node.position,
                                                                altitude_change_cost_modifier: altitude_change_cost_modifier,
                                                                altitude_movement_cost_modifier: altitude_movement_cost_modifier)
                            if r_distance + edge_weight + current_min_cost_start <= min_cost{
                                if processed_node.r_dist > r_distance + edge_weight{
                                    processed_node.r_dist = r_distance + edge_weight
                                    queue_end.push(processed_node)
                                    nodes_processed += 1
                                    processed_node.r_parent = reverse_next
                                    if processed_node.distance != Float.greatestFiniteMagnitude{
                                        let new_cost = processed_node.distance + processed_node.r_dist
                                        lock.lock()
                                        if new_cost < min_cost{
                                            min_cost = new_cost
                                            mid = processed_node
                                        }
                                        lock.unlock()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            group.leave()
        }
        group.wait()
    }
    if var current = mid{
        grid.getEndingPoint()?.distance = mid!.distance + mid!.r_dist
        while(current != grid.getEndingPoint()){
            let previous = current.r_parent
            previous?.parent = current
            current = previous!
        }
        return (nodes_processed, grid.getEndingPoint()!)
    }
    return (-1, grid.getEndingPoint()!)
}
