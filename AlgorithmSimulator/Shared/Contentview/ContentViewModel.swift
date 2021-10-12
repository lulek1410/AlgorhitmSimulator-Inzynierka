//
//  ContentViewController.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 17/07/2021.
//

import Foundation

/// Coordinator which handles events present in ContentView.
class ContentViewModel: ShowHelpDelegate, ObservableObject{

    /// Model variable holding data used in ContentView.
    @Published var content_model = ContentModel()
    
    /// Initializes model's variable's internal bindings.
    init(){
        
        content_model.scene_view.scene_view_representable.content.coordinator!.delegate_for_menu = content_model.menu_view.view_model
        
        content_model.scene_view.scene_view_representable.content.coordinator!.generator = content_model.menu_view.view_model.model.generator
        
        content_model.menu_view.view_model.model.position_properties_view_model.delegate = content_model.scene_view.scene_view_representable.content.coordinator
        
        content_model.menu_view.view_model.model.size_view_model.delegate = content_model.scene_view.scene_view_representable.content.coordinator
        
        content_model.menu_view.view_model.menu_delegate = content_model.scene_view.scene_view_representable.content.coordinator
        
        content_model.scene_view.scene_view_representable.content.coordinator?.obstacles_for_algorhitm_delegate = content_model.algorithms_menu.view_model
        
        content_model.algorithms_menu.view_model.draw_delegate = content_model.scene_view.scene_view_representable.content.coordinator
        
        content_model.menu_view.view_model.model.pyramid_view_model.delegate = content_model.scene_view.scene_view_representable.content.coordinator
        
        content_model.menu_view.view_model.model.saves_view_model.delegate = content_model.scene_view.scene_view_representable.content.coordinator
        
        content_model.menu_view.view_model.show_help_delegate = self
    }
    
    /// Closes help view and goes back to editor view.
    func closeHelp(){
        content_model.display_help = false
    }
    
    /// Opens help view.
    func showHelp() {
        content_model.display_help = true
    }
    
    
}
