//
//  SceneView.swift
//  bcd
//
//  Created by Janek on 21/04/2021.
//

import SwiftUI
import SceneKit

struct SceneViewRepresentable: NSViewRepresentable {
    
    let content = Content()
    
    init() {
        self.content.coordinator = Coordinator(content.view)
    }
    
    func makeNSView(context: Context) -> SCNView {
        content.createView()
        content.addCamera()
        // Add gesture recognizer
        let tapGesture = NSClickGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleClick(_:)))
        content.view.addGestureRecognizer(tapGesture)

        return content.view
    }
    
    func updateNSView(_ view: SCNView, context: Context) {
        view.scene = content.scene
        view.allowsCameraControl = true
        view.showsStatistics = true
    }
    func makeCoordinator() -> Coordinator {
        return self.content.coordinator!
    }
}
