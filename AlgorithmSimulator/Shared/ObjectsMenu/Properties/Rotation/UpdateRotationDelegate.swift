//
//  UpdatePositionDelegate.swift
//  Test
//
//  Created by Janek on 09/08/2021.
//

import SceneKit

protocol UpdateRotationDelegate : AnyObject {
    func updateXRotation(new_x : CGFloat)
    func updateYRotation(new_y : CGFloat)
    func updateZRotation(new_z : CGFloat)
}
