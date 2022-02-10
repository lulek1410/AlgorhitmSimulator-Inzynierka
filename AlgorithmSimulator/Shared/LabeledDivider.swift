//
//  LabeledDivider.swift
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

struct LabeledDivider: View {

    let label : String
    let font_size : CGFloat
    let horizontal_padding : CGFloat
    let color : Color = .gray

    var body: some View {
            HStack {
                line
                Text(label)
                    .foregroundColor(color)
                    .font(.system(size: font_size))
                line
            }
        }

    var line: some View {
        VStack { Divider().background(color) }.padding(horizontal_padding)
    }
}
