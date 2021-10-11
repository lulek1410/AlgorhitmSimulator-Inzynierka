//
//  ImageButton.swift
//  Test
//
//  Created by Janek on 21/04/2021.
//

import Foundation

/// Structure representing single button with image depicting shape
struct ShapeButton : Identifiable, Equatable{
    
    /// Unique value used for identification
    var id = UUID()
    
    /// Image displayed with the button
    var image : String
    
    /// Text containing name of button
    var text : String
}
