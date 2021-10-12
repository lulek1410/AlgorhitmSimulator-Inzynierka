//
//  ContentViewHandler.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 21/04/2021.
//

import SceneKit

/// View Model class responsible for responding to events that occur in view that it operates on (MenuView).
class MenuViewModel : EditorSceneDelegate, ObservableObject{
    
    /// Model variable holding obstacle generator and subviews displayed in MenuView .
    var model  = MenuModel()
    
    /// Variable decideing weather add obstacle button is active.
    @Published var disable_add_button: Bool = false
    
    /// Variable decideing weather delete obstacle button is active.
    @Published var disable_delete_button: Bool = true
    
    /// Variable decideing weather MenuView displays menu form managing obstacles or menu for managing save files.
    @Published var dispaly_saves: Bool = false
    
    /// Controls weather the floor obstacle has already been creates.
    var floor_created: Bool = false
    
    /// Delegate variable used to delegate creation and deletion of obstacles.
    weak var menu_delegate: MenuDelegate?
    
    /// Delegate variable used to delegate information that help view should be displayed
    weak var show_help_delegate: ShowHelpDelegate?
    
    /// Creates new obstacle using inputs provided by user to menu subviews.
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
            startPointPresent()
        }
        else if model.other_view_model.model.is_end {
            endPointPresent()
        }
    }
    
    /// Creates floor obstacle if there isn't one already.
    func onAppear() {
        if !floor_created {
            menu_delegate?.obstacleCreated(object: model.generator.createShape(shape: "Box",
                                                                               width: 30,
                                                                               height: 30,
                                                                               is_floor: true))
            floor_created = true
        }
    }
    
    /// Updates data displyed in sub views to match parameters of gicen object.
    ///
    /// - Parameters:
    ///     - object: *Currently selected obstacle*
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
    
    /// Updates data describing peak position of given pyramid shape.
    ///
    /// - Parameters:
    ///     - object: *Object which peak data to display in menu (if it is not a pyramid the function does nothing)*
    private func updatePeak(object: SCNNode) {
        if let name = object.name?.split(separator: " ") {
            if name[0] == "Pyramid"{
                let peak_pos = name[1] + " " + name[2]
                self.model.pyramid_view_model.setTappedObjectPeakPosition(peak_position: String(peak_pos))
            }
        }
    }
    
    /// Disables buttons depending on gicen objects parameters.
    ///
    /// - Parameters:
    ///     - object: *Object which data changes buttons accesibility*
    private func disableButtons(object: SCNNode) {
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
    
    /// Updates model parameter making it possible to add new starting point.
    func startPointNotPresent() {
        model.other_view_model.model.start_point_added = false
    }
    
    /// Updates model parameter making it possible to add new end point.
    func endPointNotPresent() {
        model.other_view_model.model.end_point_added = false
    }
    
    /// Updates model parameter making it impossible to add new starting point.
    func startPointPresent() {
        model.other_view_model.model.start_point_added = true
        model.other_view_model.model.is_start = false
    }
    
    /// Updates model parameter making it impossible to add new end point.
    func endPointPresent() {
        model.other_view_model.model.end_point_added = true
        model.other_view_model.model.is_end = false
    }
    
    /// Changes currently displayed view.
    func changeView() {
        if self.dispaly_saves == false {
            model.saves_view_model.setupPresentFiles()
        }
        self.dispaly_saves = !self.dispaly_saves
    }
}
