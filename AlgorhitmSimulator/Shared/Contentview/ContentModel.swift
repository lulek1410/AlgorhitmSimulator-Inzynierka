//
//  ContentViewModel.swift
//  Test
//
//  Created by Janek on 17/07/2021.
//

import Foundation

/// Model holding all sub views that make up the whole aplication.
struct ContentModel{
    
    /// View displaying created scene.
    let scene_view = SceneKitView()
    
    /// View displaying menu for adding obstacles and saving created maps.
    let menu_view = MenuView()
    
    /// View displaying basic information about application and how to use it.
    let help_menu_view = HelpMenuView()
    
    /// View displaying menu for algorhitms .
    let algorithms_menu = AlgorithmsMenuView()
    
    /// Weather to display help view.
    var display_help: Bool = false
}
