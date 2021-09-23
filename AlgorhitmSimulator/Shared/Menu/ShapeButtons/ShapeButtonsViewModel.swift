//
//  ImageButtonViewModel.swift
//  Test
//
//  Created by Janek on 21/04/2021.
//

import Foundation

class ShapeButtonsViewModel : ObservableObject{
    
    @Published private(set) var shape_buttons : [ShapeButton] = []
    var selected_button : ShapeButton?
    
    func createButtons(){
        shape_buttons.append(ShapeButton(image: "Plane", text: "Plane"))
        shape_buttons.append(ShapeButton(image: "Box", text: "Box"))
        shape_buttons.append(ShapeButton(image: "Pyramid", text: "Pyramid"))
    }
}
