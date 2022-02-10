//
//  UpdatePeakPosition.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 23/09/2021.
//

import Foundation

protocol UpdatePeakPositionDelegate : AnyObject {
    
    func updatePeakPosition(new_peak_position : String)
}
