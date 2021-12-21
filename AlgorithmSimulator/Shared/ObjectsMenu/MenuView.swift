//
//  MenuView.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 22/04/2021.
//

import SwiftUI
import SceneKit

/// SwiftUI view in which we manage files with map saves.
struct MenuView: View {
    
    /// View model variable used to controll view and call actions when events occur in it.
    @ObservedObject var view_model = MenuViewModel()
    
    /// Main body of SavesMenuView.
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
