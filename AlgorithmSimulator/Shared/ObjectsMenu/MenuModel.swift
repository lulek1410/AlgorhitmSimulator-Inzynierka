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

class MenuModel{
    
    let shape_buttons_row_view_model = ShapeButtonsViewModel()
    let position_properties_view_model = PositionViewModel()
    let size_view_model = SizeViewModel()
    let pyramid_view_model = PyramidPropertiesViewModel()
    let start_end_view_model = StartEndPropsViewModel()
    let saves_view_model = SavesMenuViewModel()
    var shape_buttons_view : ShapeButtonsRow
    var position_properties_view : PositionPropertiesView
    var size_view : SizePropertiesView
    var start_end_view : StartEndPropsView
    var pyramid_view : PyramidPeakView
    var saves_view : SavesMenuView
    var generator = ObstacleGenerator()
    
    init() {
        shape_buttons_view = ShapeButtonsRow(view_model: shape_buttons_row_view_model)
        position_properties_view = PositionPropertiesView(view_model: position_properties_view_model)
        size_view = SizePropertiesView(view_model: size_view_model)
        pyramid_view = PyramidPeakView(view_model: pyramid_view_model)
        start_end_view = StartEndPropsView(view_model: start_end_view_model)
        saves_view = SavesMenuView(view_model: saves_view_model)
    }
    
}
