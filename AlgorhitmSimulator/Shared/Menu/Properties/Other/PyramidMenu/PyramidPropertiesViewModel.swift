//
//  PyramidPropertiesViewModel.swift
//  Test
//
//  Created by Janek on 22/09/2021.
//

import Foundation

/// Options of peak postion to peak by user
enum PeakPosition : String, CaseIterable, Identifiable {
    case BottomLeft = "Bottom left"
    case BottomRight = "Bottom right"
    case TopLeft = "Top left"
    case TopRight = "Top right"
    
    var id : String {self.rawValue}
}

/// View Model class responsible for managing PyramidPeakView.
class PyramidPropertiesViewModel : ObservableObject {
    
    /// Model variable holding inputs provided by user.
    @Published var model = PyramidPeak()
    
    /// Delegate variable used to delegate updating currently selected object's peak position.
    weak var delegate : UpdatePeakPositionDelegate?
    
    /// Changes accesibility of PyramidPeakView.
    ///
    /// - Parameters:
    ///     - disabled: *Weather to disable view accesibility*
    func changeAccesibility(disabled : Bool) {
        model.disabled = disabled
    }
    
    /// Udates selected peak position to dispaly given peak position.
    ///
    /// - Parameters:
    ///     - peak_position: *peak position to make as currently selected*
    func setTappedObjectPeakPosition(peak_position : String) {
        model.peak_position = peak_position
    }
    
    /// Updates peak position of currently selected object.
    func updatePeak(){
        delegate?.updatePeakPosition(new_peak_position: model.peak_position)
    }
}
