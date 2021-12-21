//
//  Coordinator.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 22/07/2021.
//


// znikają obiekty które dodaje się na wzór już istniejącego


import SceneKit

/// Coordinator for coordinating events occurring in map preview.
class Coordinator: NSObject, UpdatePositionDelegate, UpdateSizeDelegate, MenuDelegate, DrawPathDelegate, UpdatePeakPositionDelegate, SaveMenuDelegate {

    /// Variable holding view in which events occur.
    private let view: SCNView
    
    /// Duration of animations aplied to obstacles.
    let duration: CGFloat = 1
    
    /// Variable holding currently selected nodes' geometry.
    var current_geometry: SCNMaterial?
    
    ///  Generator used to create new obstacles.
    var generator: ObstacleGenerator?
    
    /// Variable holding currently selected node
    var current_node: SCNNode?
    
    var coordinates_text = MapCoordinates()
    
    ///  delegate used to delegate information to app's menu
    weak var delegate_for_menu: EditorSceneDelegate?
    
    /// Delegate used to delegate information to app's algorhitms menu.
    weak var obstacles_for_algorhitm_delegate: ObstaclesForAlgorithmDelegate?

    
    /// Initializes Coordinator with given view to coordinate
    ///
    /// - Parameters:
    ///     - view: *SCNView to coordinate*
    init(_ view: SCNView) {
        self.view = view
        super.init()
    }
    
    ///  Handle click action performed on coordinated view
    ///
    ///  - Parameters:
    ///      - gestureRecognizer: *recognizer used to get location of performed click action*
    @objc func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        
        // check what nodes are tapped
        let location = gestureRecognizer.location(in: view)
        let hitResults = view.hitTest(location, options: [:])
        
        // clear all previously present actions
        self.current_node?.removeAllActions()
        self.current_node?.geometry?.firstMaterial = self.current_geometry
        
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            // get material for selected geometry element
            let material = result.node.geometry!.materials[(result.geometryIndex)]
            
            // highlight it
            let highlight = SCNAction.customAction(duration: 0.5) { _, elapsed_time in
                let color = NSColor(red: elapsed_time/(self.duration*2),
                                    green: elapsed_time/(self.duration*2),
                                    blue: elapsed_time/(self.duration*2),
                                    alpha: 1)
                material.emission.contents = color
            }
            // unhighlight it
            let unhighlight = SCNAction.customAction(duration: 0.5) { _, elapsed_time in
                let color = NSColor(red: 0.5 - elapsed_time/self.duration,
                                    green: 0.5 - elapsed_time/self.duration,
                                    blue: 0.5 - elapsed_time/self.duration,
                                    alpha: 1)
                material.emission.contents = color
            }
            // wait a bit
            let wait = SCNAction.customAction(duration: 3) { _,_ in }
            
            // create an animation
            let pulse_sequence = SCNAction.sequence([highlight, unhighlight, wait])
            let loop = SCNAction.repeatForever(pulse_sequence)
            
            // hold clicked nodes for later
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
    
    /// Updates selected object's position on *x* axis.
    ///
    /// - Parameters:
    ///     - new_x: *New value of object's x axis position*
    func updateXPosition(new_x: CGFloat) {
        self.current_node?.physicsBody = nil
        self.current_node?.position.x = new_x
        self.current_node?.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.static, shape: nil)
    }
    
    /// Updates selected object's position on *y* axis.
    ///
    /// - Parameters:
    ///     - new_y: *New value of object's y axis position*
    func updateYPosition(new_y: CGFloat) {
        self.current_node?.physicsBody = nil
        self.current_node?.position.y = new_y
        self.current_node?.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.static, shape: nil)
    }
    
    /// Updates selected object's position on *z* axis.
    ///
    /// - Parameters:
    ///     -  new_z: *New value of object's z axis position*
    func updateZPosition(new_z: CGFloat) {
        self.current_node?.physicsBody = nil
        self.current_node?.position.z = -new_z
        self.current_node?.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.static, shape: nil)
    }
    
    /// Updates selected object's width.
    ///
    /// - Parameters:
    ///     - new_width: *New value of object's width*
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
    
    /// Updates selected object's height.
    ///
    /// - Parameters:
    ///     - new_height: *New value of object's height*
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
    
    /// Updates selected object's length.
    ///
    /// - Parameters:
    ///     - new_length: *New value of object's length*
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
    
    
    /// Updates selected object's peak position if object has a peak.
    ///
    /// - Parameters:
    ///     - new_peak_position: *New value of object's peak position*
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
    
    /// Delete selected object from scene and informs algorhitms menu of change.
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
    
    /// Adds created object to scene and informs algorhitms menu of change.
    ///
    /// - Parameters:
    ///     - object: *Object to add to scene*
    func obstacleCreated(object: SCNNode) {
        if object.is_floor {
            self.view.scene?.rootNode.addChildNode(coordinates_text.start_coordinate_text.coordinates_text!)
            self.view.scene?.rootNode.addChildNode(coordinates_text.end_coordinate_text.coordinates_text!)
        }
        self.view.scene?.rootNode.addChildNode(object)
    }
    
    /// Creates path discovered by algorhitm and displays it.
    ///
    /// - Parameters:
    ///     - grid: *Whole grid of nodes on which the algorhitm operates*
    func drawPath(node: Node, algorithm_name: String) {
        PathDrawer.drawPath(node: node, algorithm_name: algorithm_name)
        displayPath(node: node)
    }
    
    /// Displays path from start point to end point found by an algorhitm.
    ///
    /// - Parameters:
    ///     - node: *Node from which the path starts to draw (in our case its always end point)*
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
    
    /// Deletes path from start to end point that is curently displayed in the preview.
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
    
    /// Saves whole map created by user to given file
    ///
    /// - Parameters:
    ///     - filename: *Name of file to which we want to save our map*
    func saveMap(filename: String) {
        let text = SavesManager.processMapInfoToSave(nodes: self.view.scene!.rootNode.childNodes)
        SavesManager.savetoFile(filename: filename, text: text)
    }
    
    /// Lads data form file and processes it in order to recreate saved map
    ///
    /// - Parameters:
    ///     - filename: *Name of file from which we are loading map data*
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
    
    /// Removes all nodes from scene except for camera node
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
    /// Calculated value of nodes width based on bounding box x positions.
    var width: CGFloat { CGFloat(self.boundingBox.max.x - self.boundingBox.min.x) }
    
    /// Calculated value of nodes height based on bounding box y positions.
    var height: CGFloat { CGFloat(self.boundingBox.max.y - self.boundingBox.min.y) }
    
    /// Calculated value of nodes length based on bounding box z positions.
    var length: CGFloat { CGFloat(self.boundingBox.max.z - self.boundingBox.min.z) }
    
    var radius: CGFloat { CGFloat(self.boundingBox.max.z)}
    
    /// Holder of information about weather the node is floor for the whole map or not.
    private static var floor_holder = [String:Bool]()
    
    /// Holder of information about weather the node is an obstacle or not.
    private static var obstacle_holder = [String:Bool]()
    
    /// Holder of information about weather the node is  start point node or not
    private static var is_start_holder = [String:Bool]()
    
    /// Holder of information about weather the node is end point node or not
    private static var is_end_holder = [String:Bool]()
    
    /// Holder of information about weather the node is part of a path from start to end point
    private static var path_holder = [String:String]()
    
    /// Variable containing information about node beeing a floor node.
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
    
    /// Variable containing information about node beeing an obstacle node
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
    
    /// Variable containing information about node beeing the start point node
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
    
    /// Variable containing information about node beeing the end point node
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
    
    /// Variable containing information about node beeing a path node
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
    /// Boolean value of string
    var boolValue: Bool {
        return (self as NSString).boolValue
    }
}
