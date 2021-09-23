//
//  LabeledDivider.swift
//  Test
//
//  Created by Janek on 22/04/2021.
//

import SwiftUI

struct LabeledDivider: View {
    
    let label : String
    let font_size : CGFloat
    let horizontal_padding : CGFloat
    let color : Color = .gray
    
    var body: some View {
            HStack {
                line
                Text(label)
                    .foregroundColor(color)
                    .font(.system(size: font_size))
                line
            }
        }

        var line: some View {
            VStack { Divider().background(color) }.padding(horizontal_padding)
        }
}
