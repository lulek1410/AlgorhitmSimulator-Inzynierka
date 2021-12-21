//
//  Properties.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 22/04/2021.
//

import SwiftUI

/// Size property holders.
struct Size{
    
    /// Variable holding objects width for object creation or update.
    var width: CGFloat = 0
    
    /// Variable holding objects height for object creation or update.
    var height: CGFloat = 0
    
    /// Variable holding objects length for object creation or update.
    var length: CGFloat = 0
    
    /// variable holding objects radius in cese of sperical objects
    var radius: CGFloat = 0
    
    /// Variable used to limit access to size properties when currently selected object is the floor object.
    var disable_floor : Bool = false
    
    var disable_width_height: Bool = false
    
    var disable_radius: Bool = true
    
    /// Variable used to limit access to size properties when currently selected object is start or end point.
    var disable_startend : Bool = false
}
