//
//  SizeViewModel.swift
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
import SwiftUI

class SizeViewModel : ObservableObject{
    
    @Published var size = Size()
    var formatter = Formatter()
    weak var  delegate : UpdateSizeDelegate?
    
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
