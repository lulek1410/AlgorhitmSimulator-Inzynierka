//
//  SaveFiles.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 28/09/2021.
//

import Foundation

/// File containing saved map in saves folder.
struct SaveFiles : Identifiable, Equatable, Hashable {
    
    /// Unique value used for identification
    var id = UUID()
    
    ///  Save file name
    var name : String
}
