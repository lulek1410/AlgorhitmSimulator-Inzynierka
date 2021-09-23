//
//  PhysicsViewModel.swift
//  Test
//
//  Created by Janek on 17/07/2021.
//

import Foundation
import SwiftUI

class PhysicsViewModel : ObservableObject{
    @Published var physics = Physics()
    weak var delegate : UpdatePhysicsDelegate?
    
    func updatePhysics(physics : Int, disabled : Bool){
        switch(physics){
        case 1 : self.physics.physics_type = "Dynamic"
        case 2 : self.physics.physics_type = "Kinematic"
        default:
            self.physics.physics_type = "Static"
        }
        self.physics.disabled = disabled
    }
}
