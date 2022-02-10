//
//  Coordinator.swift
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

class Coordinator: NSObject, UpdatePositionDelegate, UpdateSizeDelegate, MenuDelegate, DrawPathDelegate, UpdatePeakPositionDelegate, SaveMenuDelegate {
    
    private let view: SCNView
    let duration: CGFloat = 1
    var current_geometry: SCNMaterial?
    var generator: ObstacleGenerator?
    var current_node: SCNNode?
    var coordinates_text = MapCoordinates()
    weak var delegate_for_menu: EditorSceneDelegate?
    weak var obstacles_for_algorhitm_delegate: ObstaclesForAlgorithmDelegate?
    
    init(_ view: SCNView) {
        self.view = view
        super.init()
    }

    @objc func handleClick(_ gestureRecognizer: NSGestureRecognizer) {

        let location = gestureRecognizer.location(in: view)
        let hitResults = view.hitTest(location, options: [:])
        
        self.current_node?.removeAllActions()
        self.current_node?.geometry?.firstMaterial = self.current_geometry
        
        if hitResults.count > 0 {
            let result = hitResults[0]
            let material = result.node.geometry!.materials[(result.geometryIndex)]
            
            let highlight = SCNAction.customAction(duration: 0.5) { _, elapsed_time in
                let color = NSColor(red: elapsed_time/(self.duration*2),
                                    green: elapsed_time/(self.duration*2),
                                    blue: elapsed_time/(self.duration*2),
                                    alpha: 1)
                material.emission.contents = color
            }
            let unhighlight = SCNAction.customAction(duration: 0.5) { _, elapsed_time in
                let color = NSColor(red: 0.5 - elapsed_time/self.duration,
                                    green: 0.5 - elapsed_time/self.duration,
                                    blue: 0.5 - elapsed_time/self.duration,
                                    alpha: 1)
                material.emission.contents = color
            }
            let wait = SCNAction.customAction(duration: 3) { _,_ in }
            
            let pulse_sequence = SCNAction.sequence([highlight, unhighlight, wait])
            let loop = SCNAction.repeatForever(pulse_sequence)
            
            current_geometry = result.node.geometry?.materials.first?.copy() as? SCNMaterial
            current_node = result.node
            
            result.node.runAction(loop)
        }
        else{
            current_node = nil
            current_geometry = nil
        }
        delegate_for_menu?.objectTapped(object: current_node ?? SCNNode())
    }

    func updateXPosition(new_x: CGFloat) {
        self.current_node?.physicsBody = nil
        self.current_node?.position.x = new_x
        self.current_node?.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.static, shape: nil)
    }

    func updateYPosition(new_y: CGFloat) {
        self.current_node?.physicsBody = nil
        self.current_node?.position.y = new_y
        self.current_node?.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.static, shape: nil)
    }

    func updateZPosition(new_z: CGFloat) {
        self.current_node?.physicsBody = nil
        self.current_node?.position.z = -new_z
        self.current_node?.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.static, shape: nil)
    }

    func updateWidth(new_width: CGFloat) {
        if self.current_node?.width != nil,
           new_width != self.current_node?.width {
            self.current_node?.position = (self.current_node?.position)!
            let temp = current_node
            let result = temp?.name?.split(separator: " ")
            var peak_pos = "Bottom left"
            if result![0] == "Pyramid" {
                peak_pos = String(result?[1] ?? "") + " " + String(result?[2] ?? "")
            }
            else if temp!.is_floor {
                self.coordinates_text.updateEndPositionText(width: new_width)
                deleteEndCoordinatesText()
                self.view.scene?.rootNode.addChildNode(coordinates_text.end_coordinate_text.coordinates_text!)
            }
            current_node?.removeFromParentNode()
            current_node = generator?.createShape(shape: String(result![0]),
                                                   width: new_width,
                                                   height: temp!.height,
                                                   length: temp!.length,
                                                   position: temp!.position,
                                                   peak_position: peak_pos,
                                                   is_floor: temp!.is_floor)
            
            self.view.scene?.rootNode.addChildNode(current_node!)
        }
    }

    func updateHeight(new_height: CGFloat) {
        if self.current_node?.height != nil,
           new_height != self.current_node!.height {
            self.current_node?.position = (self.current_node?.position)!
            let temp = current_node
            current_node?.removeFromParentNode()
            let result = temp?.name?.split(separator: " ")
            var peak_pos = "Bottom left"
            if result![0] == "Pyramid" {
                peak_pos = String(result?[1] ?? "") + " " + String(result?[2] ?? "")
            }
            else if temp!.is_floor {
                self.coordinates_text.updateEndPositionText(height: new_height)
                deleteEndCoordinatesText()
                self.view.scene?.rootNode.addChildNode(coordinates_text.end_coordinate_text.coordinates_text!)
            }
            
            current_node = generator?.createShape(shape: String(result![0]),
                                                   width: temp!.width,
                                                   height: new_height,
                                                   length: temp!.length,
                                                   position: temp!.position,
                                                   peak_position: peak_pos,
                                                   is_floor: temp!.is_floor)
            
            self.view.scene?.rootNode.addChildNode(current_node!)
        }
    }

    func updateLength(new_length: CGFloat) {
        if self.current_node?.height != nil,
           new_length != self.current_node!.length {
            self.current_node?.position = (self.current_node?.position)!
            let temp = current_node
            let result = temp?.name?.split(separator: " ")
            var peak_pos = "Bottom left"
            if result![0] == "Pyramid" {
                peak_pos = String(result?[1] ?? "") + " " + String(result?[2] ?? "")
            }
            current_node?.removeFromParentNode()
            current_node = generator?.createShape(shape: String(result![0]),
                                                   width: temp!.width,
                                                   height: temp!.height,
                                                   length: new_length,
                                                   position: temp!.position,
                                                   peak_position: peak_pos,
                                                   is_floor: temp!.is_floor)
            
            self.view.scene?.rootNode.addChildNode(current_node!)
        }
    }
    
    func updateRadius(new_radius: CGFloat) {
        if self.current_node?.height != nil,
           new_radius != self.current_node?.radius{
            self.current_node?.position = (self.current_node?.position)!
            let temp = current_node
            let result = temp?.name?.split(separator: " ")
            current_node?.removeFromParentNode()
            current_node = generator?.createShape(shape: String(result![0]),
                                                  width: temp!.width,
                                                  height: temp!.height,
                                                  length: temp!.length,
                                                  radius: new_radius,
                                                  position: temp!.position,
                                                  is_floor: temp!.is_floor)
            self.view.scene?.rootNode.addChildNode(current_node!)
        }
    }

    func updatePeakPosition(new_peak_position: String) {
        if self.current_node?.length != nil {
            let name = current_node?.name?.split(separator: " ")
            if name![0] == "Pyramid" && name![1] + " " + name![2] != new_peak_position {
                let temp = current_node
                current_node?.removeFromParentNode()
                current_node = generator?.createShape(shape: String(name![0]),
                                                       width: temp!.width,
                                                       height: temp!.height,
                                                       length: temp!.length,
                                                       position: temp!.position,
                                                       peak_position: new_peak_position)
                self.view.scene?.rootNode.addChildNode(current_node!)
            }
        }
    }

    func deleteSelectedObject() {
        if self.current_node!.is_start {
            self.delegate_for_menu?.startPointNotPresent()
        }
        else if self.current_node!.is_end{
            self.delegate_for_menu?.endPointNotPresent()
        }
        self.current_node!.removeFromParentNode()
    }
    
    func deleteEndCoordinatesText(){
        for node in self.view.scene!.rootNode.childNodes {
            if node.name == "End coord" {
                node.removeFromParentNode()
            }
        }
    }

    func obstacleCreated(object: SCNNode) {
        if object.is_floor {
            self.view.scene?.rootNode.addChildNode(coordinates_text.start_coordinate_text.coordinates_text!)
            self.view.scene?.rootNode.addChildNode(coordinates_text.end_coordinate_text.coordinates_text!)
        }
        self.view.scene?.rootNode.addChildNode(object)
    }

    func drawPath(node: Node, algorithm_name: String) {
        PathDrawer.drawPath(node: node, algorithm_name: algorithm_name)
        displayPath(node: node)
    }

    func displayPath(node: Node) {
        if let shape = node.shape {
            self.view.scene?.rootNode.addChildNode(shape)
            if node.parent != nil {
                displayPath(node: node.parent!)
            }
            else if node.r_parent != nil {
                displayPath(node: node.r_parent!)
            }
        }
    }
    
    func clearPath(name: String) {
        for node in self.view.scene!.rootNode.childNodes {
            if node.name != "End coord" && node.name != "Start coord"{
                if name == "All" && node.path != ""{
                    node.removeFromParentNode()
                }
                else if name == "Bidirectional Dijkstra" && (node.path == "Bidirectional Dijkstra Start" || node.path == "Bidirectional Dijkstra End"){
                    node.removeFromParentNode()
                }
                else if node.path == name {
                    node.removeFromParentNode()
                }
            }
        }
    }
    
    func saveMap(filename: String) {
        let text = SavesManager.processMapInfoToSave(nodes: self.view.scene!.rootNode.childNodes)
        SavesManager.savetoFile(filename: filename, text: text)
    }
    
    func loadMap(filename: String) {
        delegate_for_menu?.startPointNotPresent()
        delegate_for_menu?.endPointNotPresent()
        removeAllObstacles()
        let text = SavesManager.loadFromFile(filename: filename)
        let obstacles = text.split(separator: "\n")
        for obstacle in obstacles {
            let parameters = obstacle.split(separator: ";")
            let name = parameters[0].split(separator: " ")
            if String(name[0]) == "StartEnd" {
                if String(parameters[9]).boolValue {
                    delegate_for_menu?.startPointPresent()
                }
                else {
                    delegate_for_menu?.endPointPresent()
                }
            }
            let peak_position = name[0] == "Pyramid" ? String(name[1] + " " + name[2]) : "Bottom left"
            let position = SCNVector3(Int(String(parameters[5]))!,
                                      Int(String(parameters[6]))!,
                                      Int(String(parameters[7]))!)
            let node = (generator?.createShape(shape: String(name[0]),
                                               width: NumberFormatter().number(from: String(parameters[1])) as! CGFloat,
                                               height: NumberFormatter().number(from: String(parameters[2])) as! CGFloat,
                                               length: NumberFormatter().number(from: String(parameters[3])) as! CGFloat,
                                               radius: NumberFormatter().number(from: String(parameters[4])) as! CGFloat,
                                               position: position,
                                               peak_position: peak_position,
                                               is_floor: String(parameters[8]).boolValue,
                                               is_start: String(parameters[9]).boolValue))
            if node!.is_floor {
                self.coordinates_text.updateEndPositionText(width: node!.width, height: node!.height)
                self.view.scene?.rootNode.addChildNode(coordinates_text.start_coordinate_text.coordinates_text!)
                self.view.scene?.rootNode.addChildNode(coordinates_text.end_coordinate_text.coordinates_text!)
                
            }
            
            self.view.scene?.rootNode.addChildNode(node!)
        }
    }

    func removeAllObstacles() {
        for node in self.view.scene!.rootNode.childNodes {
            if node.name != "Camera" {
                node.removeFromParentNode()
            }
        }
    }
    
    func askForObstacles() {
        var nodes : [SCNNode] = []
        for node in self.view.scene!.rootNode.childNodes {
            if node.path == "" && node.name != "Camera" && node.path == "" {
                nodes.append(node)
            }
        }
        obstacles_for_algorhitm_delegate?.setAlgorithmObstacles(obstacles: nodes)
    }
}

extension SCNNode {
    var width: CGFloat { CGFloat(self.boundingBox.max.x - self.boundingBox.min.x) }
    var height: CGFloat { CGFloat(self.boundingBox.max.y - self.boundingBox.min.y) }
    var length: CGFloat { CGFloat(self.boundingBox.max.z - self.boundingBox.min.z) }
    var radius: CGFloat { CGFloat(self.boundingBox.max.z)}
    private static var floor_holder = [String:Bool]()
    private static var obstacle_holder = [String:Bool]()
    private static var is_start_holder = [String:Bool]()
    private static var is_end_holder = [String:Bool]()
    private static var path_holder = [String:String]()
    
    var is_floor : Bool {
        get {
            let address = String(format : "%p", unsafeBitCast(self, to: Int.self))
            return SCNNode.floor_holder[address] ?? false
        }
        set(val) {
            let address = String(format : "%p", unsafeBitCast(self, to: Int.self))
            SCNNode.floor_holder[address] = val
        }
    }
    
    var is_obstacle : Bool {
        get {
            let address = String(format : "%p", unsafeBitCast(self, to: Int.self))
            return SCNNode.obstacle_holder[address] ?? false
        }
        set(val) {
            let address = String(format : "%p", unsafeBitCast(self, to: Int.self))
            SCNNode.obstacle_holder[address] = val
        }
    }
    
    var is_start : Bool {
        get {
            let address = String(format : "%p", unsafeBitCast(self, to: Int.self))
            return SCNNode.is_start_holder[address] ?? false
        }
        set(val) {
            let address = String(format : "%p", unsafeBitCast(self, to: Int.self))
            SCNNode.is_start_holder[address] = val
        }
    }

    var is_end : Bool {
        get {
            let address = String(format : "%p", unsafeBitCast(self, to: Int.self))
            return SCNNode.is_end_holder[address] ?? false
        }
        set(val) {
            let address = String(format : "%p", unsafeBitCast(self, to: Int.self))
            SCNNode.is_end_holder[address] = val
        }
    }

    var path : String {
        get {
            let address = String(format : "%p", unsafeBitCast(self, to: Int.self))
            return SCNNode.path_holder[address] ?? ""
        }
        set(val) {
            let address = String(format : "%p", unsafeBitCast(self, to: Int.self))
            SCNNode.path_holder[address] = val
        }
    }
}

extension String {
    var boolValue: Bool {
        return (self as NSString).boolValue
    }
}

extension Array {
    func split(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
