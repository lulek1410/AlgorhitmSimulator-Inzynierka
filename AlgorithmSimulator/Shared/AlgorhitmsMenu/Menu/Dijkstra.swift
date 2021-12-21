//
//  Dijkstra.swift
//  Test
//
//  Created by Janek on 15/09/2021.
//

import Foundation
import SceneKit
import SwiftPriorityQueue

class Dijkstra {
    
    var closed : [Node] = []
    
    func Dijkstra(grid : Grid, work_item : DispatchWorkItem) {
        let nodes = grid.nodes
        nodes[grid.start_point[0]][grid.start_point[1]][grid.start_point[2]].distance = 0
        
        var priority_queue : PriorityQueue<Node> = PriorityQueue<Node>(ascending: true, startingValues: [nodes[grid.start_point[0]][grid.start_point[1]][grid.start_point[2]]])
        
        while !priority_queue.isEmpty {
            if work_item.isCancelled {break}
            let min = priority_queue.pop()
            closed.append(min!)
            if min == nodes[grid.end_point[0]][grid.end_point[1]][grid.end_point[2]] {
                return
            }
            for x in -1 ..< 2{
                for y in -1 ..< 2 {
                    for z in -1 ..< 2 {
                        guard let processed_node = nodes[safe:Int(min!.position.x)+x]?[safe:Int(min!.position.y)+y]?[safe:Int(min!.position.z)+z] else {
                            continue
                        }
                        if !closed.contains(processed_node) && processed_node.is_traversable{

                            let new_dist = min!.distance + self.calculateDistance(pos_first: min!.position,
                                                                                  pos_second: processed_node.position)
                            if new_dist < processed_node.distance {
                                processed_node.distance = new_dist
                                processed_node.parent_node = min
                                priority_queue.push(processed_node)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func calculateDistance(pos_first : SCNVector3, pos_second : SCNVector3) -> Float{
        return
            sqrtf(powf(Float(pos_first.x - pos_second.x), 2) +
                    powf(Float(pos_first.y - pos_second.y), 2) +
                    powf(Float(pos_first.z - pos_second.z), 2))
    }
    
}
