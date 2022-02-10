//
//  StartEndDelegate.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 27/10/2021.
//

import Foundation

protocol StartEndDelegate : AnyObject {
    func disableStartEndIrrelevantOptions(start_end_selected : Bool)
}
