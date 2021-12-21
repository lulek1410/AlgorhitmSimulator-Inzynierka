//
//  Dijkstra.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 24/11/2021.
//

import SceneKit
import Foundation

/// Implementation of Dijkstra shortest path algorithm.
///
/// - Parameters:
///     - grid: *grid containing nodes on which the algorithm operates*
///     - work_item: *work item that executes this function (used to break function execution when needed)*
///     - altitude_cost_modifier: *value determining how distance is modified if nodes altitude changes*
///     - dynamic_path_display: *value determining weather to display path dynamicaly when algoithm is working*
///     - path_drawer: *delegate object used to dipslay path on the sceene*
/// - Returns: Number of nodes that has beed processed in order to find a path betwean start and end nodes.
func Dijkstra(grid: Grid,
              work_item: DispatchWorkItem,
              altitude_change_cost_modifier: Float,
              altitude_movement_cost_modifier: Float,
              dynamic_path_display: Bool,
              path_drawer: DrawPathDelegate,
              display_all: Bool) -> Int {
    
    let nodes = grid.nodes
    var nodes_processed : Int = 0
    grid.getStartingPoint()!.distance = 0
    
    var priority_queue : PriorityQueue<Node> = PriorityQueue<Node>(ascending: true, startingValues: [grid.getStartingPoint()!])
    
    var closed : [Node] = []
    
    while !priority_queue.isEmpty {
        if work_item.isCancelled {break}
        let min = priority_queue.pop()
        closed.append(min!)
        if dynamic_path_display || display_all{
            if (!display_all){
                Thread.sleep(forTimeInterval: 0.1)
            }
            drawPathDynamicaly(algorithm_name: "Dijkstra",
                               path_drawer: path_drawer,
                               current_node: min!,
                               display_all: display_all)
        }
        if min == grid.getEndingPoint()!{
            return nodes_processed
        }
        for x in -1 ..< 2{
            for y in -1 ..< 2 {
                for z in -1 ..< 2 {
                    guard let processed_node = nodes[safe:Int(min!.position.x)+x]?[safe:Int(min!.position.y)+y]?[safe:Int(min!.position.z)+z] else {
                        continue
                    }
                    // Check if node is right for processing
                    if !closed.contains(processed_node) && processed_node.is_traversable{

                        let new_dist = min!.distance +
                        calculateDistance(pos_first: min!.position,
                                          pos_second: processed_node.position,
                                          altitude_change_cost_modifier: altitude_change_cost_modifier,
                                          altitude_movement_cost_modifier: altitude_movement_cost_modifier)
                        // if new distance is besster than previous we set new values for curently
                        // processed node
                        if new_dist < processed_node.distance {
                            nodes_processed += 1
                            processed_node.distance = new_dist
                            processed_node.parent = min
                            priority_queue.push(processed_node)
                        }
                    }
                }
            }
        }
    }
    return nodes_processed
}
