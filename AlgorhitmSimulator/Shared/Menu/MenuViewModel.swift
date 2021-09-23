//
//  ContentViewHandler.swift
//  Test
//
//  Created by Janek on 21/04/2021.
//

import Foundation
import SceneKit

class MenuViewModel : ObjectTappedDelegate, ObservableObject{
    
    var model  = MenuModel()
    @Published var disable_add_button : Bool = false
    @Published var disable_delete_button : Bool = true
    @Published var objects : [SCNNode]?
    weak var menu_delegate : MenuDelegate?
    
    func createObstacle(){
        let position = model.position_properties_view_model.position.position
        var shape = model.shape_buttons_row_view_model.selected_button!.text
        if model.other_view_model.model.is_start || model.other_view_model.model.is_end {
            shape = "Sphere"
        }
        let obstacle = model.generator.createShape(
            shape: shape,
            width: model.size_view_model.size.width,
            height: model.size_view_model.size.height,
            length: model.size_view_model.size.length,
            position: SCNVector3(position.x, position.y, -position.z),
            peak_position: model.pyramid_view_model.model.peak_position,
            is_start: model.other_view_model.model.is_start)
        
        menu_delegate?.obstacleCreated(object: obstacle)
        
        if model.other_view_model.model.is_start {
            model.other_view_model.model.start_point_added = true
            model.other_view_model.model.is_start = false
        }
        else if model.other_view_model.model.is_end {
            model.other_view_model.model.end_point_added = true
            model.other_view_model.model.is_end = false
        }
    }
    
    func onAppear() {
        menu_delegate?.obstacleCreated(object: model.generator.createShape(shape: "Box",
                                                                           width: 30,
                                                                           height: 30,
                                                                           is_floor: true))
    }
    
    func objectTapped(object: SCNNode) {
        
        self.model.size_view_model.setTappedObjectsSize(size: Size(width: object.width * object.scale.x,
                                                              height: object.height * object.scale.y,
                                                              length: object.length * object.scale.z),
                                                              disabled_floor: object.is_floor,
                                                              start_end: object.is_start || object.is_end)

        let position = object.position.z == 0 ? SCNVector3(object.position.x, object.position.y, 0) :
                                                SCNVector3(object.position.x, object.position.y, -object.position.z) 
        
        self.model.position_properties_view_model.updatePosition(position: position,
                                                                 disabled: object.is_floor)
        
        updatePeak(object: object)
        disableButtons(object: object)
    }
    
    private func updatePeak(object : SCNNode) {
        if let name = object.name?.split(separator: " ") {
            if name[0] == "Pyramid"{
                let peak_pos = name[1] + " " + name[2]
                self.model.pyramid_view_model.setTappedObjectPeakPosition(peak_position: String(peak_pos))
            }
        }
    }
    
    private func disableButtons(object : SCNNode) {
        disable_delete_button = true
        disable_add_button = false
        model.other_view_model.model.disabled = false
        if object.is_floor{
            disable_delete_button = true
            disable_add_button = true
            model.other_view_model.model.disabled = true
        }
        else if object.is_obstacle {
            disable_add_button = false
            disable_delete_button = false
        }
    }
    
    func startPointDeleted() {
        model.other_view_model.model.start_point_added = false
    }
    
    func endPointDeleted() {
        model.other_view_model.model.end_point_added = false
    }
}
