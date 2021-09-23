//
//  ObstaclesDelegate.swift
//  Test
//
//  Created by Janek on 29/08/2021.
//

import Foundation
import SceneKit

protocol ObstaclesDelegate : AnyObject {
    func setObstacles(obstacles : [SCNNode])
}
