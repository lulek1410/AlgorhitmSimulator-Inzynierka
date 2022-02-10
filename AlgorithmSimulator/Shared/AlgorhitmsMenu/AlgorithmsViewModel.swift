//
//  AlgorithmsViewModel.swift
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

enum HeuristicsType : String, CaseIterable, Identifiable {
    case Diagonal = "Diagonal"
    case Euclidean = "Euclidean"
    var id : String {self.rawValue}
}

class AlgorithmsViewModel : ObservableObject, ObstaclesForAlgorithmDelegate {

    @Published var model = Algorithms()
    weak var draw_delegate : DrawPathDelegate?
    var work_item : DispatchWorkItem?

    func setAlgorithmObstacles(obstacles: [SCNNode]) {
        model.obstacles = obstacles
    }

    func start(){
        
        draw_delegate?.askForObstacles()
        if model.fixed_height {
            model.grid = Grid(obstacles: model.obstacles!, height: model.fixed_height_value)
        }
        else {
            model.grid = Grid(obstacles: model.obstacles!)
        }
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
    
    func checkStartEndSet() -> (Bool, Bool) {
        return (self.model.grid?.start_point != [-1, -1, -1], self.model.grid?.end_point != [-1, -1, -1])
    }

    func startAlgorithm() {
        if model.display_all_visited {
            draw_delegate?.clearPath(name: "All")
        }
        else {
            deletePaths()
        }
        if model.astar {
            runAstar()
        }
        else if model.dijkstra {
            runDijkstra()
        }
        else if model.dijkstra_threads {
            runConcurrentDijkstra()
        }
        else if model.bidirectional {
            runBidirectionalDijkstra()
        }
        else {
            model.information = "Algorhytm not selected"
        }
    }

    func runAstar(){
        self.work_item = DispatchWorkItem {
            DispatchQueue.main.sync {
                self.updateStartSearch()
            }
            
            let start = DispatchTime.now()
            
            let processed_nodes = Astar(grid: self.model.grid!,
                                        work_item: self.work_item!,
                                        altitude_change_cost_modifier: self.model.altidute_change_cost_modifier,
                                        altitude_movement_cost_modifier: self.model.altitude_movement_cost_modifier,
                                        dynamic_path_display: self.model.dynamic_path_display,
                                        path_drawer: self.draw_delegate!,
                                        heuristics_type: self.model.heuristics_type,
                                        display_all: self.model.display_all_visited)
            let end = DispatchTime.now()
            let nano_time = end.uptimeNanoseconds - start.uptimeNanoseconds
            let time_interval = Double(nano_time) / 1_000_000_000
            
            DispatchQueue.main.sync {
                self.updateEndSearch(time: time_interval, nodes_num : processed_nodes)
                let end_node = self.model.grid!.nodes[(self.model.grid!.end_point[0])][self.model.grid!.end_point[1]][self.model.grid!.end_point[2]]
                let name = "A* " + self.model.heuristics_type
                if !self.model.display_all_visited {
                    self.draw_delegate?.clearPath(name: name)
                }
                self.draw_delegate?.drawPath(node: end_node, algorithm_name: name)
            }
        }
        
        if self.work_item != nil {
            DispatchQueue.global().async(execute: self.work_item!)
        }
    }

    func runDijkstra() {
        self.work_item = DispatchWorkItem {
            DispatchQueue.main.sync {
                self.updateStartSearch()
            }
            
            let start = DispatchTime.now()
            let processed_nodes = Dijkstra(grid: self.model.grid!,
                                           work_item: self.work_item!,
                                           altitude_change_cost_modifier : self.model.altidute_change_cost_modifier,
                                           altitude_movement_cost_modifier: self.model.altitude_movement_cost_modifier,
                                           dynamic_path_display: self.model.dynamic_path_display,
                                           path_drawer: self.draw_delegate!,
                                           display_all: self.model.display_all_visited)
            let end = DispatchTime.now()
            let nano_time = end.uptimeNanoseconds - start.uptimeNanoseconds
            let time_interval = Double(nano_time) / 1_000_000_000
            
            DispatchQueue.main.sync {
                self.updateEndSearch(time: time_interval, nodes_num: processed_nodes)
                let end_node = self.model.grid!.nodes[(self.model.grid!.end_point[0])][self.model.grid!.end_point[1]][self.model.grid!.end_point[2]]
                if !self.model.display_all_visited {
                    self.draw_delegate?.clearPath(name: "Dijkstra")
                }
                self.draw_delegate?.drawPath(node: end_node, algorithm_name: "Dijkstra")
            }
        }
        
        if self.work_item != nil {
            DispatchQueue.global().async(execute: self.work_item!)
        }
    }

    func runConcurrentDijkstra() {
        self.work_item = DispatchWorkItem {
            DispatchQueue.main.sync {
                self.updateStartSearch()
            }
            let start = DispatchTime.now()
            let processed_nodes = concurrentDijkstra(grid: self.model.grid!,
                                                     work_item: self.work_item!,
                                                     altitude_change_cost_modifier : self.model.altidute_change_cost_modifier,
                                                     altitude_movement_cost_modifier: self.model.altitude_movement_cost_modifier,
                                                     dynamic_path_display: self.model.dynamic_path_display,
                                                     path_drawer: self.draw_delegate!,
                                                     display_all: self.model.display_all_visited)
            let end = DispatchTime.now()
            let nano_time = end.uptimeNanoseconds - start.uptimeNanoseconds
            let time_interval = Double(nano_time) / 1_000_000_000
            
            DispatchQueue.main.sync {
                self.updateEndSearch(time: time_interval, nodes_num: processed_nodes)
                let end_node = self.model.grid?.getEndingPoint()
                if !self.model.display_all_visited {
                    self.draw_delegate?.clearPath(name: "Dijkstra Threads")
                }
                self.draw_delegate?.drawPath(node: end_node!, algorithm_name: "Dijkstra Threads")
            }
        }
        if self.work_item != nil {
            DispatchQueue.global().async(execute: self.work_item!)
        }
    }
    
    func runBidirectionalDijkstra(){
        self.work_item = DispatchWorkItem {
            DispatchQueue.main.sync {
                self.updateStartSearch()
            }
            let start = DispatchTime.now()
            let result = bidirectionalDijkstra(grid: self.model.grid!,
                                               work_item: self.work_item!,
                                               altitude_change_cost_modifier : self.model.altidute_change_cost_modifier,
                                               altitude_movement_cost_modifier: self.model.altitude_movement_cost_modifier,
                                               dynamic_path_display: self.model.dynamic_path_display,
                                               path_drawer: self.draw_delegate!,
                                               display_all: self.model.display_all_visited)
            let end = DispatchTime.now()
            let nano_time = end.uptimeNanoseconds - start.uptimeNanoseconds
            let time_interval = Double(nano_time) / 1_000_000_000
            
            DispatchQueue.main.sync {
                let path_found = result.0 != -1
                let end_node = self.model.grid?.getEndingPoint()
                self.updateEndSearch(time: time_interval, nodes_num: result.0, bidirectional_path_found: path_found)
                if !self.model.display_all_visited {
                    self.draw_delegate?.clearPath(name: "Bidirectional Dijkstra")
                }
                self.draw_delegate?.drawPath(node: end_node!, algorithm_name: "Bidirectional Dijkstra Start")
            }
        }
        if self.work_item != nil {
            DispatchQueue.global().async(execute: self.work_item!)
        }
    }

    private func updateStartSearch() {
        model.disable_start_button = true
        model.information = "Searching"
    }

    private func updateEndSearch(time : Double, nodes_num : Int, bidirectional_path_found: Bool = false) {
        model.nodes_from_start_to_end = 0
        model.distance = 0
        if self.model.grid?.getEndingPoint()!.parent != nil || bidirectional_path_found{
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
    
    func disableAStarCheck() -> Bool{
        return model.dijkstra || model.dijkstra_threads || model.bidirectional
    }
    
    func disableDijkstraCheck() -> Bool{
        return model.astar || model.dijkstra_threads || model.bidirectional
    }
    
    func disableDijkstraThreadsCheck() -> Bool{
        return model.astar || model.dijkstra || model.bidirectional
    }
    
    func disableBidirectionalDijkstraCheck() -> Bool{
        return model.astar || model.dijkstra || model.dijkstra_threads
    }
    
    func deletePaths(){
        if model.astar {
            let name : String = "A* " + self.model.heuristics_type
            draw_delegate?.clearPath(name: name)
        }
        else if model.dijkstra {
            draw_delegate?.clearPath(name: "Dijkstra")
        }
        else if model.dijkstra_threads {
            draw_delegate?.clearPath(name: "Dijkstra Threads")
        }
        else if model.bidirectional {
            draw_delegate?.clearPath(name: "Bidirectional Dijkstra")
        }
        else {
            draw_delegate?.clearPath(name: "All")
        }
        
    }

    private func calculateNodesFromStartToEnd(node : Node){
        if let parent = node.parent {
            model.nodes_from_start_to_end += 1
            calculateNodesFromStartToEnd(node: parent)
        }
    }

    func breakAlgothitm() {
        work_item?.cancel()
    }
}
