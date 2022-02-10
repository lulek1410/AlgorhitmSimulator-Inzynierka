//
//  UpdateSizeDelegate.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 09/08/2021.
//

import SceneKit

protocol UpdateSizeDelegate : AnyObject {
    
    func updateWidth(new_width: CGFloat)
    func updateHeight(new_height: CGFloat)
    func updateLength(new_length: CGFloat)
    
    func updateRadius(new_radius: CGFloat)
}
