//
//  Position.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 22/04/2021.
//

import SwiftUI
import SceneKit

/// Position properties holder
struct Position{
    
    /// Variable holding position for object creation or update
    var position : SCNVector3 = SCNVector3(0, 0, 0)
    
    /// Variable decideing weather the view is accesible to the user
    var disabled : Bool = false
}
