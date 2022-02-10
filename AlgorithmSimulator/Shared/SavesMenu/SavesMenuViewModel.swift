//
//  SavesMenuViewModel.swift
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

import Foundation

class SavesMenuViewModel: ObservableObject{
    
    @Published private(set) var save_files: [SaveFiles] = []
    @Published var selected_file = Set<SaveFiles>()
    @Published var file_name_to_save: String = ""
    @Published var show_delete_alert: Bool = false
    @Published var show_overwrite_alert: Bool = false
    var overwtire_message: String?
    weak var delegate: SaveMenuDelegate?
    
    func setupPresentFiles() {
        save_files.removeAll()
        selected_file.removeAll()
        let files = SavesManager.getPresentSaveFiles()
        for file in files {
            save_files.append(SaveFiles(name: file))
        }
    }
    
    func save() {
        delegate?.saveMap(filename: file_name_to_save)
        file_name_to_save = ""
        setupPresentFiles()
    }
    
    func overwriteSaveFromFileList() {
        delegate?.saveMap(filename: selected_file.first!.name)
    }
    
    func overwriteSaveFromGivenName() {
        delegate?.saveMap(filename: file_name_to_save)
    }
    
    func loadSave() {
        if !selected_file.isEmpty {
            delegate?.loadMap(filename: selected_file.first!.name)
        }
    }
    
    func deleteFile() {
        if !self.selected_file.isEmpty {
            SavesManager.deleteFile(filename: self.selected_file.first!.name)
            setupPresentFiles()
        }
    }
    
    func isGivenNameAlreadyUsed() -> Bool{
        for file in save_files {
            if file.name == file_name_to_save {
                return true
            }
        }
        return false
    }
}
