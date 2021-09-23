//
//  DeleteSelectedObjectDelegate.swift
//  Test
//
//  Created by Janek on 12/08/2021.
//
import SceneKit

protocol  MenuDelegate : AnyObject {
    func obstacleCreated(object : SCNNode)
    func deleteSelectedObject()
}
