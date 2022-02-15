//
//  PyramidPeakView.swift
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

struct PyramidPeakView: View {
    
    @ObservedObject var view_model : PyramidPropertiesViewModel = PyramidPropertiesViewModel()
    
    var body: some View {
        VStack {
            LabeledDivider(label: "Pyramid peak", font_size: 12, horizontal_padding: 5)
            HStack {
                Text("Peak position: ")
                    .padding(.leading, 10)
                Spacer()
            }
            HStack {
                Spacer()
                Picker("", selection: $view_model.model.peak_position){
                    Text("Bottom left").tag(PeakPosition.BottomLeft.rawValue)
                    Text("Bottom right").tag(PeakPosition.BottomRight.rawValue)
                    
                }.pickerStyle(InlinePickerStyle())
                .disabled(view_model.model.disabled)
                Picker("", selection: $view_model.model.peak_position){
                    Text("Top left").tag(PeakPosition.TopLeft.rawValue)
                    Text("Top right").tag(PeakPosition.TopRight.rawValue)
                    
                }.pickerStyle(InlinePickerStyle())
                    .onChange(of: view_model.model.peak_position) {_ in view_model.updatePeak()}
                    .disabled(view_model.model.disabled)
                Spacer()
            }
        }
    }
}
