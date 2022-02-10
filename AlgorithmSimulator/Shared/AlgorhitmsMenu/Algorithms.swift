//
//  algorithms.swift
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

struct Algorithms {
    
    var dijkstra: Bool = false
    var astar: Bool = false
    var dijkstra_threads: Bool = false
    var bidirectional: Bool = false
    var grid: Grid?
    var disable_start_button = false
    var information: String = ""
    var algorithm_time: Double = 0
    var algorithm_nodes_processed: Int = 0
    var nodes_from_start_to_end: Int = 0
    var distance: Float = 0
    var obstacles: [SCNNode]?
    var altidute_change_cost_modifier: Float = 1
    var altitude_movement_cost_modifier: Float = 1
    var fixed_height_value: Int = 0
    var dynamic_path_display: Bool = false
    var display_all_visited: Bool = false
    var heuristics_type: String = "Euclidean"
    var fixed_height: Bool = false
    let formatter = Formatter()
}
