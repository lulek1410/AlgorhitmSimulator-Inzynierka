//
//  SavesMenuView.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 28/09/2021.
//

import SwiftUI

/// SwiftUI view in which we can manage saved maps.
struct SavesMenuView: View {
    
    /// View model variable used to controll view and call actions when events occur in it.
    @ObservedObject var view_model : SavesMenuViewModel
    
    /// Main body of SavesMenuView.
    var body: some View {
        VStack {
            List(view_model.save_files, id: \.self, selection: $view_model.selected_file) { file in
                Text(file.name)
            }
            .frame(width: 250)
            .listStyle(SidebarListStyle())

            HStack {
                Text("Save as: ")
                TextField("File name", text: $view_model.file_name_to_save)
            }.padding(.horizontal, 5)
            HStack {
                Button(action: {
                    if view_model.file_name_to_save != "" {
                        view_model.save()
                    }
                    else if !view_model.selected_file.isEmpty {
                        view_model.show_overwrite_alert = true
                    }
                }){
                    Text("Save")
                }
                .alert(isPresented: $view_model.show_overwrite_alert) {
                    Alert(title: Text("Warning"),
                          message: Text("Are you sure you want to overwrite " + view_model.selected_file.first!.name + " file? Data saved there will be lost."),
                          primaryButton: .default(Text("Yes"), action: {view_model.overwriteSave()}),
                          secondaryButton: .default(Text("No")))
                }
                Button(action: {
                    view_model.loadSave()
                }) {
                    Text("Load")
                }
                Spacer()
                Button(action: {
                    if !view_model.selected_file.isEmpty {
                        view_model.show_delete_alert = true
                    }
                }) {
                    Text("Delete selected")
                }
                .alert(isPresented: $view_model.show_delete_alert){
                    Alert(title: Text("Warning"),
                          message: Text("Are you sure you want to delete this file? Data saved there will be lost."),
                          primaryButton: .default(Text("Yes"), action: {view_model.deleteFile()}),
                          secondaryButton: .default(Text("No")))
                }
            }.padding(.horizontal, 15)
                .padding(.bottom, 50)
        }
    }
}
