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
}
