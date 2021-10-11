//
//  OtherPropsView.swift
//  Test
//
//  Created by Janek on 17/08/2021.
//

import SwiftUI

/// SwiftUI view in which user can set properties of objects determining weather they are viewed as start or edn point in nodes grid.
struct StartEndPropsView: View {
    
    /// View model variable used to controll view and call actions when events occur in it.
    @ObservedObject var view_model = StartEndPropsViewModel()
    
    /// Main body of StartEndPropsView.
    var body: some View {
        VStack{
            LabeledDivider(label: "Other", font_size: 12, horizontal_padding: 5)
            HStack{
                Button(action: {view_model.model.is_start = !view_model.model.is_start}){
                    HStack{
                        Image(systemName: view_model.model.is_start ? "checkmark.square": "square")
                        Text("Is Starting Point")
                    }
                }.disabled(view_model.model.is_end || view_model.model.start_point_added || view_model.model.disabled)
                .padding(.leading, 10)
                Spacer()
            }
            HStack{
                Button(action: {view_model.model.is_end = !view_model.model.is_end}){
                    HStack{
                        Image(systemName: view_model.model.is_end ? "checkmark.square": "square")
                        Text("Is End Point")
                    }
                }.disabled(view_model.model.is_start || view_model.model.end_point_added || view_model.model.disabled)
                .padding(.leading, 10)
                Spacer()
            }
        }
    }
}
