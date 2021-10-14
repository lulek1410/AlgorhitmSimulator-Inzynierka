//
//  SavesMenuViewModel.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 28/09/2021.
//

import Foundation

/// View Model class responsible for responding to events that occur in view that it operates on (SavesMenuView).
class SavesMenuViewModel: ObservableObject{
    
    /// All files present in folder containing saved maps.
    @Published private(set) var save_files: [SaveFiles] = []
    
    /// Currently sellected file.
    @Published var selected_file = Set<SaveFiles>()
    
    /// User input describing file name to which he wants to save current map.
    @Published var file_name_to_save: String = ""
    
    /// Variable controlling weather to display allert with information when user tries to delete file.
    @Published var show_delete_alert: Bool = false
    
    /// Variable controlling weather to display allert with information when user tries to overwrite file.
    @Published var show_overwrite_alert: Bool = false
    
    var overwtire_message: String?
    
    /// Delegate variable used to delegate save and load actions
    weak var delegate: SaveMenuDelegate?
    
    ///  Gets save files currently present in saves folder in order to display them to user
    func setupPresentFiles() {
        save_files.removeAll()
        selected_file.removeAll()
        let files = SavesManager.getPresentSaveFiles()
        for file in files {
            save_files.append(SaveFiles(name: file))
        }
    }
    
    /// Delegates save action and updates currently displayed files to include newly created file.
    func save() {
        delegate?.saveMap(filename: file_name_to_save)
        file_name_to_save = ""
        setupPresentFiles()
    }
    
    /// Delegates save action when it involves overwriteing currently existing file.
    func overwriteSaveFromFileList() {
        delegate?.saveMap(filename: selected_file.first!.name)
    }
    
    func overwriteSaveFromGivenName() {
        delegate?.saveMap(filename: file_name_to_save)
    }
    
    /// Delegates load action in order to get saved map from file and display it.
    func loadSave() {
        if !selected_file.isEmpty {
            delegate?.loadMap(filename: selected_file.first!.name)
        }
    }
    
    
    /// Deletes selected file and updates view to exclude deleted file.
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
