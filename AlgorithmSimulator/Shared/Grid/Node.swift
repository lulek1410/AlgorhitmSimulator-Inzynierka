//
//  Node.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 17/08/2021.
//

import SceneKit

/// Representation of single node in navigation grid used for finding path with an algorithm.
class Node : Equatable, Comparable {
    
    /// Previous node in shortest path form stast node to current node.
    var parent_node : Node?
    
    /// Visual representation.
    var shape : SCNNode?
    
    /// Dusitance from start node to current node.
    /// In A star algorithm it is sum of distance form starting nod to current node plus heuristic distance from current node to end node
    var distance : Float = Float.greatestFiniteMagnitude
    
    /// Dusitance from start node to current node (Used only in "A start" algorithm).
    var source_dist : Float = Float.greatestFiniteMagnitude
    
    /// Variable decideing weather we can take node into consideration during path search.
    var is_traversable : Bool = true
    
    /// Is current node a starting node.
    var is_starting : Bool = false
    
    /// Is current node an end node.
    var is_end : Bool = false
    
    /// Nodes position in 3D space
    var position : SCNVector3 = SCNVector3(0, 0, 0)
    
    /// Initializes node with given position.
    ///
    /// - Parameters:
    ///     - position: *coordinates in 3D space in which the node will be placed*
    init(position : SCNVector3) {
        self.position = position
    }
    
    /// Overloaded equality operator for comparing nodes
    ///
    /// - Parameters:
    ///     - lhs: *node on the left side of the operator*
    ///     - rhs: *node on the right side of the operator*
    ///
    /// - Returns: *Boolean value telling us weather nodes have the same position implying that they are the same node*
    static func == (lhs: Node, rhs: Node) -> Bool {
        return
            lhs.position.x == rhs.position.x &&
            lhs.position.y == rhs.position.y &&
            lhs.position.z == rhs.position.z
    }
    
    /// Overloaded "les than" operator for nodes.
    ///
    /// - Parameters:
    ///     - lhs: *node on the left side of the operator*
    ///     - rhs: *node on the right side of the operator*
    ///
    /// - Returns: *Boolean value telling us weather node on the left side of operator has shorter path from source than the node on the right side*
    static func < (lhs: Node, rhs: Node) -> Bool {
        return lhs.distance < rhs.distance
    }
}
