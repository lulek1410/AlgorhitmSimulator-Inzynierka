//
//  ContentView.swift
//  Shared
//
//  Created by Janek on 21/04/2021.
//

import SwiftUI

struct ContentView: View {
    
    let content = ContentViewModel()
    
    var body: some View {
        HStack(alignment: .center, spacing: nil) {
            content.content_model.algorhitms_menu
            content.content_model.scene_view
            content.content_model.menu_view
        }.frame(minWidth: 1200)
    }
}
