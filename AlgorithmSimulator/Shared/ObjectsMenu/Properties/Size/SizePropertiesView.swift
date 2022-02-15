//
//  SizePropertiesView.swift
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

struct SizePropertiesView: View {
    
    @ObservedObject var view_model : SizeViewModel

    var body: some View {
        VStack{
            LabeledDivider(label: "Size", font_size: 12, horizontal_padding: 5)
            HStack{
                VStack{
                    HStack{
                        Text("Width:")
                            .padding(.leading, 10)
                        TextField("Width",
                                  value: $view_model.size.width,
                                  formatter: view_model.formatter.number_formatter_int,
                                  onCommit: {view_model.delegate?.updateWidth(new_width: view_model.size.width)})
                            .disabled(view_model.isWidthHeightDisabled())
                            .padding(.trailing, 10)
                    }
                    HStack{
                        Text("Height:")
                            .padding(.leading, 10)
                        TextField("Height",
                                  value: $view_model.size.height,
                                  formatter: view_model.formatter.number_formatter_int,
                                  onCommit: {view_model.delegate?.updateHeight(new_height: view_model.size.height)})
                            .disabled(view_model.isWidthHeightDisabled())
                            .padding(.trailing, 10)
                    }
                    HStack{
                        Text("Length:")
                            .padding(.leading, 10)
                        TextField("Length",
                                  value: $view_model.size.length,
                                  formatter: view_model.formatter.number_formatter_int,
                                  onCommit: {view_model.delegate?.updateLength(new_length: view_model.size.length)})
                            .disabled(view_model.isLengthDisabled())
                            .padding(.trailing, 10)
                    }
                    HStack{
                        Text("Radius:")
                            .padding(.leading, 10)
                        TextField("Radius",
                                  value: $view_model.size.radius,
                                  formatter: view_model.formatter.number_formatter_int,
                                  onCommit: {view_model.delegate?.updateRadius(new_radius: view_model.size.radius)})
                            .disabled(view_model.isRadiusDisabled())
                            .padding(.trailing, 10)
                    }
                }
            }.padding(2)
        }
    }
}
