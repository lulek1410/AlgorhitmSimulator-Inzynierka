//
//  StartEndPropsView.swift
//  AlgorithmSimulator-macOS
//
//  Copyright (c) 2021 Jan Szewczyński
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

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
