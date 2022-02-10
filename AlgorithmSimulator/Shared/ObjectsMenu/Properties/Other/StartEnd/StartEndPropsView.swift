//
//  OtherPropsView.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 17/08/2021.
//

import SwiftUI

struct StartEndPropsView: View {
    
    @ObservedObject var view_model = StartEndPropsViewModel()
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {view_model.updateSelection(start_end: "start")}){
                    HStack{
                        Image(systemName: view_model.model.is_start ? "checkmark.square": "square")
                        Text("Is Starting Point")
                    }
                }.disabled(view_model.model.is_end || view_model.model.start_point_added || view_model.model.disabled)
                .padding(.leading, 10)
                .padding(.top, 5)
                Spacer()
            }
            HStack{
                Button(action: {view_model.updateSelection(start_end: "end")}){
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
