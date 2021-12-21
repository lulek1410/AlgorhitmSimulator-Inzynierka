//
//  PyramidPeakView.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 22/09/2021.
//

import SwiftUI

/// SwiftUI view in which user can set/change peak position properties of objects.
struct PyramidPeakView: View {
    
    /// View model variable used to controll view and call actions when events occur in it.
    @ObservedObject var view_model : PyramidPropertiesViewModel = PyramidPropertiesViewModel()
    
    /// Main body of PyramidPeakView.
    var body: some View {
        VStack {
            LabeledDivider(label: "Pyramid peak", font_size: 12, horizontal_padding: 5)
            HStack {
                Text("Peak position: ")
                    .padding(.leading, 10)
                Spacer()
            }
            HStack {
                Spacer()
                Picker("", selection: $view_model.model.peak_position){
                    Text("Bottom left").tag(PeakPosition.BottomLeft.rawValue)
                    Text("Bottom right").tag(PeakPosition.BottomRight.rawValue)
                    
                }.pickerStyle(InlinePickerStyle())
                .disabled(view_model.model.disabled)
                Picker("", selection: $view_model.model.peak_position){
                    Text("Top left").tag(PeakPosition.TopLeft.rawValue)
                    Text("Top right").tag(PeakPosition.TopRight.rawValue)
                    
                }.pickerStyle(InlinePickerStyle())
                    .onChange(of: view_model.model.peak_position) {_ in view_model.updatePeak()}
                    .disabled(view_model.model.disabled)
                Spacer()
            }
        }
    }
}
