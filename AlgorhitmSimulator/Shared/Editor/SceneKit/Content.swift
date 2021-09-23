//
//  Content.swift
//  Test
//
//  Created by Janek on 17/07/2021.
//

import Foundation
import SceneKit

class Content {
    
    let scene = SCNScene()
    let view = SCNView()
    var coordinator : Coordinator? = nil
    
    func createView(){
        view.scene = scene
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        view.showsStatistics = true
    }
    
    func addCamera(){
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(15, 10, 10)
        cameraNode.name = "Camera"
        cameraNode.eulerAngles = SCNVector3(-Double.pi/8, 0, 0)
        scene.rootNode.addChildNode(cameraNode)
    }
    
}
