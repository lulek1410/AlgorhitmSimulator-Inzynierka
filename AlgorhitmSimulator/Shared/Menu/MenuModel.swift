//
//  ContentViewModel.swift
//  Test (iOS)
//
//  Created by Janek on 21/04/2021.
//

import Foundation

class MenuModel{
    let shape_buttons_row_view_model = ShapeButtonsViewModel()
    let position_properties_view_model = PositionViewModel()
    let size_view_model = SizeViewModel()
    //let rotation_view_model = RotationViewModel()
    //let physics_view_model = PhysicsViewModel()
    let pyramid_view_model = PyramidPropertiesViewModel()
    let other_view_model = OtherPropsViewModel()
    
    var shape_buttons_view : ShapeButtonsRow
    var position_properties_view : PositionPropertiesView
    var size_view : SizePropertiesView
    //var rotation_view : RotationView
    //var physics_view : PhysicsView
    var other_view : OtherPropsView
    var pyramid_view : PyramidPeakView
    
    var generator = ObstacleGenerator()
    
    init() {
        shape_buttons_view = ShapeButtonsRow(view_model: shape_buttons_row_view_model)
        position_properties_view = PositionPropertiesView(view_model: position_properties_view_model)
        size_view = SizePropertiesView(view_model: size_view_model)
        //rotation_view = RotationView(view_model: rotation_view_model)
        //physics_view = PhysicsView(view_model: physics_view_model)
        pyramid_view = PyramidPeakView(view_model: pyramid_view_model)
        other_view = OtherPropsView(view_model: other_view_model)
    }
    
}
