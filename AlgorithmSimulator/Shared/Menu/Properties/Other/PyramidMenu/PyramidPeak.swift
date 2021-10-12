//
//  PyramidPeak.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 22/09/2021.
//

/// Pyramid peak position property holders.
struct PyramidPeak {
    
    /// Disable view ability to be modified.
    var disabled : Bool =  false
    
    /// User inputed position of peak for pyramid shaped objects.
    var peak_position : String = PeakPosition.BottomLeft.rawValue
}
