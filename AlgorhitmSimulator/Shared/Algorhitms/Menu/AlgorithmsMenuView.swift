//
//  AlgorithmsMenu.swift
//  Test (iOS)
//
//  Created by Janek on 27/08/2021.
//

import SwiftUI

/// SwiftUI view in which we can pick and run shortest path algorithms and get some statistics of used algorithms
struct AlgorithmsMenuView : View {
    
    /// Instance of view model used to perform actions when events in view occur
    @ObservedObject var view_model : AlgorithmsViewModel = AlgorithmsViewModel()
    
    /// Body of view
    var body: some View {
        VStack {
            Group {
                LabeledDivider(label: "Algorithms", font_size: 14, horizontal_padding: 5).padding(.top, 5)
                
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
            }
            
            Group {
                LabeledDivider(label: "Options", font_size: 12, horizontal_padding: 5).padding(.top, 5)
                HStack {
                    Text("Altitude change cost modifier: ")
                        .padding(.leading, 5)
                    TextField("Modifier",
                              value: $view_model.model.altidute_cost_modifier,
                              formatter: view_model.model.formatter.number_formatter_double)
                        .padding(.trailing, 5)
                }
            }
            
            Group {
                LabeledDivider(label: "Statistics", font_size: 12, horizontal_padding: 5).padding(.top, 5)
                HStack {
                    Text("Time needed: " + String(view_model.model.algorithm_time))
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
                    Text("Nodes processed: " + String(view_model.model.algorithm_nodes_processed))
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
                    Text("Break Algorithm")
                }.padding(.bottom, 50)
                .disabled(!view_model.model.disable_start_button)
            }
            
        }.frame(width: 250)
    }
}
