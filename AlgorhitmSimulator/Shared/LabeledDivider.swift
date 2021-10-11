//
//  LabeledDivider.swift
//  Test
//
//  Created by Janek on 22/04/2021.
//

import SwiftUI

/// Custom view provideing divider with lines on both sides of text displayed in the middle.
struct LabeledDivider: View {
    
    /// Text displayed in divider.
    let label : String
    
    /// Size of font used on displayed text.
    let font_size : CGFloat
    
    /// Padding form horizontal ends of view.
    let horizontal_padding : CGFloat
    
    /// Color of displayed text.
    let color : Color = .gray
    
    /// Body of view.
    var body: some View {
            HStack {
                line
                Text(label)
                    .foregroundColor(color)
                    .font(.system(size: font_size))
                line
            }
        }
    
    /// View representing horizontal line (Divider).
    var line: some View {
        VStack { Divider().background(color) }.padding(horizontal_padding)
    }
}
