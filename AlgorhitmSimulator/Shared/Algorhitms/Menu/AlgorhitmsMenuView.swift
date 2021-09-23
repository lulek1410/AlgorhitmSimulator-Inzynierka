//
//  AlgorhitmsMenu.swift
//  Test (iOS)
//
//  Created by Janek on 27/08/2021.
//

import SwiftUI

struct AlgorhitmsMenuView : View {
    
    @ObservedObject var view_model : AlgorhitmsViewModel = AlgorhitmsViewModel()
    
    var body: some View {
        VStack {
            LabeledDivider(label: "Algorhitms", font_size: 14, horizontal_padding: 5).padding(.top, 5)
            
            HStack{
                Button(action: { view_model.model.astar = !view_model.model.astar }){
                    HStack{
                        Image(systemName: view_model.model.astar ? "checkmark.square": "square")
                        Text("A* (A-star)")
                    }
                }.disabled(view_model.model.dijkstra || view_model.model.dijkstra_threads)
                .padding(.horizontal, 10)
                Spacer()
            }.padding(.top, 5)
            
            HStack{
                Button(action: { view_model.model.dijkstra = !view_model.model.dijkstra }){
                    HStack{
                        Image(systemName: view_model.model.dijkstra ? "checkmark.square": "square")
                        Text("Dijkstra")
                    }
                }.disabled(view_model.model.astar || view_model.model.dijkstra_threads)
                .padding(.horizontal, 10)
                Spacer()
            }.padding(.vertical, 5)
            
            HStack{
                Button(action: { view_model.model.dijkstra_threads = !view_model.model.dijkstra_threads }){
                    HStack{
                        Image(systemName: view_model.model.dijkstra_threads ? "checkmark.square": "square")
                        Text("Dijkstra multithread")
                    }
                }.disabled(view_model.model.astar || view_model.model.dijkstra)
                .padding(.horizontal, 10)
                Spacer()
            }
            
            Group {
                LabeledDivider(label: "Statistics", font_size: 12, horizontal_padding: 5).padding(.top, 5)
                HStack {
                    Text("Time needed: " + String(view_model.model.algorhitm_time))
                        .padding(5)
                    Spacer()
                }
                HStack {
                    Text("Distance: " + String(view_model.model.distance))
                        .padding(.horizontal, 5)
                        .padding(.bottom, 5)
                    Spacer()
                }
                HStack {
                    Text("Nodes processed: " + String(view_model.model.algorhitm_nodes_processed))
                        .padding(.horizontal, 5)
                        .padding(.bottom, 5)
                    Spacer()
                }
                HStack {
                    Text("Nodes from start to end: " + String(view_model.model.nodes_from_start_to_end))
                        .padding(.horizontal, 5)
                    Spacer()
                }
                Spacer()
            }
            
            Group{
                Text(view_model.model.information)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 5)
                    .multilineTextAlignment(.center)
                Button(action: {view_model.start()}) {
                    Text("Find path")
                }.disabled(view_model.model.disable_start_button)
                Button(action: {view_model.draw_delegate?.clearPreviousPath()}){
                    Text("Delete Path")
                }.disabled(view_model.model.disable_start_button)
                Button(action: {view_model.breakAlgothitm()}){
                    Text("Break Algorhitm")
                }.padding(.bottom, 100)
                .disabled(!view_model.model.disable_start_button)
            }
            
        }.frame(width: 250)
    }
}
