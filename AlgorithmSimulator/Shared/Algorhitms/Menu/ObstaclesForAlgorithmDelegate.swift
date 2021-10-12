//
//  ObstaclesDelegate.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 29/08/2021.
//

import SceneKit

/// Delegate informing algorithms menu
protocol ObstaclesForAlgorithmDelegate : AnyObject {
    
    ///  Sets given obstacles as curently present in preview of the map
    ///
    ///  - Parameters:
    ///      - obstacles: *obstacles present in preview of the map*
    func setAlgorithmObstacles(obstacles : [SCNNode])
}
