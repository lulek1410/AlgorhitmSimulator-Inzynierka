//
//  Coordinator.swift
//  Test
//
//  Created by Janek on 22/07/2021.
//

import Foundation
import SceneKit

class Coordinator: NSObject, UpdatePositionDelegate, UpdateSizeDelegate, MenuDelegate, DrawPathDelegate, UpdatePeakPositionDelegate {
    
    private let view: SCNView
    let duration : CGFloat = 1
    var previous_geometry : SCNMaterial?
    var generator : ObstacleGenerator?
    var previous_node : SCNNode?
    weak var delegate_object_tapped : ObjectTappedDelegate?
    weak var delegate_obstacles : ObstaclesDelegate?
    
    init(_ view: SCNView) {
        self.view = view
        super.init()
    }
    
    @objc func handleClick(_ gestureRecognize: NSGestureRecognizer) {
        // check what nodes are tapped
        let location = gestureRecognize.location(in: view)
        let hitResults = view.hitTest(location, options: [:])
        
        // clear all previously present actions
        self.previous_node?.removeAllActions()
        self.previous_node?.geometry?.firstMaterial = self.previous_geometry
        
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
            
            previous_geometry = result.node.geometry?.materials.first?.copy() as? SCNMaterial
            previous_node = result.node
            
            result.node.runAction(loop)
            print(result.node.hasActions)
            previous_node?.eulerAngles = (previous_node?.presentation.eulerAngles)!

        }
        else{
            previous_node = nil
            previous_geometry = nil
        }
        delegate_object_tapped?.objectTapped(object: previous_node ?? SCNNode())
    }
    
    func updateXPosition(new_x: CGFloat) {
        self.previous_node?.physicsBody = nil
        self.previous_node?.position.x = new_x
        self.previous_node?.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.static, shape: nil)
    }
    
    func updateYPosition(new_y: CGFloat) {
        self.previous_node?.physicsBody = nil
        self.previous_node?.position.y = new_y
        self.previous_node?.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.static, shape: nil)
    }
    
    func updateZPosition(new_z: CGFloat) {
        self.previous_node?.physicsBody = nil
        self.previous_node?.position.z = -new_z
        self.previous_node?.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.static, shape: nil)
    }
    
    func updateWidth(new_width: CGFloat) {
        if self.previous_node?.width != nil,
           new_width != self.previous_node?.width {
            self.previous_node?.position = (self.previous_node?.position)!
            let temp = previous_node
            let result = temp?.name?.split(separator: " ")
            var peak_pos = "Bottom left"
            if result![0] == "Pyramid" {
                peak_pos = String(result?[1] ?? "") + " " + String(result?[2] ?? "")
            }
            previous_node?.removeFromParentNode()
            previous_node = generator?.createShape(shape: String(result![0]),
                                                   width: new_width,
                                                   height: temp!.height,
                                                   length: temp!.length,
                                                   position: temp!.position,
                                                   peak_position: peak_pos,
                                                   is_floor: temp!.is_floor)
            
            self.view.scene?.rootNode.addChildNode(previous_node!)
        }
    }
    
    func updateHeight(new_height: CGFloat) {
        if self.previous_node?.height != nil,
           new_height != self.previous_node!.height {
            self.previous_node?.position = (self.previous_node?.position)!
            let temp = previous_node
            previous_node?.removeFromParentNode()
            let result = temp?.name?.split(separator: " ")
            var peak_pos = "Bottom left"
            if result![0] == "Pyramid" {
                peak_pos = String(result?[1] ?? "") + " " + String(result?[2] ?? "")
            }
            
            previous_node = generator?.createShape(shape: String(result![0]),
                                                   width: temp!.width,
                                                   height: new_height,
                                                   length: temp!.length,
                                                   position: temp!.position,
                                                   peak_position: peak_pos,
                                                   is_floor: temp!.is_floor)
            
            self.view.scene?.rootNode.addChildNode(previous_node!)
        }
    }
    
    func updateLength(new_length: CGFloat) {
        if self.previous_node?.length != nil,
           new_length != self.previous_node!.length {
            self.previous_node?.position = (self.previous_node?.position)!
            let temp = previous_node
            let result = temp?.name?.split(separator: " ")
            var peak_pos = "Bottom left"
            if result![0] == "Pyramid" {
                peak_pos = String(result?[1] ?? "") + " " + String(result?[2] ?? "")
            }
            previous_node?.removeFromParentNode()
            previous_node = generator?.createShape(shape: String(result![0]),
                                                   width: temp!.width,
                                                   height: temp!.height,
                                                   length: new_length,
                                                   position: temp!.position,
                                                   peak_position: peak_pos,
                                                   is_floor: temp!.is_floor)
            
            self.view.scene?.rootNode.addChildNode(previous_node!)
        }
    }
    
    func updatePeakPosition(new_peak_position: String) {
        if self.previous_node?.length != nil {
            let name = previous_node?.name?.split(separator: " ")
            if name![0] == "Pyramid" && name![1] + " " + name![2] != new_peak_position {
                let temp = previous_node
                previous_node?.removeFromParentNode()
                previous_node = generator?.createShape(shape: String(name![0]),
                                                       width: temp!.width,
                                                       height: temp!.height,
                                                       length: temp!.length,
                                                       position: temp!.position,
                                                       peak_position: new_peak_position)
                self.view.scene?.rootNode.addChildNode(previous_node!)
            }
        }
    }
    
    func deleteSelectedObject() {
        if self.previous_node!.is_start {
            self.delegate_object_tapped?.startPointDeleted()
        }
        else if self.previous_node!.is_end{
            self.delegate_object_tapped?.endPointDeleted()
        }
        self.previous_node!.removeFromParentNode()
        self.delegate_obstacles?.setObstacles(obstacles: (self.view.scene?.rootNode.childNodes)!)
    }
    
    func obstacleCreated(object: SCNNode) {
        self.view.scene?.rootNode.addChildNode(object)
        self.delegate_obstacles?.setObstacles(obstacles: (self.view.scene?.rootNode.childNodes)!)
    }
    
    func drawPath(grid: Grid) {
        PathDrawer.drawPath(node: grid.nodes[grid.end_point[0]][grid.end_point[1]][grid.end_point[2]])
        displayPath(node: grid.nodes[grid.end_point[0]][grid.end_point[1]][grid.end_point[2]])
        self.delegate_obstacles?.setObstacles(obstacles: (self.view.scene?.rootNode.childNodes)!)
    }
    
    func displayPath(node : Node) {
        if let shape = node.shape {
            self.view.scene?.rootNode.addChildNode(shape)
            displayPath(node: node.parent_node!)
        }
    }
    
    func clearPreviousPath() {
        for node in self.view.scene!.rootNode.childNodes {
            if node.is_path {
                node.removeFromParentNode()
            }
        }
        self.delegate_obstacles?.setObstacles(obstacles: (self.view.scene?.rootNode.childNodes)!)
    }
    
}

extension SCNNode {
    var width: CGFloat { CGFloat(self.boundingBox.max.x - self.boundingBox.min.x) }
    var height: CGFloat { CGFloat(self.boundingBox.max.y - self.boundingBox.min.y) }
    var length: CGFloat { CGFloat(self.boundingBox.max.z - self.boundingBox.min.z) }
    private static var floor_holder = [String:Bool]()
    private static var obstacle_holder = [String:Bool]()
    private static var is_start_holder = [String:Bool]()
    private static var is_end_holder = [String:Bool]()
    private static var is_path_holder = [String:Bool]()
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
    var is_path : Bool {
        get {
            let address = String(format : "%p", unsafeBitCast(self, to: Int.self))
            return SCNNode.is_path_holder[address] ?? false
        }
        set(val) {
            let address = String(format : "%p", unsafeBitCast(self, to: Int.self))
            SCNNode.is_path_holder[address] = val
        }
    }
}
