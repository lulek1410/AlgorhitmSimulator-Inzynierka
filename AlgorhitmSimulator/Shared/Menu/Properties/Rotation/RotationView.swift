//
//  RotationView.swift
//  Test
//
//  Created by Janek on 17/07/2021.
//

import SwiftUI

struct RotationView: View {
    
    @ObservedObject var view_model : RotationViewModel
    
    var body: some View {
        VStack{
            LabeledDivider(label: "Rotation", font_size: 12, horizontal_padding: 5)
            HStack{
                Text("Rotation x(°):")
                TextField("Rotation",
                          value : $view_model.rotation.rotation.x,
                          formatter : view_model.formatter.rotation_formatter,
                          onCommit : {view_model.delegate?.updateXRotation(new_x: view_model.rotation.rotation.x)})
                    .disabled(view_model.rotation.disabled)
            }
            HStack{
                Text("Rotation y(°):")
                TextField("Rotation",
                          value : $view_model.rotation.rotation.y,
                          formatter : view_model.formatter.rotation_formatter,
                          onCommit : {view_model.delegate?.updateYRotation(new_y: view_model.rotation.rotation.y)})
                    .disabled(view_model.rotation.disabled)
            }
            HStack{
                Text("Rotation z(°):")
                TextField("Rotation",
                          value : $view_model.rotation.rotation.z,
                          formatter : view_model.formatter.rotation_formatter,
                          onCommit : {view_model.delegate?.updateZRotation(new_z: view_model.rotation.rotation.z)})
                    .disabled(view_model.rotation.disabled)
            }
        }.padding(2)
    }
}

//struct OtherPropsView_Previews: PreviewProvider {
//    static var previews: some View {
//        OtherPropsView()
//    }
//}

