//
//  algorithms.swift
//  Test (iOS)
//
//  Created by Janek on 27/08/2021.
//

import Foundation
import SceneKit

/// Algorithms model holding variables responsible for control of algorithmMenuView.
struct Algorithms {
    
    /// Boolean variable informing if dijkstra algorithm is currently picked as algorithm to be used during search.
    var dijkstra: Bool = false
    
    /// Boolean variable informing if A star algorithm is currently picked as algorithm to be used during search.
    var astar: Bool = false
    
    /// Boolean variable informing if custom implementation of dijkstra algorithm utilizing multiple threads is currently picked as algorithm to be used during. search.
    var dijkstra_threads: Bool = false
    
    /// Grid of nodes on which the algorithm operates.
    var grid: Grid?
    
    /// Variable used to mnipulte disable option of start button when either algorithm runs.
    var disable_start_button = false
    
    /// Informations displayed in algorhitms menu informing on currently performed actions or problems.
    var information: String = ""
    
    /// Time algorhitm needs to find path.
    var algorithm_time: Double = 0
    
    /// Number of nodes processed by algorhitm in order to find path.
    var algorithm_nodes_processed: Int = 0
    
    /// Number of nodes from start point to end point.
    var nodes_from_start_to_end: Int = 0
    
    /// Distance betwean start and end point beeing length of the path in 3D space.
    var distance: Float = 0
    
    /// All obstacles algorithm has to take into consideration during search.
    var obstacles: [SCNNode]?
    
    /// Number determining cost multiplication of distance betwean nodes when their altitude is different.
    var altidute_cost_modifier: Float = 1
    
    /// Instance containing instructions to formatting numerical inputs in text fields.
    let formatter = Formatter()
}
