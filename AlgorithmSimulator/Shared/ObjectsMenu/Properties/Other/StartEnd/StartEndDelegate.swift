//
//  StartEndDelegate.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 27/10/2021.
//

import Foundation

/// Delegation protocol used to disable views not relative to start/end point placement in scene
protocol StartEndDelegate : AnyObject {
    func disableStartEndIrrelevantOptions(start_end_selected : Bool)
}
