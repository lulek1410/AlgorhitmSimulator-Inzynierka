//
//  ObjectTappedDelegate.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 24/07/2021.
//

import SceneKit

/// Delegate protocol used to delegate information from map scene coordinator to aplication's menu.
protocol EditorSceneDelegate : AnyObject{
    
    /// Delegates information about map object that was selected by user.
    ///
    /// - Parameters:
    ///     - object: *object selected by user in map preview*
    func objectTapped(object : SCNNode)
    
    /// Informs that starting point is curently not present in map.
    func startPointNotPresent()
    
    /// Informas that end point is curently not presetn in map.
    func endPointNotPresent()
    
    /// Infroms that start point is curently present in map.
    func startPointPresent()
    
    /// Infroms that enp point is curently present in map.
    func endPointPresent()
}
