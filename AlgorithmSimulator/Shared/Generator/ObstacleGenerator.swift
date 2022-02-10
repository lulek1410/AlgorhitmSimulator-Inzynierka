//
//  ObstacleGenerator.swift
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
import SwiftUI

class ObstacleGenerator {
    
    func createShape(shape : String,
                     width : CGFloat = 0,
                     height : CGFloat = 0,
                     length : CGFloat = 0,
                     radius : CGFloat = 0,
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
        case "StartEnd" : return createStartEnd(is_start: is_start, position: position)
        case "Sphere" : return createSphere(position: position, radius: radius)
        default:
            return SCNNode()
        }
    }
    
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
    
    func createStartEnd(is_start : Bool,
                        position : SCNVector3 = SCNVector3(0, 0, 0)) -> SCNNode {
        
        let color = is_start ? NSColor.green : NSColor.red
        let geometry : SCNGeometry
        geometry = SCNSphere(radius: 0.3)
        
        geometry.materials.first?.diffuse.contents = color
        let geometry_node = makeNode(geometry: geometry, is_start: is_start, is_end: !is_start)
        geometry_node.name = "StartEnd"
        setNodesProperties(geometry_node: geometry_node, position: position)
        return geometry_node
        
    }
    
    func createSphere(position: SCNVector3 = SCNVector3(0, 0, 0), radius: CGFloat) -> SCNNode{
        let color : NSColor = NSColor.gray
        let result = checkRadius(radius: radius)
        let geometry = SCNSphere(radius: result)
        let geometry_node = makeNode(geometry: geometry)
        geometry.materials.first?.diffuse.contents = color
        geometry_node.name = "Sphere"
        geometry_node.position = position
        return geometry_node
    }
            
    private func makeNode(geometry : SCNGeometry,
                          is_floor : Bool = false,
                          is_start : Bool = false,
                          is_end : Bool = false) -> SCNNode{
        
        let geometry_node = SCNNode(geometry: geometry)
        geometry_node.is_floor = is_floor
        geometry_node.is_start = is_start
        geometry_node.is_end = is_end
        geometry_node.is_obstacle = is_floor ? false : true
        geometry_node.path = ""
        return geometry_node
    }
    
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
    
    private func checkRadius(radius: CGFloat) -> CGFloat{
        var r = radius
        if r == 0 {
            r = 0.1
        }
        return r
    }
}

