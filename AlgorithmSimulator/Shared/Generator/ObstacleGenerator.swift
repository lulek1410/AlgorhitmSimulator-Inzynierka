//
//  ObstacleGenerator.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 29/03/2021.
//

import SceneKit
import SwiftUI

/// Generates different obstacles.
class ObstacleGenerator {
    
    /// Delegate variable used to delegate actions thet needet to be performed when new obstacle is created.
    weak var delegate : ObstacleGeneratorDelegate?
    
    /// Creates obstacle based on given parameters.
    ///
    /// - Parameters:
    ///     - shape: *Name of shape which new obstacle will have*
    ///     - width: *Obstacle's width*
    ///     - height: *Obstacle's height*
    ///     - length: *Obstacle's length*
    ///     - position: *Obstacle's position in 3D space*
    ///     - peak_position: *Position of peak (applies only to "Pyramid" shaped obstacles)*
    ///     - is_floor: *Will created obstacle be a floor object*
    ///     - is_start: *Will created obstacle be a start object*
    ///
    /// - Returns: *Newly created obstacle*
    func createShape(shape : String,
                     width : CGFloat = 0,
                     height : CGFloat = 0,
                     length : CGFloat = 0,
                     position : SCNVector3 = SCNVector3(0, 0, 0),
                     peak_position : String = "Bottom left",
                     is_floor : Bool = false,
                     is_start : Bool = false) -> SCNNode {
        
        let result = checkSizes(width: width, height: height, length: length)
        
        switch(shape) {
        case "Box" : return createBox(width: result.0,
                                      height: result.1,
                                      length: result.2,
                                      position: position,
                                      is_floor: is_floor)
        case "Pyramid" : return createPyramid(width: result.0,
                                              height: result.1,
                                              length: result.2,
                                              peak_position: peak_position,
                                              position: position)
        case "Sphere" : return createStartEnd(is_start: is_start, position: position)
        default:
            return SCNNode()
        }
    }
    
    /// Creates pyramid shaped obstacles.
    ///
    /// - Parameters:
    ///     - width: *Obstacle's width*
    ///     - height: *Obstacle's height*
    ///     - length: *Obstacle's length*
    ///     - peak_position: *Position of peak (applies only to "Pyramid" shaped obstacles)*
    ///     - position: *Obstacle's position in 3D space*
    ///
    /// - Returns: *Newly created pyramid shaped obstacle*
    func createPyramid(width : CGFloat,
                       height : CGFloat,
                       length : CGFloat,
                       peak_position : String,
                       position : SCNVector3 = SCNVector3(0, 0, 0)) -> SCNNode {
        
        let color : NSColor = NSColor.gray
        let pyramid = Pyramid(width: width, height: height, length: length, peak_position: peak_position)
        let geometry = pyramid.getGeometry()
        
        geometry.materials.first?.diffuse.contents = color
        let geometry_node = makeNode(geometry: geometry)
        geometry_node.name = "Pyramid " + peak_position
        setNodesProperties(geometry_node: geometry_node, position: position)
        return geometry_node
    }
    
    /// Creates box shaped obstacles.
    ///
    /// - Parameters:
    ///     - width: *Obstacle's width*
    ///     - height: *Obstacle's height*
    ///     - length: *Obstacle's length*
    ///     - position: *Obstacle's position in 3D space*
    ///     - is_floor: *Will created obstacle be a floor object*
    ///
    /// - Returns: *Newly created box shaped obstacle*
    func createBox(width : CGFloat,
                   height : CGFloat,
                   length : CGFloat,
                   position : SCNVector3 = SCNVector3(0, 0, 0),
                   is_floor : Bool = false) -> SCNNode{
        
        let color : NSColor = is_floor ? NSColor.blue : NSColor.gray
        let result = checkSizes(width: width, height: height, length: length)
        
        let geometry = is_floor ? SCNBox(width: result.0, height: result.1, length: 0.1, chamferRadius: 0) :
                                  SCNBox(width: result.0, height: result.1, length: result.2, chamferRadius: 0)
        
        geometry.materials.first?.diffuse.contents = color
        let geometry_node = makeNode(geometry: geometry, is_floor: is_floor)
        geometry_node.name = "Box"
        setNodesProperties(geometry_node: geometry_node, position: position)
        return geometry_node
    }
    
    /// Creates sphere shaped obstacles representing either start (green) or end (red)  point.
    ///
    /// - Parameters:
    ///     - is_start: *Will created obstacle be a start object*
    ///     - position: *Obstacle's position in 3D space*
    ///
    /// - Returns: *Newly created sphere shaped obstacle*
    func createStartEnd(is_start : Bool,
                        position : SCNVector3 = SCNVector3(0, 0, 0)) -> SCNNode {
        
        let color = is_start ? NSColor.green : NSColor.red
        let geometry : SCNGeometry
        geometry = SCNSphere(radius: 0.5)
        
        geometry.materials.first?.diffuse.contents = color
        let geometry_node = makeNode(geometry: geometry, is_start: is_start, is_end: !is_start)
        geometry_node.name = "Sphere"
        setNodesProperties(geometry_node: geometry_node, position: position)
        return geometry_node
        
    }
            
    ///  Creates SCNNode from given SCNGeometry.
    ///
    ///  - Parameters:
    ///      - geometry: *SCNGeometry object containing onformations about geometrical object*
    ///      - is_floor: *Weather generated node will be the floor object*
    ///      - is_start: *Weather generated node will be the start node*
    ///      - is_end: *Weather generated node will be the end node*
    ///
    ///  - Returns: *SCNNode containing given geometry and parameters*
    private func makeNode(geometry : SCNGeometry,
                          is_floor : Bool = false,
                          is_start : Bool = false,
                          is_end : Bool = false) -> SCNNode{
        
        let geometry_node = SCNNode(geometry: geometry)
        geometry_node.is_floor = is_floor
        geometry_node.is_start = is_start
        geometry_node.is_end = is_end
        geometry_node.is_obstacle = is_floor ? false : true
        geometry_node.is_path = false
        return geometry_node
    }
    
    ///
    private func setNodesProperties(geometry_node : SCNNode,
                                    position : SCNVector3){
        
        if geometry_node.is_floor {
            geometry_node.pivot = SCNMatrix4MakeTranslation(-0.5 * geometry_node.width,
                                                            0.5 * geometry_node.height,
                                                            -0.5 * geometry_node.length)
        }
        else if !geometry_node.is_end && !geometry_node.is_start{
            geometry_node.pivot = SCNMatrix4MakeTranslation(-0.5 * geometry_node.width,
                                                            -0.5 * geometry_node.height,
                                                            0.5 * geometry_node.length)
        }
        
        geometry_node.position = position
        
        geometry_node.eulerAngles = geometry_node.is_floor ? SCNVector3(90*CGFloat.pi/180, 0, 0) : SCNVector3(0, 0, 0)
    }
    
    /// Checks given sizes parameters.
    ///
    /// - Parameters:
    ///     - width: *width parameter to check*
    ///     - height: *height parameter to check*
    ///     - length: *length parameter to check*
    ///
    /// Given parameter are modified to be equal to 0.1 if they are equel to 0 in order to be visible to user when displayed.
    ///
    /// - Returns: *modified o not width, height, length*
    func checkSizes(width : CGFloat, height : CGFloat, length : CGFloat) -> (CGFloat, CGFloat, CGFloat){
        var w : CGFloat = width
        var h : CGFloat = height
        var l : CGFloat = length
        if width == 0 {
            w = 0.1
        }
        if height == 0 {
            h = 0.1
        }
        if length == 0 {
            l = 0.1
        }
        return (w, h, l)
    }
}

