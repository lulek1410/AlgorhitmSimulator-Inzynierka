//
//  PathDrawer.swift
//  Test
//
//  Created by Janek on 06/09/2021.
//

import SceneKit

/// Class used to manage path creation.
class PathDrawer{
    
    /// Gives line shape to nodes in path starting from given node and descending throug node's parent using recursion.
    ///
    /// - Parameters:
    ///     - node: *node from which we start drawing path*
    static func drawPath(node : Node){
        if let parent = node.parent_node {
            print(node.position, "path")
            let pos1 = SCNVector3(x: node.position.x, y: node.position.y, z: -node.position.z)
            let pos2 = SCNVector3(x: parent.position.x, y: parent.position.y, z: -parent.position.z)
            let path_node = SCNGeometry.cylinderLine(from: pos1, to: pos2, segments: 4)
            path_node.is_path = true
            node.shape = path_node
            drawPath(node: parent)
        }
    }
}

extension SCNGeometry {
    
    /// Representation of cylindricallly shaped line object.
    class func cylinderLine(from: SCNVector3,
                            to: SCNVector3,
                            segments: Int) -> SCNNode {
        
        let x1 = from.x
        let x2 = to.x
        
        let y1 = from.y
        let y2 = to.y
        
        let z1 = from.z
        let z2 = to.z
        
        let distance =  sqrt((x2-x1) * (x2-x1) +
                                (y2-y1) * (y2-y1) +
                                (z2-z1) * (z2-z1))
        
        let cylinder = SCNCylinder(radius: 0.05,
                                   height: CGFloat(distance))
        
        cylinder.radialSegmentCount = segments
        
        cylinder.firstMaterial?.diffuse.contents = NSColor.cyan
        
        let lineNode = SCNNode(geometry: cylinder)
        
        lineNode.position = SCNVector3(x: (from.x + to.x) / 2,
                                       y: (from.y + to.y) / 2,
                                       z: (from.z + to.z) / 2)
        
        lineNode.eulerAngles = SCNVector3(CGFloat.pi / 2,
                                          acos((to.z-from.z)/distance),
                                          atan2((to.y-from.y),(to.x-from.x)))
        
        return lineNode
    }
}

