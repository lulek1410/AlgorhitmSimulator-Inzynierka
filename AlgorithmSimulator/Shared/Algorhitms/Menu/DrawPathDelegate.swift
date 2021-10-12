//
//  DrawPathDelegate.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 06/09/2021.
//

/// Delegate sending information to preview of map
protocol DrawPathDelegate : AnyObject {
    
    /// Creates path discovered by algorithm and displays it.
    ///
    /// - Parameters:
    ///     - grid: *Whole grid of nodes on which the algorithm operates*
    func drawPath(grid : Grid)
    
    /// Deletes path from start to end point that is curently displayed in the preview.
    func clearPreviousPath()
}
