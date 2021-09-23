//
//  PositionViewModel.swift
//  Test
//
//  Created by Janek on 22/04/2021.
//

import Foundation
import SceneKit

class PositionViewModel : ObservableObject{
    @Published var position  = Position()
    var formatter = Formatter()
    weak var delegate : UpdatePositionDelegate?
    
    func updatePosition(position : SCNVector3, disabled : Bool){
        
        self.position.position = position
        self.position.disabled = disabled
    }
}
