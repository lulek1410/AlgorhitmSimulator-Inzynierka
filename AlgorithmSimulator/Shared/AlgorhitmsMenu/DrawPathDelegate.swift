//
//  DrawPathDelegate.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 06/09/2021.
//

import SceneKit

/// Delegate sending information to preview of map
protocol DrawPathDelegate: AnyObject {
    
    /// Creates path discovered by algorithm and displays it.
    ///
    /// - Parameters:
    ///     - grid: *Whole grid of nodes on which the algorithm operates*
    func drawPath(node: Node, algorithm_name: String)
    
    /// Requasts currenlty displayed obstacles
    func askForObstacles()
    
    /// Deletes path from start to end point that is curently displayed in the preview.
    func clearPath(name: String)
}
