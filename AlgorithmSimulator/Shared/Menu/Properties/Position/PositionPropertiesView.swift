//
//  PositionPropertiesView.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 22/04/2021.
//

import SwiftUI

/// SwiftUI view in which user can set/change position properties of objects.
struct PositionPropertiesView: View {
    
    /// View model variable used to controll view and call actions when events occur in it.
    @ObservedObject var view_model : PositionViewModel
    
    /// Main body of PositionPropertiesView.
    var body: some View {
        VStack{
            LabeledDivider(label: "Position", font_size: 12, horizontal_padding: 5)
            HStack{
                Text("X:")
                    .padding(.leading, 10)
                TextField("X position",
                          value : $view_model.position.position.x,
                          formatter : view_model.formatter.number_formatter_int,
                          onCommit: {view_model.delegate?.updateXPosition(new_x: view_model.position.position.x)})
                    .disabled(view_model.position.disabled)
                Text("Y:")
                TextField("Y position",
                          value : $view_model.position.position.y,
                          formatter : view_model.formatter.number_formatter_int,
                          onCommit: {view_model.delegate?.updateYPosition(new_y: view_model.position.position.y)})
                    .disabled(view_model.position.disabled)
                Text("Z:")
                TextField("Z position",
                          value : $view_model.position.position.z,
                          formatter : view_model.formatter.number_formatter_int,
                          onCommit: {view_model.delegate?.updateZPosition(new_z: view_model.position.position.z)})
                    .disabled(view_model.position.disabled)
                    .padding(.trailing, 10)
            }
        }.padding(2)
    }
}
