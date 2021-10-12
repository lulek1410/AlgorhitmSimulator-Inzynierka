//
//  OtherPropertiesViewModel.swift
//  Test
//
//  Created by Janek on 22/04/2021.
//

import Foundation
import SceneKit

class RotationViewModel : ObservableObject{
    @Published var rotation = Rotation()
    var formatter = Formatter()
    weak var delegate : UpdateRotationDelegate?
    
    func updateRotation(rotation : SCNVector3, disabled : Bool){
        self.rotation.rotation = rotation
        self.rotation.disabled = disabled
    }
}
