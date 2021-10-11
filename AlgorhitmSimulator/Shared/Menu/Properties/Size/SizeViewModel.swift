//
//  SizeViewModel.swift
//  Test
//
//  Created by Janek on 22/04/2021.
//

import Foundation
import SwiftUI

/// View Model class responsible for managing SizePropertiesView.
class SizeViewModel : ObservableObject{
    
    /// Model variable holding inputs provided by user.
    @Published var size = Size()
    
    /// Instance of formatter used to format numerical values provided by user.
    var formatter = Formatter()
    
    /// Delegate variable used to delegate updating of currently selected obstacle's size.
    weak var  delegate : UpdateSizeDelegate?
    
    /// Updates current size with given value. Disables some functionality depending on currentlu selected object.
    ///
    /// - Parameters:
    ///     - size: *Size to set and hold *
    ///     - disabled_floor: *weather currently selected object is floor obstacle*
    ///     - start_end: *weather currently selected object is start or end point*
    func setTappedObjectsSize(size: Size, disabled_floor : Bool, start_end : Bool) {
        self.size = size
        self.size.disabled_floor = disabled_floor
        self.size.disabled_startend = start_end
    }
}
