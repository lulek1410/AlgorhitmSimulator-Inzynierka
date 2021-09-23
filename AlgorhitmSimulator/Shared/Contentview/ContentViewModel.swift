//
//  ContentViewController.swift
//  Test
//
//  Created by Janek on 17/07/2021.
//

import Foundation

class ContentViewModel{
    var content_model = ContentModel()
    
    init(){
        
        content_model.scene_view.scene_view_representable.content.coordinator!.delegate_object_tapped = content_model.menu_view.view_model
        
        content_model.scene_view.scene_view_representable.content.coordinator!.generator = content_model.menu_view.view_model.model.generator
        
        content_model.menu_view.view_model.model.position_properties_view_model.delegate = content_model.scene_view.scene_view_representable.content.coordinator
        
        content_model.menu_view.view_model.model.size_view_model.delegate = content_model.scene_view.scene_view_representable.content.coordinator
        
        content_model.menu_view.view_model.menu_delegate = content_model.scene_view.scene_view_representable.content.coordinator
        
        content_model.scene_view.scene_view_representable.content.coordinator?.delegate_obstacles = content_model.algorhitms_menu.view_model
        
        content_model.algorhitms_menu.view_model.draw_delegate = content_model.scene_view.scene_view_representable.content.coordinator
        
        content_model.menu_view.view_model.model.pyramid_view_model.delegate = content_model.scene_view.scene_view_representable.content.coordinator
    }
}
