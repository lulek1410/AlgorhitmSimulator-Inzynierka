//
//  UpdateSizeDelegate.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 09/08/2021.
//

import SceneKit

/// Delegation protocol used to update size of curently selected object.
protocol UpdateSizeDelegate : AnyObject {
    
    /// Updates width parameter.
    ///
    /// - Parameters:
    ///     - new_width: *width parameter to set as new *
    func updateWidth(new_width: CGFloat)
    
    /// Updates height parameter.
    ///
    /// - Parameters:
    ///     - new_height: *height parameter to set as new *
    func updateHeight(new_height: CGFloat)
    
    /// Updates length parameter.
    ///
    /// - Parameters:
    ///     - new_length: *length parameter to set as new *
    func updateLength(new_length: CGFloat)
    
    func updateRadius(new_radius: CGFloat)
}
