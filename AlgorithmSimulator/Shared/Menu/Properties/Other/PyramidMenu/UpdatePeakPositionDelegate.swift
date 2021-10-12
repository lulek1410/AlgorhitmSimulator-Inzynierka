//
//  UpdatePeakPosition.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 23/09/2021.
//

import Foundation

/// Delegation protocol used to delegate used to update peak position of currently picked object..
protocol UpdatePeakPositionDelegate : AnyObject {
    
    /// Updates peak position with given value.
    ///
    /// - Parameters:
    ///     - new_peak_position: *Peak position to set as new*
    func updatePeakPosition(new_peak_position : String)
}
