//
//  ObjectTappedDelegate.swift
//  Test
//
//  Created by Janek on 24/07/2021.
//

import Foundation
import SceneKit

protocol ObjectTappedDelegate : AnyObject{
    func objectTapped(object : SCNNode)
    func startPointDeleted()
    func endPointDeleted()
}
