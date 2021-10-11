//
//  HelpManuView.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 11/10/2021.
//

import SwiftUI

/// Help view containing text and images giving basic information about the application and explaining how to use it.
struct HelpMenuView: View {
    var body: some View {
        VStack{
            LabeledDivider(label: "Description", font_size: 14, horizontal_padding: 10)
            Text("""
                Application was writen by Jan Szewczyński and was ment to be used as easy way to basicaly test some pathfinding algorithms. Inside the programe there are implementations of 3 algorithms:
                    
                    1. A* (A star)
                    2. Dijkstra
                    3. custom Dijkstra implementation (multithread)
                
                Also there is an editor which allows user to create their own testing grounds using provided object's shapes and modifiable parameters of those objects. Preview of aplications look is present below. in further parts of this help view i will try to make it easier to use the application for new users using images to make it easier to understad.
                """).padding(.horizontal, 15)
            
            LabeledDivider(label: "Application components", font_size: 14, horizontal_padding: 10)
            
        Spacer()
        }.frame(height: 600)
    }
}
