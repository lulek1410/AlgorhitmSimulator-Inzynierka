//
//  AlgorhitmsViewModel.swift
//  Test (iOS)
//
//  Created by Janek on 27/08/2021.
//

import SceneKit

class AlgorhitmsViewModel : ObservableObject, ObstaclesDelegate {
    @Published var model = Algorhitms()
    weak var draw_delegate : DrawPathDelegate?
    var work_item : DispatchWorkItem?
    
    func setObstacles(obstacles: [SCNNode]) {
        model.obstacles = obstacles
    }
    
    func start(){
        draw_delegate?.clearPreviousPath()
        model.grid = Grid(obstacles: model.obstacles!)
        let result = checkStartEndSet()
        if result.0 && result.1 {
            startAlgorhitm()
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
    
    func startAlgorhitm() {
        if model.astar {
            self.work_item = DispatchWorkItem {
                DispatchQueue.main.sync {
                    self.updateStartSearch()
                }
                
                let start = DispatchTime.now()
                let processed_nodes = AlgorhitmPicker.Astar(grid: self.model.grid!,
                                                            work_item: self.work_item!)
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
        
        else if model.dijkstra {
            self.work_item = DispatchWorkItem {
                DispatchQueue.main.sync {
                    self.updateStartSearch()
                }
                
                let start = DispatchTime.now()
                let processed_nodes = AlgorhitmPicker.Dijkstra(grid: self.model.grid!,
                                                               work_item: self.work_item!)
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
        else if model.dijkstra_threads {
            self.work_item = DispatchWorkItem {
                DispatchQueue.main.sync {
                    self.updateStartSearch()
                }
                let start = DispatchTime.now()
                let processed_nodes = AlgorhitmPicker.concurrentDijkstra(grid: self.model.grid!,
                                                                         work_item: self.work_item!)
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
        else {
            model.information = "Algorhytm not selected"
            print(model.information)
        }
    }
    
    private func updateStartSearch() {
        model.disable_start_button = true
        model.information = "Searching"
    }
    
    private func updateEndSearch(time : Double, nodes_num : Int) {
        model.nodes_from_start_to_end = 0
        model.distance = 0
        if self.model.grid?.nodes[(self.model.grid?.end_point[0])!][(self.model.grid?.end_point[1])!][(self.model.grid?.end_point[2])!].parent_node != nil {
            
            self.draw_delegate?.drawPath(grid: self.model.grid!)
            self.model.information = ""
            self.model.algorhitm_time = time
            self.model.algorhitm_nodes_processed = nodes_num
            let end = self.model.grid?.end_point
            self.model.distance = self.model.grid?.nodes[end![0]][end![1]][end![2]].distance ?? 0
            calculateNodesFromStartToEnd(node: (self.model.grid?.nodes[end![0]][end![1]][end![2]])!)
        }
        else {
            self.model.information = "Cant find path"
            self.model.algorhitm_time = 0
            self.model.algorhitm_nodes_processed = 0
        }
        self.model.disable_start_button = false
    }
    
    private func calculateNodesFromStartToEnd(node : Node){
        if let parent = node.parent_node {
            model.nodes_from_start_to_end += 1
            calculateNodesFromStartToEnd(node: parent)
        }
    }
    
    func breakAlgothitm() {
        work_item?.cancel()
    }
}
