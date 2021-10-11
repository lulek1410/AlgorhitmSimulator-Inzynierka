//
//  ContentView.swift
//  Shared
//
//  Created by Janek on 21/04/2021.
//

import SwiftUI

/// Main view of aplication displaying all sub views in horizontal stack maner.
struct ContentView: View {
    
    /// View model managing view contents.
    @ObservedObject var content = ContentViewModel()
    
    /// Body of view.
    var body: some View {
        if !content.content_model.display_help{
            HStack(alignment: .center, spacing: nil) {
                content.content_model.algorithms_menu
                content.content_model.scene_view
                content.content_model.menu_view
            }.frame(minWidth: 1200)
        }
        else{
            VStack {
                HStack{
                    Spacer()
                    Button(action: {content.closeHelp()}) {
                        Text("Back")
                    }
                    .buttonStyle(LinkButtonStyle())
                    .padding(.trailing, 5)
                    .padding(.top, 5)
                }
                content.content_model.help_menu_view
            }.frame(width: 1200)
        }
    }
}
