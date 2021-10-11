//
//  AlgorithmsViewModel.swift
//  Test (iOS)
//
//  Created by Janek on 27/08/2021.
//

import SceneKit

/// View Model class responsible for responding to events that occur in view that it operates on (AlgorithmsMenuView)
class AlgorithmsViewModel : ObservableObject, ObstaclesForAlgorithmDelegate {
    
    /// Model variable holding parameter used to controll algorithm menu.
    @Published var model = Algorithms()
    
    /// Delegate variable used to delegate drawing path found by algorithm betwean points.
    weak var draw_delegate : DrawPathDelegate?
    
    /// Variable that encapsulates work to be executed in dispatch queues.
    var work_item : DispatchWorkItem?
    
    /// Sets obstacles present in preview scene to be included during algorithms run.
    ///
    /// - Parameters:
    ///     - obstacles: *obstacle objects currently present in preview scene*
    func setAlgorithmObstacles(obstacles: [SCNNode]) {
        model.obstacles = obstacles
    }
    
    /// Runs selected algorithm or updates dispalyed information describeing problem which prevents algorithm run.
    func start(){
        draw_delegate?.clearPreviousPath()
        model.grid = Grid(obstacles: model.obstacles!)
        let result = checkStartEndSet()
        if result.0 && result.1 {
            startAlgorithm()
        }
        else if result.0 && !result.1 {
            model.information = "End point is not set or is out of bounds"
        }
        else if !result.0 && result.1 {
            model.information = "Start point is not set or is out of bounds"
        }
        else if !result.0 && !result.1 {
            model.information = "start and end point not set or out of bounds"
        }
    }
    
    /// Checks if start and end points for algorithm were set by user.
    ///
    /// - Returns :
    /// 1. boolean corresponding to start point beeing present in algorithms grid
    /// 2. boolean corresponding to end point beeing present in algorithms grid
    func checkStartEndSet() -> (Bool, Bool) {
        return (self.model.grid?.start_point != [-1, -1, -1], self.model.grid?.end_point != [-1, -1, -1])
    }
    
    ///  Starts running selected algorithm
    func startAlgorithm() {
        if model.astar {
            runAstar()
        }
        
        else if model.dijkstra {
            runDijkstra()
        }
        else if model.dijkstra_threads {
            runConcurrentDijkstra()
        }
        else {
            model.information = "Algorhytm not selected"
            print(model.information)
        }
    }
    
    /// Runs A star shortest path algorithm on dispatch queue to prevent aplication from freezing.
    func runAstar(){
        self.work_item = DispatchWorkItem {
            DispatchQueue.main.sync {
                self.updateStartSearch()
            }
            
            let start = DispatchTime.now()
            let processed_nodes = AlgorithmPicker.Astar(grid: self.model.grid!,
                                                        work_item: self.work_item!,
                                                        altitude_cost_modifier : self.model.altidute_cost_modifier)
            let end = DispatchTime.now()
            let nano_time = end.uptimeNanoseconds - start.uptimeNanoseconds
            let time_interval = Double(nano_time) / 1_000_000_000
            
            DispatchQueue.main.sync {
                self.updateEndSearch(time: time_interval, nodes_num : processed_nodes)
            }
        }
        
        if self.work_item != nil {
            DispatchQueue.global().async(execute: self.work_item!)
        }
    }
    
    /// Runs Dijkstra shortest path algorithm on dispatch queue to prevent aplication from freezing.
    func runDijkstra() {
        self.work_item = DispatchWorkItem {
            DispatchQueue.main.sync {
                self.updateStartSearch()
            }
            
            let start = DispatchTime.now()
            let processed_nodes = AlgorithmPicker.Dijkstra(grid: self.model.grid!,
                                                           work_item: self.work_item!,
                                                           altitude_cost_modifier : self.model.altidute_cost_modifier)
            let end = DispatchTime.now()
            let nano_time = end.uptimeNanoseconds - start.uptimeNanoseconds
            let time_interval = Double(nano_time) / 1_000_000_000
            
            DispatchQueue.main.sync {
                self.updateEndSearch(time: time_interval, nodes_num: processed_nodes)
            }
        }
        
        if self.work_item != nil {
            DispatchQueue.global().async(execute: self.work_item!)
        }
    }
    
    /// Runs custom implementetion of Dijkstra shortest path algorithm utilizing multiple threads on dispatch queue to prevent aplication from freezing.
    func runConcurrentDijkstra() {
        self.work_item = DispatchWorkItem {
            DispatchQueue.main.sync {
                self.updateStartSearch()
            }
            let start = DispatchTime.now()
            let processed_nodes = AlgorithmPicker.concurrentDijkstra(grid: self.model.grid!,
                                                                     work_item: self.work_item!,
                                                                     altitude_cost_modifier : self.model.altidute_cost_modifier)
            let end = DispatchTime.now()
            let nano_time = end.uptimeNanoseconds - start.uptimeNanoseconds
            let time_interval = Double(nano_time) / 1_000_000_000
            
            DispatchQueue.main.sync {
                self.updateEndSearch(time: time_interval, nodes_num: processed_nodes)
            }
        }
        if self.work_item != nil {
            DispatchQueue.global().async(execute: self.work_item!)
        }
    }
    
    /// Updates parameters informing that search of path has begun.
    private func updateStartSearch() {
        model.disable_start_button = true
        model.information = "Searching"
    }
    
    /// Updates parameters infroming user on used algorithm performance data and performs actions needed for user to acknowledge that search has ended (eg. diaplsy path or information that it failed to find one).
    ///
    /// - Parameters:
    ///     - time: *Time algorithm needed to find path*
    ///     - nodes_num: *Number of nodes which were processed by algorithm during its run*
    private func updateEndSearch(time : Double, nodes_num : Int) {
        model.nodes_from_start_to_end = 0
        model.distance = 0
        if self.model.grid?.nodes[(self.model.grid?.end_point[0])!][(self.model.grid?.end_point[1])!][(self.model.grid?.end_point[2])!].parent_node != nil {
            
            self.draw_delegate?.drawPath(grid: self.model.grid!)
            self.model.information = ""
            self.model.algorithm_time = time
            self.model.algorithm_nodes_processed = nodes_num
            let end = self.model.grid?.end_point
            self.model.distance = self.model.grid?.nodes[end![0]][end![1]][end![2]].distance ?? 0
            calculateNodesFromStartToEnd(node: (self.model.grid?.nodes[end![0]][end![1]][end![2]])!)
        }
        else {
            self.model.information = "Cant find path"
            self.model.algorithm_time = 0
            self.model.algorithm_nodes_processed = 0
        }
        self.model.disable_start_button = false
    }
    
    /// Calculates number of nodes from start to given node using recursion.
    ///
    /// - Parameters:
    ///     - node: *node from which we calculate 'node distance' to start point (in our case it is always end node)*
    private func calculateNodesFromStartToEnd(node : Node){
        if let parent = node.parent_node {
            model.nodes_from_start_to_end += 1
            calculateNodesFromStartToEnd(node: parent)
        }
    }
    
    /// Stops algorithm thet is currently running.
    func breakAlgothitm() {
        work_item?.cancel()
    }
}
