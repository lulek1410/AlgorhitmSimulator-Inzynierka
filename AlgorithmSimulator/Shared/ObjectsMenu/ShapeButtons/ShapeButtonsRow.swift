//
//  ShapeButtonsRow.swift
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

struct ShapeButtonsRow: View {
    
    @ObservedObject var view_model : ShapeButtonsViewModel
    
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
