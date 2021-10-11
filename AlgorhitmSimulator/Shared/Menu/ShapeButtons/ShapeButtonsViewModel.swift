//
//  ImageButtonViewModel.swift
//  Test
//
//  Created by Janek on 21/04/2021.
//

import Foundation

/// View Model class responsible for managing ShapeButtonsRow view.
class ShapeButtonsViewModel : ObservableObject{
    
    ///  All buttons representing obstacles shapes.
    @Published private(set) var shape_buttons : [ShapeButton] = []
    
    /// Currently selected button.
    @Published var selected_button : ShapeButton?
    
    /// Sets up all shape buttons available
    func createButtons(){
        if shape_buttons.isEmpty {
            shape_buttons.append(ShapeButton(image: "Box", text: "Box"))
            shape_buttons.append(ShapeButton(image: "Pyramid", text: "Pyramid"))
        }
    }
}
