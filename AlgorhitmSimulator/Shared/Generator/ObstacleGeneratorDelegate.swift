//
//  ObstacleGeneratorDelegate.swift
//  Test
//
//  Created by Janek on 21/04/2021.
//

import Foundation
import SceneKit

/// Delegation protocol used to inform about creation of new obstacle.
protocol ObstacleGeneratorDelegate : AnyObject {
    
    /// Perform action when new obstacle is created
    ///
    /// - Parameters:
    ///     - obstacle: *Newly created obstacle*
    func obstacleCreated(_ obstacle: SCNNode)
}
