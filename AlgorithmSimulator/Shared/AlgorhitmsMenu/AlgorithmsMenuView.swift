//
//  AlgorithmsMenuView.swift
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

import SwiftUI

struct AlgorithmsMenuView : View {

    @ObservedObject var view_model : AlgorithmsViewModel = AlgorithmsViewModel()
    
    var body: some View {
        VStack {
            Group {
                Text("Algorithms menu")
                    .font(.system(size: 14))
                    .padding(.top, 5)
                Divider().padding(.horizontal, 5)
                HStack {
                    Button(action: { view_model.model.astar = !view_model.model.astar }){
                        HStack{
                            Image(systemName: view_model.model.astar ? "checkmark.square": "square")
                            Text("A* (A-star)")
                        }
                    }.disabled(view_model.disableAStarCheck())
                        .padding(.horizontal, 10)
                    Spacer()
                }.padding(.top, 5)
                HStack {
                    Picker("Heuristics type:", selection: $view_model.model.heuristics_type){
                        Text("Diagonal").tag(HeuristicsType.Diagonal.rawValue)
                        Text("Euclidean").tag(HeuristicsType.Euclidean.rawValue)
                        
                    }.pickerStyle(.automatic)
                        .disabled(!view_model.model.astar)
                        .padding(.horizontal, 10)
                }.padding(.top, 5)
                HStack {
                    Button(action: { view_model.model.dijkstra = !view_model.model.dijkstra }){
                        HStack{
                            Image(systemName: view_model.model.dijkstra ? "checkmark.square": "square")
                            Text("Dijkstra")
                        }
                    }.disabled(view_model.disableDijkstraCheck())
                        .padding(.horizontal, 10)
                    Spacer()
                }.padding(.top, 3)
                HStack {
                    Button(action: { view_model.model.dijkstra_threads = !view_model.model.dijkstra_threads }){
                        HStack{
                            Image(systemName: view_model.model.dijkstra_threads ? "checkmark.square": "square")
                            Text("Dijkstra multithread")
                        }
                    }.disabled(view_model.disableDijkstraThreadsCheck())
                        .padding(.horizontal, 10)
                    Spacer()
                }.padding(.top, 3)
                HStack {
                    Button(action: { view_model.model.bidirectional = !view_model.model.bidirectional }){
                        HStack{
                            Image(systemName: view_model.model.bidirectional ? "checkmark.square": "square")
                            Text("Bidirectional Dijkstra")
                        }
                    }.disabled(view_model.disableBidirectionalDijkstraCheck())
                        .padding(.horizontal, 10)
                    Spacer()
                }.padding(.top, 3)
            }
            Group {
                LabeledDivider(label: "Options", font_size: 12, horizontal_padding: 5).padding(.top, 5)
                HStack {
                    Button(action: { view_model.model.dynamic_path_display = !view_model.model.dynamic_path_display }){
                        HStack{
                            Image(systemName: view_model.model.dynamic_path_display ? "checkmark.square": "square")
                            Text("Dynamic patch search display")
                        }
                    }
                    .padding(.horizontal, 10)
                    .disabled(view_model.model.display_all_visited)
                    Spacer()
                }
                HStack {
                    Button(action: { view_model.model.display_all_visited = !view_model.model.display_all_visited }){
                        HStack{
                            Image(systemName: view_model.model.display_all_visited ? "checkmark.square": "square")
                            Text("Display all visited nodes")
                        }
                    }
                    .padding(.horizontal, 10)
                    .disabled(view_model.model.dynamic_path_display)
                    Spacer()
                }
                HStack {
                    Button(action: { view_model.model.fixed_height = !view_model.model.fixed_height }){
                        HStack{
                            Image(systemName: view_model.model.fixed_height ? "checkmark.square": "square")
                            Text("Fixed map height")
                        }
                    }.padding(.leading, 10)
                    TextField("value",
                              value: $view_model.model.fixed_height_value,
                              formatter: view_model.model.formatter.number_formatter_int)
                        .padding(.trailing, 10)
                        .disabled(!view_model.model.fixed_height)
                }
                HStack {
                    Text("Altitude change cost modifier: ")
                        .padding(.leading, 10)
                    Spacer()
                }
                HStack {
                    TextField("Modifier",
                              value: $view_model.model.altidute_change_cost_modifier,
                              formatter: view_model.model.formatter.number_formatter_double)
                        .padding(.leading, 10)
                        .frame(width: 100)
                    Spacer()
                }
                HStack {
                    Text("Higher altitude movement modifier: ")
                        .padding(.trailing, 10)
                }
                HStack {
                    TextField("Modifier",
                              value: $view_model.model.altitude_movement_cost_modifier,
                              formatter: view_model.model.formatter.number_formatter_double)
                        .padding(.leading, 10)
                        .frame(width: 100)
                        
                    Spacer()
                }
            }
            Group {
                LabeledDivider(label: "Statistics", font_size: 12, horizontal_padding: 5).padding(.top, 5)
                HStack {
                    Text("Time needed: " + String(view_model.model.algorithm_time))
                        .padding(.horizontal, 10)
                        .padding(.top, 5)
                    Spacer()
                }
                HStack {
                    Text("Distance: " + String(view_model.model.distance))
                        .padding(.horizontal, 10)
                        .padding(.top, 5)
                    Spacer()
                }
                HStack {
                    Text("Nodes processed: " + String(view_model.model.algorithm_nodes_processed))
                        .padding(.horizontal, 10)
                        .padding(.top, 5)
                    Spacer()
                }
                HStack {
                    Text("Nodes from start to end: " + String(view_model.model.nodes_from_start_to_end))
                        .padding(.horizontal, 10)
                        .padding(.top, 5)
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
                Button(action: {view_model.deletePaths()}){
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
