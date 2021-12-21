//
//  OtherPropsViewModel.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 17/08/2021.
//

import Foundation

/// View Model class responsible for managing StartEndPropsView.
class StartEndPropsViewModel : ObservableObject{
    
    /// Model variable holding inputs provided by user.
    @Published var model : StartEndProps = StartEndProps()
    weak var delegate : StartEndDelegate?
    
    func updateSelection(start_end: String){
        if start_end == "start" {
            model.is_start = !model.is_start
        }
        else if start_end == "end" {
            model.is_end = !model.is_end
        }
        delegate?.disableStartEndIrrelevantOptions(start_end_selected: model.is_end || model.is_start)
    }
}
