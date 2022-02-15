//
//  ContentViewModel.swift
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

class ContentViewModel: ShowHelpDelegate, ObservableObject{

    @Published var content_model = ContentModel()

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
        
        content_model.menu_view.view_model.model.shape_buttons_row_view_model.delegate = content_model.menu_view.view_model
        
        content_model.menu_view.view_model.model.start_end_view_model.delegate = content_model.menu_view.view_model
        
        content_model.menu_view.view_model.show_help_delegate = self
    }

    func closeHelp(){
        content_model.display_help = false
    }

    func showHelp() {
        content_model.display_help = true
    }
}
