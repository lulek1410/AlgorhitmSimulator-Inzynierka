//
//  PositionViewModel.swift
//  Test
//
//  Created by Janek on 22/04/2021.
//

import Foundation
import SceneKit

/// View Model class responsible for managing PositionPropertiesView.
class PositionViewModel : ObservableObject{
    
    /// Model variable holding inputs provided by user.
    @Published var position  = Position()
    
    /// Instance of formatter used to format numerical values provided by user.
    var formatter = Formatter()
    
    /// Delegate variable used to delegate updating of currently selected obstacle's position.
    weak var delegate : UpdatePositionDelegate?
    
    ///  Updates currentli held and displayed position with provided values. Also disables view accesibility if said so.
    ///
    ///  - Parameters:
    ///      - position: *position to display and hold*
    ///      - disabled: *boolean value describeing weather the position view is accesible to user*
    func updatePosition(position : SCNVector3, disabled : Bool){
        
        self.position.position = position
        self.position.disabled = disabled
    }
}
