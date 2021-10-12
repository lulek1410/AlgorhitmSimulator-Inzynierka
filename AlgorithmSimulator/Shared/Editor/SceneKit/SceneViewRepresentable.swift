//
//  SceneViewRepresentable.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 21/04/2021.
//

import SwiftUI
import SceneKit

/// Represents SCNView to allow its use in SwiftUI app.
struct SceneViewRepresentable: NSViewRepresentable {
    
    /// Contents of view
    let content = Content()
    
    /// Initializes ScneViewRepresentable
    init() {
        self.content.coordinator = Coordinator(content.view)
    }
    
    /// Creates the view object and configures its initial state.
    ///
    ///  - Parameters:
    ///      - context: *A context structure containing information about the current state of the system.*
    ///
    ///  - Returns: configured SCNView
    func makeNSView(context: Context) -> SCNView {
        content.createView()
        content.addCamera()
        
        // Add gesture recognizer
        let tapGesture = NSClickGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleClick(_:)))
        content.view.addGestureRecognizer(tapGesture)

        return content.view
    }
    
    /// Updates the state of the specified view with new information from SwiftUI.
    ///
    /// - Parameters:
    ///     - view: *view that we want to update*
    ///     - context: *structure containing information about the current state of the system*
    func updateNSView(_ view: SCNView, context: Context) {
        view.scene = content.scene
        view.allowsCameraControl = true
        view.showsStatistics = true
    }
    
    /// Gets coordinator from content.
    ///
    /// - Returns: Coordinator present in content
    func makeCoordinator() -> Coordinator {
        return self.content.coordinator!
    }
}
