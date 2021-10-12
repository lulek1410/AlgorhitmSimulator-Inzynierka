//
//  PhysicsView.swift
//  Test
//
//  Created by Janek on 17/07/2021.
//

import SwiftUI

struct PhysicsView: View {
    
    @ObservedObject var view_model : PhysicsViewModel
    
    var body: some View {
        VStack{
            LabeledDivider(label: "Physics", font_size: 12, horizontal_padding: 5)
            Picker("Physics:",
                   selection: $view_model.physics.physics_type){
                ForEach(PhysicsType.allCases){type in
                    Text(type.rawValue)
                }
            }.onChange(of: view_model.physics.physics_type,
                       perform: {_ in
                        view_model.delegate?.updatePhysics(new_physics: view_model.physics.physics_type)
                       })
            .disabled(view_model.physics.disabled)
        }.padding(2)
    }
}
