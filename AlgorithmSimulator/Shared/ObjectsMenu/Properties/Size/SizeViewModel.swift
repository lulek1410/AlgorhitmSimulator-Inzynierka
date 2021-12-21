//
//  SizeViewModel.swift
//  AlgorithmSimulator-macOS
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
    func setTappedObjectsSize(size: Size = Size(width: 0, height: 0, length: 0, radius: 0)) {
        let temp = [self.size.disable_radius, self.size.disable_width_height]
        self.size = size
        self.size.disable_radius = temp[0]
        self.size.disable_width_height = temp[1]
    }
    
    func disableWhenSphere(radius_disabled: Bool = false, width_height_disabled: Bool){
        self.size.disable_radius = radius_disabled
        self.size.disable_width_height = width_height_disabled
    }
    
    func disableFloorStartEnd(disabled_floor : Bool, start_end : Bool){
        self.size.disable_floor = disabled_floor
        self.size.disable_startend = start_end
    }
    
    func isWidthHeightDisabled() -> Bool{
        return (size.disable_startend || size.disable_width_height) && !size.disable_floor
    }
    
    func isLengthDisabled() -> Bool{
        return size.disable_floor || size.disable_startend || size.disable_width_height || !size.disable_radius
    }
    
    func isRadiusDisabled() ->Bool{
        return size.disable_radius || size.disable_floor
    }
}
