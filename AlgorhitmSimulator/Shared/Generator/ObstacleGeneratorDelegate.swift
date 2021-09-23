//
//  ObstacleGeneratorDelegate.swift
//  Test
//
//  Created by Janek on 21/04/2021.
//

import Foundation
import SceneKit

protocol ObstacleGeneratorDelegate : AnyObject {
    func obstacleCreated(_ obstacle: SCNNode)
}
