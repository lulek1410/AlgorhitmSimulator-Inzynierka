//
//  OtherPropsView.swift
//  Test
//
//  Created by Janek on 17/08/2021.
//

import SwiftUI

struct OtherPropsView: View {
    @ObservedObject var view_model = OtherPropsViewModel()
    
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
