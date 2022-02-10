//
//  PyramidPropertiesViewModel.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 22/09/2021.
//

import Foundation

enum PeakPosition : String, CaseIterable, Identifiable {
    case BottomLeft = "Bottom left"
    case BottomRight = "Bottom right"
    case TopLeft = "Top left"
    case TopRight = "Top right"
    
    var id : String {self.rawValue}
}

class PyramidPropertiesViewModel : ObservableObject {
    
    @Published var model = PyramidPeak()
    
    weak var delegate : UpdatePeakPositionDelegate?
    
    func changeAccesibility(disabled : Bool) {
        model.disabled = disabled
    }
    
    func setTappedObjectPeakPosition(peak_position : String) {
        model.peak_position = peak_position
    }
    
    func updatePeak(){
        delegate?.updatePeakPosition(new_peak_position: model.peak_position)
    }
}
