//
//  MapCoordinatesViewModel.swift
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

import Foundation
import SceneKit

class MapCoordinates {
    var start_coordinate_text = CoordinateText()
    var end_coordinate_text = CoordinateText()
    
    init() {
        start_coordinate_text.coordinates_text  = makeCoordinatesText(text: "(x = 0, z = 0)",
                                                                      position: SCNVector3(-2, -1, 1))
        start_coordinate_text.coordinates_text!.name = "Start coord"
        end_coordinate_text.coordinates_text = makeCoordinatesText(text: "(x = 30, z = 30)",
                                                                   position: SCNVector3(28, -1, -31))
        end_coordinate_text.coordinates_text!.name = "End coord"
        end_coordinate_text.x_coordinate = 30
        end_coordinate_text.z_coordinate = 30
    }
    
    func makeCoordinatesText(text: String, position: SCNVector3) -> SCNNode{
        let coord_text = SCNText(string: text, extrusionDepth: 0.2)
        coord_text.font = NSFont(name: "Arial", size: 0.8)
        coord_text.firstMaterial?.diffuse.contents = NSColor.black
        let text_node = SCNNode(geometry: coord_text)
        text_node.position = position
        return text_node
    }
    
    func updateEndPositionText(width: CGFloat = -1, height: CGFloat = -1) {
        if width != -1 && Int(width) != end_coordinate_text.x_coordinate {
            end_coordinate_text.x_coordinate = Int(width)
        }
        if height != -1 && Int(height) != end_coordinate_text.z_coordinate {
            end_coordinate_text.z_coordinate = Int(height)
        }
        let text = "(x = " + end_coordinate_text.x_coordinate.description + ", z = " + end_coordinate_text.z_coordinate.description + ")"
        end_coordinate_text.coordinates_text = makeCoordinatesText(text: text,
                                                                   position: SCNVector3(end_coordinate_text.x_coordinate-2, -1, -end_coordinate_text.z_coordinate - 1))
        end_coordinate_text.coordinates_text!.name = "End coord"
    }
}
