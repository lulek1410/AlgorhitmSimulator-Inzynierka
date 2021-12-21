//
//  ContentViewModel.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 21/04/2021.
//

/// Model holding sub view displayed in MenuView and other instances of classes needed for menu to function properly.
class MenuModel{
    
    /// View model needed for ShapeButtonsView to function.
    let shape_buttons_row_view_model = ShapeButtonsViewModel()
    
    /// View model needed for PositionPropertiesView to function.
    let position_properties_view_model = PositionViewModel()
    
    /// View model needed for SizePropertiesView to function.
    let size_view_model = SizeViewModel()
    
    /// View model needed for PyramidPeakView to function.
    let pyramid_view_model = PyramidPropertiesViewModel()
    
    /// View model needed for OtherPropsView to function.
    let start_end_view_model = StartEndPropsViewModel()
    
    /// View model needed for SavesMenuView to function.
    let saves_view_model = SavesMenuViewModel()
    
    /// View for choosing obstacle shape.
    var shape_buttons_view : ShapeButtonsRow
    
    /// View for choosing obstacle position.
    var position_properties_view : PositionPropertiesView
    
    /// View for choosing obstacle size.
    var size_view : SizePropertiesView
    
    /// View model containing propertis describing weather object is start or end point.
    var start_end_view : StartEndPropsView
    
    /// View for choosing peak position for pyramid shaped objects.
    var pyramid_view : PyramidPeakView
    
    /// View for managing saved maps.
    var saves_view : SavesMenuView
    
    /// Instance of generator used to create new obstacles.
    var generator = ObstacleGenerator()
    
    /// Initializes ManuModel.
    init() {
        shape_buttons_view = ShapeButtonsRow(view_model: shape_buttons_row_view_model)
        position_properties_view = PositionPropertiesView(view_model: position_properties_view_model)
        size_view = SizePropertiesView(view_model: size_view_model)
        pyramid_view = PyramidPeakView(view_model: pyramid_view_model)
        start_end_view = StartEndPropsView(view_model: start_end_view_model)
        saves_view = SavesMenuView(view_model: saves_view_model)
    }
    
}
