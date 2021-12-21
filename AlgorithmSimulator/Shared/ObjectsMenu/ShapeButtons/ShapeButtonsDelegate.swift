//
//  ShapeButtonsDelegate.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 27/10/2021.
//

import Foundation

protocol ShapeButtonsDelegate: AnyObject {
    func disablePeakPositionPicker(shape_name: String)
    func disableRadiusTextField(shape_name: String)
}

