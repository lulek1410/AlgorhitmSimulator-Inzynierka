//
//  SceneKitView.swift
//  bcd
//
//  Created by Janek on 29/03/2021.
//

import SwiftUI
import SceneKit

/// View containing representable of SCNView.
struct SceneKitView: View {
    
    /// representable of view to display.
    let scene_view_representable = SceneViewRepresentable()
    
    /// Body of view.
    var body: some View {
        scene_view_representable
    }
}
