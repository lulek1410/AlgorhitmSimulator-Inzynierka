//
//  Content.swift
//  AlgorithmSimulator-macOS
//
//  Copyright (c) 2021 Jan Szewczyński
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

import SceneKit

/// Holder of elements needed to display.
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
