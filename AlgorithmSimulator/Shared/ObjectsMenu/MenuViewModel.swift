//
//  ContentViewHandler.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 21/04/2021.
//


/// Trzeba dodać w gridzie żeby zaznaczał punkty wewnątrz kuli jako nietraversable i przetestować czy działa, potestować jeszce tą kule ogólnie pod względem podstawowych funkcji.
/// Napisać algorytm meet in middle z dijkstrą albo czymkolwiek tak właściwie
/// Napisać jakąs opcję do dadawanie "przezroczystych przeszkód" które moga mieć odległości definiowane przy pomocy jakiejś funkcji predefiniowanej ewentualnie wpisywanej przez użytkownika ale sprawdzanej pod względem ujemności jej elementów.




import SceneKit

/// View Model class responsible for responding to events that occur in view that it operates on (MenuView).
class MenuViewModel : EditorSceneDelegate, ShapeButtonsDelegate, StartEndDelegate, ObservableObject{
    
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
    
    /// Updates data describing peak position of given pyramid shape.
    ///
    /// - Parameters:
    ///     - object: *Object which peak data to display in menu (if it is not a pyramid the function does nothing)*
    private func updatePeak(object: SCNNode) {
        if let name = object.name?.split(separator: " ") {
            disablePeakPositionPicker(shape_name: String(name[0]))
            if name[0] == "Pyramid"{
                let peak_pos = name[1] + " " + name[2]
                self.model.pyramid_view_model.setTappedObjectPeakPosition(peak_position: String(peak_pos))
            }
        }
    }
    
    /// Disables buttons depending on given objects parameters.
    ///
    /// - Parameters:
    ///     - object: *Object which data changes buttons accesibility*
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
    
    /// Disables peak position picker menu depending on currently selected shape
    ///
    /// - Parameters:
    ///     - shape_name: *Name of selected shape*
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
    
    /// Updates model parameter making it possible to add new starting point.
    func startPointNotPresent() {
        model.start_end_view_model.model.start_point_added = false
    }
    
    /// Updates model parameter making it possible to add new end point.
    func endPointNotPresent() {
        model.start_end_view_model.model.end_point_added = false
    }
    
    /// Updates model parameter making it impossible to add new starting point.
    func startPointPresent() {
        model.start_end_view_model.model.start_point_added = true
        model.start_end_view_model.model.is_start = false
    }
    
    /// Updates model parameter making it impossible to add new end point.
    func endPointPresent() {
        model.start_end_view_model.model.end_point_added = true
        model.start_end_view_model.model.is_end = false
    }
    
    /// Changes currently displayed view.
    func changeView() {
        if self.dispaly_saves == false {
            model.saves_view_model.setupPresentFiles()
        }
        self.dispaly_saves = !self.dispaly_saves
    }
}
