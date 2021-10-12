//
//  DataLoader.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 25/09/2021.
//

import SceneKit

/// Class used to manage save files containing saved maps.
class SavesManager {
    
    /// Loads text saved in file with given name.
    ///
    /// - Parameters:
    ///     - fillename: *Name of file from which we want to load*
    ///
    /// - Returns: *Text read from file*
    static func loadFromFile(filename: String, directory: String = "Saves/") -> String {
        var text : String = ""
        do {
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(directory + filename + ".txt")
            text = try String(contentsOf: path)
        }
        catch {
            print(error)
            print(error.localizedDescription)
        }
        return text
    }
    
    /// Saves given text to file with given name and creates file if it wasn't already created.
    ///
    /// - Parameters:
    ///     - filename: *Name of file to which we want to save or which we want to create*
    ///     - text: *Text we want to place in file*
    static func savetoFile(filename: String, text: String) {
        let datafromString = text.data(using: String.Encoding.utf8)
        do {
            var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Saves")
            print(path)
            if !FileManager.default.fileExists(atPath: path.path) {
                try! FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
            }
            path.appendPathComponent(filename + ".txt")
            try datafromString!.write(to: path)
        }
        catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    /// Processes given nodes in order to get key informations needed for map to be correctly saved and then recreated.
    ///
    /// - Parameters:
    ///     - nodes: *list of nodes which hold geometrical objects*
    ///
    /// - Returns: *Text  with all key information used to save maps*
    static func processMapInfoToSave(nodes: [SCNNode]) -> String {
        var result : String = ""
        for node in nodes {
            if !node.is_path && node.name != "Camera"{
                result += node.name! + ";"
                result += Int(node.width).description + ";"
                result += Int(node.height).description + ";"
                result += Int(node.length).description + ";"
                result += Int(node.position.x).description + ";"
                result += Int(node.position.y).description + ";"
                result += Int(node.position.z).description + ";"
                result += node.is_floor.description + ";"
                result += node.is_start.description + "\n"
            }
        }
        return result
    }
    
    /// Reads directory with saves in order to check present save iles in it.
    ///
    /// - Returns: *names of files placed in array*
    static func getPresentSaveFiles() -> [String] {
        var txt_file_names : [String] = []
        do {
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Saves")
            if !FileManager.default.fileExists(atPath: path.path) {
                try! FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
            }
            let directory_content = try FileManager.default.contentsOfDirectory(at: path,
                                                                                includingPropertiesForKeys: nil)
            let txt_file = directory_content.filter{$0.pathExtension == "txt"}
            txt_file_names = txt_file.map{$0.deletingPathExtension().lastPathComponent}
        }
        catch {
            print(error)
            print(error.localizedDescription)
        }
        return txt_file_names
    }
    
    /// Deletes file with given name.
    ///
    /// - Parameters:
    ///     - filename: *Name of file whech we want to delete*
    static func deleteFile(filename: String) {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Saves/" + filename + ".txt")
        if FileManager.default.fileExists(atPath: path.path) {
            try! FileManager.default.removeItem(atPath: path.path)
        }
    }
}
