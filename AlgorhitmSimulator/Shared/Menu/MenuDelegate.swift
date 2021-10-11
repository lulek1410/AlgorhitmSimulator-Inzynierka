//
//  DeleteSelectedObjectDelegate.swift
//  Test
//
//  Created by Janek on 12/08/2021.
//
import SceneKit

/// Delegation protocol used to delegate actions from MenuView.
protocol  MenuDelegate : AnyObject {
    
    /// Add created obstacle to the scene.
    ///
    /// - Parameters:
    ///     - object: *object which we want to add to the scene*
    func obstacleCreated(object : SCNNode)
    
    /// Delete currently selected object from the scene.
    func deleteSelectedObject()
}
