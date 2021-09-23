//
//  Physics.swift
//  Test
//
//  Created by Janek on 17/07/2021.
//


import Foundation

enum PhysicsType: String, Identifiable, CaseIterable{
    case Static
    case Dynamic
    case Kinematic
    
    var id: String {self.rawValue}
}

struct Physics{
    var physics_type : String = PhysicsType.Static.rawValue
    var disabled : Bool = false
}
