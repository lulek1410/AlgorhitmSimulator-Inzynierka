//
//  ShapeButtonsRow.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 21/04/2021.
//

import SwiftUI

/// SwiftUI view in which user can set shape property of objects.
struct ShapeButtonsRow: View {
    
    /// View model variable used to controll view and call actions when events occur in it.
    @ObservedObject var view_model : ShapeButtonsViewModel
    
    /// Main body of PositionPropertiesView.
    var body: some View {
        HStack{
            Spacer()
            ForEach(view_model.shape_buttons){button in
                Button(action: {
                    self.view_model.updateSelectedButton(button: button)
                }){
                    VStack{
                        Image(button.image)
                        Text(button.text)
                            .foregroundColor(button == view_model.selected_button ? Color.orange : Color.gray)
                    }
                }
                .disabled(view_model.disabled)
                .buttonStyle(PlainButtonStyle())
                .padding(5)
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear{
            self.view_model.createButtons()
            self.view_model.selected_button = self.view_model.shape_buttons[0]
        }
    }
}
