//
//  SceneViewRepresentable.swift
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
