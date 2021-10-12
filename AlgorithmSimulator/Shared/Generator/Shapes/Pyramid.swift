//
//  Pyramid.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 22/09/2021.
//

import SceneKit

/// Definition of pyramid shaped object
class Pyramid {
    
    ///  Vertices used to define 3D object
    var vertices: [SCNVector3]
    
    /// A container for vertex data forming part of the definition for a three-dimensional object.
    var source: SCNGeometrySource
    
    /// Values defining which vertices connected create objects side
    var indices: [Int32]
    
    /// A container for index data describing how vertices connect to define a three-dimensional object.
    var element: SCNGeometryElement
    
    /// Initializes pyramid shaped object based on given parameters.
    ///
    /// - Parameters:
    ///     - width: *width of created object*
    ///     - height: *height of created object*
    ///     - length: *length of created object*
    ///     - peak_position: *position of pyramid shaped object's peak*
    ///
    /// - Returns: *Newly created Pyramid object*
    init(width: CGFloat, height: CGFloat, length: CGFloat, peak_position: String) {
        let peak: SCNVector3 = Pyramid.choosePeak(peak_position: peak_position)
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
    
    /// Chooses peak based on given descriptional string
    ///
    /// - Parameters:
    ///     - peak_position: *desctiption where based on square base is peak eg. "Bottom Left"*
    ///
    /// - Returns: *position modifier for peak vertex*
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
    
    /// - Returns: Geometry of current pyramid object.
    func getGeometry() -> SCNGeometry {
        return SCNGeometry(sources: [source], elements: [element])
    }
}
