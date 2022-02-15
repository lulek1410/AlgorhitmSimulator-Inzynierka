//
//  PyramidPropertiesViewModel.swift
//  AlgorithmSimulator-macOS
//
//  Copyright (c) 2021 Jan Szewczyński
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

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
