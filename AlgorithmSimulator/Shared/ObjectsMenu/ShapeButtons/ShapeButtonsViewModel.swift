//
//  ImageButtonViewModel.swift
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

class ShapeButtonsViewModel: ObservableObject{
    
    @Published private(set) var shape_buttons : [ShapeButton] = []
    
    @Published var selected_button : ShapeButton?
    @Published var disabled : Bool = false
    weak var delegate : ShapeButtonsDelegate?
    
    func createButtons(){
        if shape_buttons.isEmpty {
            shape_buttons.append(ShapeButton(image: "Box", text: "Box"))
            shape_buttons.append(ShapeButton(image: "Pyramid", text: "Pyramid"))
            shape_buttons.append(ShapeButton(image: "Sphere", text: "Sphere"))
        }
    }
    
    func updateSelectedButton(button : ShapeButton){
        selected_button = button
        checkSelectedShape()
    }
    
    func checkSelectedShape(){
        delegate?.disablePeakPositionPicker(shape_name: selected_button!.text)
        delegate?.disableRadiusTextField(shape_name: selected_button!.text)
    }
}
