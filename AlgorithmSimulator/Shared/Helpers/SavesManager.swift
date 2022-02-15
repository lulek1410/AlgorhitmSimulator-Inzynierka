//
//  SavesManager.swift
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

import SceneKit

class SavesManager {
    
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
    
    static func savetoFile(filename: String, text: String) {
        let datafromString = text.data(using: String.Encoding.utf8)
        do {
            var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Saves")
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
    
    static func processMapInfoToSave(nodes: [SCNNode]) -> String {
        var result : String = ""
        for node in nodes {
            if node.path == "" && node.name != "Camera" && node.name != "End coord" && node.name != "Start coord"{
                result += node.name! + ";"
                result += Int(node.width).description + ";"
                result += Int(node.height).description + ";"
                result += Int(node.length).description + ";"
                result += Int(node.radius).description + ";"
                result += Int(node.position.x).description + ";"
                result += Int(node.position.y).description + ";"
                result += Int(node.position.z).description + ";"
                result += node.is_floor.description + ";"
                result += node.is_start.description + "\n"
            }
        }
        return result
    }
    
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

    static func deleteFile(filename: String) {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Saves/" + filename + ".txt")
        if FileManager.default.fileExists(atPath: path.path) {
            try! FileManager.default.removeItem(atPath: path.path)
        }
    }
}
