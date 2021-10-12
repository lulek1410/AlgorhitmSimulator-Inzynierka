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
    
    /// Variable used to limit access to size properties when currently selected object is the floor object.
    var disabled_floor : Bool = false
    
    /// Variable used to limit access to size properties when currently selected object is start or end point.
    var disabled_startend : Bool = false
}
