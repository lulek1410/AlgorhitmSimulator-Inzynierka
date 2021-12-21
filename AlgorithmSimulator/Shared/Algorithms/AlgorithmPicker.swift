//
//  Astart.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 01/09/2021.
//

import SceneKit

/// Class that allows picking different shortest path algorithms
class AlgorithmPicker {
    
    /// Implementation of A* shortest path algorithm.
    ///
    /// - Parameters:
    ///     - grid: *grid containing nodes on which the algorithm operates*
    ///     - work_item: *work item that executes this function (used to break function execution when needed)*
    ///     - altitude_cost_modifier: *value determining how distance is modified if nodes altitude changes*
    /// - Returns: Number of nodes that has beed processed in order to find a path betwean start and end nodes.
    static func Astar(grid : Grid,
                      work_item : DispatchWorkItem,
                      altitude_change_cost_modifier: Float,
                      altitude_movement_cost_modifier: Float,
                      dynamic_path: Bool,
                      path_drawer: DrawPathDelegate) -> Int {
        
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
            if min == nodes[grid.end_point[0]][grid.end_point[1]][grid.end_point[2]] {
                return nodes_processed
            }
            for x in -1 ..< 2{
                for y in -1 ..< 2 {
                    for z in -1 ..< 2 {
                        guard let processed_node = nodes[safe:Int(min!.position.x)+x]?[safe:Int(min!.position.y)+y]?[safe:Int(min!.position.z)+z] else {
                            continue
                        }
                        // Check if node is right for processing
                        if !closed.contains(processed_node) && processed_node.is_traversable {
                            let new_dist_from_source = min!.source_dist +
                            calculateDistance(pos_first: min!.position,
                                              pos_second: processed_node.position,
                                              altitude_change_cost_modifier: altitude_change_cost_modifier,
                                              altitude_movement_cost_modifier: altitude_movement_cost_modifier)
                            
                            // if new distance is besster than previous we set new values for curently
                            // processed node
                            if new_dist_from_source < processed_node.source_dist {
                                nodes_processed += 1
                                processed_node.parent = min
                                processed_node.source_dist = new_dist_from_source
                                processed_node.distance = processed_node.source_dist +
                                calculateDistance(pos_first: processed_node.position,
                                                  pos_second: end_position,
                                                  altitude_change_cost_modifier: altitude_change_cost_modifier,
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
    
    /// Implementation of Dijkstra shortest path algorithm.
    ///
    /// - Parameters:
    ///     - grid: *grid containing nodes on which the algorithm operates*
    ///     - work_item: *work item that executes this function (used to break function execution when needed)*
    ///     - altitude_cost_modifier: *value determining how distance is modified if nodes altitude changes*
    /// - Returns: Number of nodes that has beed processed in order to find a path betwean start and end nodes.
    static func Dijkstra(grid : Grid,
                         work_item : DispatchWorkItem,
                         altitude_change_cost_modifier : Float) -> Int {
        
        let nodes = grid.nodes
        var nodes_processed : Int = 0
        nodes[grid.start_point[0]][grid.start_point[1]][grid.start_point[2]].distance = 0
        
        var priority_queue : PriorityQueue<Node> = PriorityQueue<Node>(ascending: true, startingValues: [nodes[grid.start_point[0]][grid.start_point[1]][grid.start_point[2]]])
        
        var closed : [Node] = []
        
        while !priority_queue.isEmpty {
            if work_item.isCancelled {break}
            let min = priority_queue.pop()
            closed.append(min!)
            if min == grid.getEndingPoint() {
                print(min!.distance)
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
                            self.calculateDistance(pos_first: min!.position,
                                                   pos_second: processed_node.position,
                                                   altitude_change_cost_modifier: 1,
                                                   altitude_movement_cost_modifier: 1)
                            // if new distance is besster than previous we set new values for curently
                            // processed node
                            if new_dist < processed_node.distance {
                                nodes_processed += 1
                                processed_node.distance = new_dist
                                //print(new_dist)
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
    
    /// Implementation of Dijkstra shortest path algorithm utilizing multiple threads to improve performance.
    ///
    /// - Parameters:
    ///     - grid: *grid containing nodes on which the algorithm operates*
    ///     - work_item: *work item that executes this function (used to break function execution when needed)*
    ///     - altitude_cost_modifier: *value determining how distance is modified if nodes altitude changes*
    /// - Returns: Number of nodes that has beed processed in order to find a path betwean start and end nodes.
    static func concurrentDijkstra(grid : Grid,
                                   work_item : DispatchWorkItem,
                                   altitude_change_cost_modifier : Float,
                                   altitude_movement_cost_modifier: Float) -> Int{
        
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
    
    static func bidirectionalDijkstra(grid : Grid,
                                      work_item : DispatchWorkItem,
                                      altitude_change_cost_modifier : Float,
                                      altitude_movement_cost_modifier: Float) -> (Int) {
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
            group.enter()
            DispatchQueue.global().async {
                guard let forward_next = queue_start.pop() else {
                    run = false
                    group.leave()
                    return
                }
                closed_start.append(forward_next)
                current_min_cost_start = forward_next.distance
                if current_min_cost_start + current_min_cost_end + min_unit_cost >= min_cost{
                    run = false
                }
                else if forward_next == grid.getEndingPoint() {
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
            grid.getEndingPoint()?.distance = current.r_dist + current.distance
            while(current != grid.getEndingPoint()){
                let previous = current.r_parent
                previous?.parent = current
                current = previous!
            }
        }
        return nodes_processed
    }
    
    
    /// Calculates distance betwean 2 points in 3D space
    ///
    /// - Parameters:
    ///     - pos_first: *position of first point*
    ///     - pos_second: *position of second point*
    ///     - altitude_cost_modifier: *value determining how distance is modified if nodes altitude changes*
    /// - Returns: Distance betwean pos_first and pos_second
    private static func calculateDistance(pos_first: SCNVector3,
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
        print(result, pos_first, pos_second)
        return result
    }
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}




