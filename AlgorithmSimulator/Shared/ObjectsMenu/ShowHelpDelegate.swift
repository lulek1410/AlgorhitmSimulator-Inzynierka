//
//  OpenHelpDelegate.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 11/10/2021.
//

/// Delegation protocol used to show help view instead of editor
protocol ShowHelpDelegate: AnyObject{
    
    /// Delegates changing of state to ContentView
    func showHelp()
}
