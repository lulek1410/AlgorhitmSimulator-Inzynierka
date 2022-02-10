//
//  ContentViewHandler.swift
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

class MenuViewModel : EditorSceneDelegate, ShapeButtonsDelegate, StartEndDelegate, ObservableObject{
    
    var model  = MenuModel()
    
    @Published var disable_add_button: Bool = false
    @Published var disable_delete_button: Bool = true
    @Published var dispaly_saves: Bool = false
    var floor_created: Bool = false
    weak var menu_delegate: MenuDelegate?
    weak var show_help_delegate: ShowHelpDelegate?
    
    func createObstacle(){
        let position = model.position_properties_view_model.position.position
        var shape = model.shape_buttons_row_view_model.selected_button!.text
        if model.start_end_view_model.model.is_start || model.start_end_view_model.model.is_end {
            shape = "StartEnd"
        }
        let obstacle = model.generator.createShape(
            shape: shape,
            width: model.size_view_model.size.width,
            height: model.size_view_model.size.height,
            length: model.size_view_model.size.length,
            radius: model.size_view_model.size.radius,
            position: SCNVector3(position.x, position.y, -position.z),
            peak_position: model.pyramid_view_model.model.peak_position,
            is_start: model.start_end_view_model.model.is_start)
        
        menu_delegate?.obstacleCreated(object: obstacle)
        
        if model.start_end_view_model.model.is_start {
            startPointPresent()
            disableStartEndIrrelevantOptions(start_end_selected: false)
        }
        else if model.start_end_view_model.model.is_end {
            endPointPresent()
            disableStartEndIrrelevantOptions(start_end_selected: false)
        }
    }
    
    func onAppear() {
        if !floor_created {
            menu_delegate?.obstacleCreated(object: model.generator.createShape(shape: "Box",
                                                                               width: 30,
                                                                               height: 30,
                                                                               is_floor: true))
            floor_created = true
        }
    }
    
    func objectTapped(object: SCNNode) {
        self.model.shape_buttons_row_view_model.checkSelectedShape()
        
        updateSize(object: object)
        model.size_view_model.disableFloorStartEnd(disabled_floor: object.is_floor,
                                                   start_end: object.is_start || object.is_end)
        
        let position = object.position.z == 0 ? SCNVector3(object.position.x, object.position.y, 0) :
                                                SCNVector3(object.position.x, object.position.y, -object.position.z) 
        
        self.model.position_properties_view_model.updatePosition(position: position,
                                                                 disabled: object.is_floor)
        updatePeak(object: object)
        disableButtons(object: object)
    }
    
    private func updateSize(object: SCNNode){
        self.model.size_view_model.setTappedObjectsSize(size: Size(width: object.width * object.scale.x,
                                                              height: object.height * object.scale.y,
                                                              length: object.length * object.scale.z,
                                                              radius: 0))
        if let name = object.name?.split(separator: " ") {
            self.model.size_view_model.disableWhenSphere(radius_disabled: true, width_height_disabled: false)
            if name[0] == "Sphere"{
                self.model.size_view_model.setTappedObjectsSize(size: Size(width: 0,
                                                                      height: 0,
                                                                      length: 0,
                                                                      radius: object.radius))
                self.model.size_view_model.disableWhenSphere(radius_disabled: false, width_height_disabled: true)
            }
        }
    }
    
    private func updatePeak(object: SCNNode) {
        if let name = object.name?.split(separator: " ") {
            disablePeakPositionPicker(shape_name: String(name[0]))
            if name[0] == "Pyramid"{
                let peak_pos = name[1] + " " + name[2]
                self.model.pyramid_view_model.setTappedObjectPeakPosition(peak_position: String(peak_pos))
            }
        }
    }
    
    private func disableButtons(object: SCNNode) {
        disable_delete_button = true
        disable_add_button = false
        model.start_end_view_model.model.disabled = false
        if object.is_floor{
            disable_delete_button = true
            disable_add_button = true
            model.start_end_view_model.model.disabled = true
            model.shape_buttons_row_view_model.disabled = true
        }
        else if object.is_obstacle {
            disable_add_button = false
            disable_delete_button = false
            model.start_end_view_model.model.disabled = true
            model.shape_buttons_row_view_model.disabled = true
        }
        else{
            model.start_end_view_model.model.disabled = false
            model.shape_buttons_row_view_model.disabled = false
        }
        
    }
    
    func disablePeakPositionPicker(shape_name: String) {
        if shape_name == "Pyramid" {
            model.pyramid_view_model.changeAccesibility(disabled: false)
        }
        else {
            model.pyramid_view_model.changeAccesibility(disabled: true)
        }
    }
    
    func disableStartEndIrrelevantOptions(start_end_selected: Bool) {
        model.shape_buttons_view.view_model.disabled = start_end_selected
        model.size_view_model.size.disable_startend = start_end_selected
    }
    
    func disableRadiusTextField(shape_name: String) {
        if shape_name == "Sphere"{
            model.size_view_model.disableWhenSphere(radius_disabled: false, width_height_disabled: true)
        }
        else{
            model.size_view_model.disableWhenSphere(radius_disabled: true, width_height_disabled: false)
        }
    }
    
    func startPointNotPresent() {
        model.start_end_view_model.model.start_point_added = false
    }
    
    func endPointNotPresent() {
        model.start_end_view_model.model.end_point_added = false
    }
    
    func startPointPresent() {
        model.start_end_view_model.model.start_point_added = true
        model.start_end_view_model.model.is_start = false
    }
    
    func endPointPresent() {
        model.start_end_view_model.model.end_point_added = true
        model.start_end_view_model.model.is_end = false
    }
    
    func changeView() {
        if self.dispaly_saves == false {
            model.saves_view_model.setupPresentFiles()
        }
        self.dispaly_saves = !self.dispaly_saves
    }
}
