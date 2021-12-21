//
//  ConcurrentDijsktra.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 24/11/2021.
//
import SceneKit
import Foundation

/// Implementation of Dijkstra shortest path algorithm utilizing multiple threads to improve performance.
///
/// - Parameters:
///     - grid: *grid containing nodes on which the algorithm operates*
///     - work_item: *work item that executes this function (used to break function execution when needed)*
///     - altitude_cost_modifier: *value determining how distance is modified if nodes altitude changes*
///     - dynamic_path_display: *value determining weather to display path dynamicaly when algoithm is working*
///     - path_drawer: *delegate object used to dipslay path on the sceene*
/// - Returns: Number of nodes that has beed processed in order to find a path betwean start and end nodes.
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
            // every thread processes 3x3 plain of nodes and all plains come to 3x3x3 cube of nodes
            DispatchQueue.global().async {
                var num_of_processed_nodes = 0
                let x_t = x
                for y in -1 ..< 2 {
                    for z in -1 ..< 2 {
                        guard let processed_node = nodes[safe:Int(min!.position.x)+x_t]?[safe:Int(min!.position.y)+y]?[safe:Int(min!.position.z)+z] else {
                            continue
                        }
                        // Check if node is right for processing
                        if processed_node.is_traversable && !closed.contains(processed_node) {
                            let new_dist = min!.distance +
                            calculateDistance(pos_first: min!.position,
                                              pos_second: processed_node.position,
                                              altitude_change_cost_modifier: altitude_change_cost_modifier,
                                              altitude_movement_cost_modifier: altitude_movement_cost_modifier)
                            
                            // if new distance is besster than previous we set new values for curently
                            // processed node
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
