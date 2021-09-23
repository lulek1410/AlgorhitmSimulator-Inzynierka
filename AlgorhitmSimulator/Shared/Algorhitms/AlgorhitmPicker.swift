//
//  Astart.swift
//  Test
//
//  Created by Janek on 01/09/2021.
//

import SceneKit
import SwiftPriorityQueue
import SceneKit

class AlgorhitmPicker {
    
    static var work_item : DispatchWorkItem?
    
    static func Astar(grid : Grid, work_item : DispatchWorkItem) -> Int {
        let nodes = grid.nodes
        var nodes_processed : Int = 0
        
        let start_position = SCNVector3(grid.start_point[0], grid.start_point[1], grid.start_point[2])
        let end_position = SCNVector3(grid.end_point[0], grid.end_point[1], grid.end_point[2])
        
        nodes[grid.start_point[0]][grid.start_point[1]][grid.start_point[2]].distance = calculateDistance(pos_first: start_position, pos_second: end_position)
        nodes[grid.start_point[0]][grid.start_point[1]][grid.start_point[2]].source_dist = 0
        
        
        var priority_queue : PriorityQueue<Node> = PriorityQueue<Node>(ascending: true, startingValues: [nodes[grid.start_point[0]][grid.start_point[1]][grid.start_point[2]]])
        
        var closed : [Node] = []
        
        while !priority_queue.isEmpty {
            if work_item.isCancelled {break}
            let min = priority_queue.pop()
            closed.append(min!)
            if min == nodes[grid.end_point[0]][grid.end_point[1]][grid.end_point[2]] {
                return nodes_processed
            }
            for x in -1 ..< 2{
                for y in -1 ..< 2 {
                    for z in -1 ..< 2 {
                        guard let processed_node = nodes[safe:Int(min!.position.x)+x]?[safe:Int(min!.position.y)+y]?[safe:Int(min!.position.z)+z] else {
                            continue
                        }
                        if !closed.contains(processed_node) && processed_node.is_traversable {
                            let new_dist_from_source = min!.source_dist + calculateDistance(pos_first: min!.position,
                                                                                            pos_second: processed_node.position)
                            if new_dist_from_source < processed_node.source_dist {
                                nodes_processed += 1
                                processed_node.parent_node = min
                                processed_node.source_dist = new_dist_from_source
                                processed_node.distance = processed_node.source_dist + calculateDistance(pos_first: processed_node.position, pos_second: end_position)
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
    
    static func Dijkstra(grid : Grid, work_item : DispatchWorkItem) -> Int {
        let nodes = grid.nodes
        var nodes_processed : Int = 0
        nodes[grid.start_point[0]][grid.start_point[1]][grid.start_point[2]].distance = 0
        
        var priority_queue : PriorityQueue<Node> = PriorityQueue<Node>(ascending: true, startingValues: [nodes[grid.start_point[0]][grid.start_point[1]][grid.start_point[2]]])
        
        var closed : [Node] = []
        
        while !priority_queue.isEmpty {
            if work_item.isCancelled {break}
            let min = priority_queue.pop()
            closed.append(min!)
            if min == nodes[grid.end_point[0]][grid.end_point[1]][grid.end_point[2]] {
                return nodes_processed
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
                                nodes_processed += 1
                                processed_node.distance = new_dist
                                processed_node.parent_node = min
                                priority_queue.push(processed_node)
                            }
                        }
                    }
                }
            }
        }
        return nodes_processed
    }
    
    static func concurrentDijkstra(grid : Grid, work_item : DispatchWorkItem) -> Int{
        let nodes = grid.nodes
        var closed = [Node]()
        let lock = NSLock()
        var nodes_processed : Int = 0
        let group = DispatchGroup()
        
        var priority_queue : PriorityQueue<Node> = PriorityQueue<Node>(ascending: true)
        nodes[grid.start_point[0]][grid.start_point[1]][grid.start_point[2]].distance = 0
        priority_queue.push(nodes[grid.start_point[0]][grid.start_point[1]][grid.start_point[2]])
        
        while !priority_queue.isEmpty {
            if work_item.isCancelled{break}
            let min = priority_queue.pop()
            closed.append(min!)
            if min == nodes[grid.end_point[0]][grid.end_point[1]][grid.end_point[2]] {
                return nodes_processed
            }
            for x in -1 ..< 2{
                group.enter()
                DispatchQueue.global().async {
                    var num_of_processed_nodes = 0
                    let x_t = x
                    for y in -1 ..< 2 {
                        for z in -1 ..< 2 {
                            guard let processed_node = nodes[safe:Int(min!.position.x)+x_t]?[safe:Int(min!.position.y)+y]?[safe:Int(min!.position.z)+z] else {
                                continue
                            }
                            if processed_node.is_traversable && !closed.contains(processed_node) {
                                let new_dist = min!.distance + calculateDistance(pos_first: min!.position, pos_second: processed_node.position)
                                
                                if new_dist < processed_node.distance{
                                    num_of_processed_nodes += 1
                                    processed_node.distance = new_dist
                                    processed_node.parent_node = min!
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
    
    private static func calculateDistance(pos_first : SCNVector3, pos_second : SCNVector3) -> Float{
        return
            sqrtf(powf(Float(pos_first.x - pos_second.x), 2) +
                    powf(Float(pos_first.y - pos_second.y), 2) +
                    powf(Float(pos_first.z - pos_second.z), 2))
    }
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
