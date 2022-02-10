//
//  ContentView.swift
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

struct ContentView: View {

    @ObservedObject var content = ContentViewModel()

    var body: some View {
        if !content.content_model.display_help{
            HStack(alignment: .center, spacing: nil) {
                content.content_model.algorithms_menu
                content.content_model.scene_view
                content.content_model.menu_view
            }.frame(minWidth: 1200)
        }
        else{
            VStack {
                HStack{
                    Spacer()
                    Button(action: {content.closeHelp()}) {
                        Text("Back")
                    }
                    .buttonStyle(LinkButtonStyle())
                    .padding(.trailing, 5)
                    .padding(.top, 5)
                }
                content.content_model.help_menu_view
            }.frame(width: 1200)
        }
    }
}
