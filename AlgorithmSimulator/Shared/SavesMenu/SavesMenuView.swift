//
//  SavesMenuView.swift
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

struct SavesMenuView: View {
    
    @ObservedObject var view_model : SavesMenuViewModel
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
                    if view_model.file_name_to_save != "" && !view_model.isGivenNameAlreadyUsed() {
                        view_model.save()
                    }
                    else if !view_model.selected_file.isEmpty {
                        view_model.show_overwrite_alert = true
                        view_model.overwtire_message = "Are you sure you want to overwrite " + view_model.selected_file.first!.name + " file? Data saved there will be lost."
                    }
                    else if view_model.isGivenNameAlreadyUsed() {
                        view_model.show_overwrite_alert = true
                        view_model.overwtire_message = "Are you sure you want to overwrite " + view_model.file_name_to_save + " file? Data saved there will be lost."
                    }
                }){
                    Text("Save")
                }
                .alert(isPresented: $view_model.show_overwrite_alert) {
                    Alert(title: Text("Warning"),
                          message: Text(view_model.overwtire_message!),
                          primaryButton: .default(Text("Yes"), action: {view_model.isGivenNameAlreadyUsed() ? view_model.overwriteSaveFromGivenName() : view_model.overwriteSaveFromFileList()}),
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
