//
//  UpdatePositionDelegate.swift
//  Test
//
//  Created by Janek on 09/08/2021.
//

import SceneKit

protocol UpdatePositionDelegate : AnyObject {
    func updateXPosition(new_x : CGFloat)
    func updateYPosition(new_y : CGFloat)
    func updateZPosition(new_z : CGFloat)
}
