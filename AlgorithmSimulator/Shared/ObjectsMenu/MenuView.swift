//
//  MenuView.swift
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
import SceneKit

struct MenuView: View {
    
    @ObservedObject var view_model = MenuViewModel()
    
    var body: some View {
        Group {
            if !view_model.dispaly_saves {
                VStack{
                    Group{
                        Text("Obstacles Menu")
                            .padding(.top, 5)
                            .font(.system(size: 14))
                        Divider().padding(.horizontal, 5)
                        view_model.model.start_end_view
                        LabeledDivider(label: "Shape", font_size: 14, horizontal_padding: 5)
                        view_model.model.shape_buttons_view
                        LabeledDivider(label: "Properties", font_size: 14, horizontal_padding: 5)
                        view_model.model.position_properties_view
                        view_model.model.size_view
                        view_model.model.pyramid_view
                    }
                    
                    Spacer()
                    
                    Button(action: {view_model.createObstacle()}){
                        Text("Add object")
                    }
                    .disabled(view_model.disable_add_button)
                    Button(action: {view_model.menu_delegate?.deleteSelectedObject()}){
                        Text("Delete object")
                    }
                    .disabled(view_model.disable_delete_button)
                    .padding(.bottom, 10)
                    Button(action: {view_model.changeView()}){
                        Text("Files")
                    }.padding(.bottom, 20)
                    
                    HStack{
                        Spacer()
                        Button(action: {view_model.show_help_delegate?.showHelp()}){
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                        }
                        .padding(.bottom, 10)
                        .padding(.trailing, 15)
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }.frame(width: 250)
                    .onAppear {
                        view_model.onAppear()
                    }
            }
            else {
                VStack {
                    HStack{
                        Spacer()
                        Button(action: {view_model.changeView()}) {
                            Text("Back")
                        }
                        .buttonStyle(LinkButtonStyle())
                        .padding(.trailing, 5)
                        .padding(.top, 5)
                    }
                    view_model.model.saves_view
                }.frame(width: 250)
            }
        }
    }
}
