//
//  UpdatePositionDelegate.swift
//  Test
//
//  Created by Janek on 09/08/2021.
//

import SceneKit

/// Delegation protocol used to update position values of currently picked object..
protocol UpdatePositionDelegate : AnyObject {
    
    /// Updates x axis position.
    ///
    /// - Parameters:
    ///     - new_x: *x position to set as new *
    func updateXPosition(new_x : CGFloat)
    
    /// Updates y axis position.
    ///
    /// - Parameters:
    ///     - new_y: *y position to set as new *
    func updateYPosition(new_y : CGFloat)
    
    /// Updates z axis position.
    ///
    /// - Parameters:
    ///     - new_z: *z position to set as new *
    func updateZPosition(new_z : CGFloat)
}
