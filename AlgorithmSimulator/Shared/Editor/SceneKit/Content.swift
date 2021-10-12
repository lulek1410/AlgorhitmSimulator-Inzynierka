//
//  Content.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 17/07/2021.
//

import SceneKit

/// Holder of elements needed to display.
class Content {
    
    /// Scene on which we display 3D objects added by user.
    let scene = SCNScene()
    
    /// View on which we display scene with objects.
    let view = SCNView()
    
    /// View's events coordinator.
    var coordinator : Coordinator? = nil
    
    /// Create and configure view.
    func createView(){
        view.scene = scene
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        view.showsStatistics = true
    }
    
    /// Create camera with specific configuration and adds it to the scene.
    func addCamera(){
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(15, 10, 10)
        cameraNode.name = "Camera"
        cameraNode.eulerAngles = SCNVector3(-Double.pi/8, 0, 0)
        scene.rootNode.addChildNode(cameraNode)
    }
    
}
