//
//  Pyramid.swift
//  Test
//
//  Created by Janek on 22/09/2021.
//

import Foundation
import SceneKit

class Pyramid {
    var vertices : [SCNVector3]
    var source : SCNGeometrySource
    var indices : [Int32]
    var element : SCNGeometryElement
    
    init(width : CGFloat, height : CGFloat, length : CGFloat, peak_position : String) {
        let peak : SCNVector3 = Pyramid.choosePeak(peak_position: peak_position)
        vertices = [
            SCNVector3(peak.x * width, 0.5 * height, peak.z * length),
            SCNVector3(-0.5 * width, -0.5 * height, 0.5 * length),
            SCNVector3(0.5 * width, -0.5 * height, 0.5 * length),
            SCNVector3(0.5 * width, -0.5 * height, -0.5 * length),
            SCNVector3(-0.5 * width, -0.5 * height, -0.5 * length)
        ]
        source = SCNGeometrySource(vertices: vertices)
        indices = [
            0, 1, 2,
            0, 2, 3,
            0, 3, 4,
            4, 1, 0,
            2, 1, 4,
            3, 2, 4
        ]
        element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
    }
    
    private static func choosePeak(peak_position : String) -> SCNVector3{
        var peak = SCNVector3()
        let result = peak_position.split(separator: " ")
        if result[0] == "Bottom" {
            peak.z = 0.5
        }
        else {
            peak.z = -0.5
        }
        if result[1] == "left" {
            peak.x = -0.5
        }
        else {
            peak.x = 0.5
        }
        return peak
    }
    
    func getGeometry() -> SCNGeometry {
        return SCNGeometry(sources: [source], elements: [element])
    }
}
