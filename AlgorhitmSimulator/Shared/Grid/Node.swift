//
//  Node.swift
//  Test (iOS)
//
//  Created by Janek on 17/08/2021.
//

import SceneKit

class Node : Equatable, Comparable {
    
    var parent_node : Node?
    var shape : SCNNode?
    
    var distance : Float = Float.greatestFiniteMagnitude
    var source_dist : Float = Float.greatestFiniteMagnitude
    
    var is_traversable : Bool = true
    var is_starting : Bool = false
    var is_end : Bool = false
    var processed : Bool = false
    
    var position : SCNVector3 = SCNVector3(0, 0, 0)
    
    init(position : SCNVector3) {
        self.position = position
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return
            lhs.position.x == rhs.position.x &&
            lhs.position.y == rhs.position.y &&
            lhs.position.z == rhs.position.z
    }
    
    static func < (lhs: Node, rhs: Node) -> Bool {
        return lhs.distance < rhs.distance
    }
}
