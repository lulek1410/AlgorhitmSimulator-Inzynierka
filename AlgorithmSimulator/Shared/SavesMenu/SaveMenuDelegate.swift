//
//  SaveMenuDelegate.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 28/09/2021.
//

/// Delegation protocol used to delegate save and load actions from SavesMenu.
protocol SaveMenuDelegate : AnyObject {
    
    /// Saves current map to file.
    ///
    /// - Parameters:
    ///     - filename: *Name of file to which we want to save current map*
    func saveMap(filename : String)
    
    /// Loads map from given file.
    ///
    /// - Parameters:
    ///     - filaname: *Name of file from which we will load map that it contains*
    func loadMap(filename : String)
}
