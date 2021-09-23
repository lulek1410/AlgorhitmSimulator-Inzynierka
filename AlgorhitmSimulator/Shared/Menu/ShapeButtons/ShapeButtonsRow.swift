//
//  ShapeButtonsRow.swift
//  Test
//
//  Created by Janek on 21/04/2021.
//

import SwiftUI

struct ShapeButtonsRow: View {
    
    @ObservedObject var view_model : ShapeButtonsViewModel
    @State public var selected_button : ShapeButton?
    
    var body: some View {
        HStack{
            ForEach(view_model.shape_buttons){button in
                Button(action: {
                    self.view_model.selected_button = button
                    self.selected_button = button
                }){
                    VStack{
                        Image(button.image)
                        Text(button.text)
                            .foregroundColor(button == selected_button ? Color.orange : Color.gray)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(5)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(5)
        .onAppear{
            self.view_model.createButtons()
            self.view_model.selected_button = self.view_model.shape_buttons[0]
            self.selected_button = self.view_model.shape_buttons[0]
        }
    }
}

//struct ShapeButtonsRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ShapeButtonsRow(view_model: <#ImageButtonViewModel#>)
//    }
//}
