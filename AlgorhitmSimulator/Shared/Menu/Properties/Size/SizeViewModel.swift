//
//  SizeViewModel.swift
//  Test
//
//  Created by Janek on 22/04/2021.
//

import Foundation
import SwiftUI

class SizeViewModel : ObservableObject{
    @Published var size = Size()
    var formatter = Formatter()
    weak var  delegate : UpdateSizeDelegate?
    
    func setTappedObjectsSize(size: Size, disabled_floor : Bool, start_end : Bool) {
        self.size = size
        self.size.disabled_floor = disabled_floor
        self.size.disabled_startend = start_end
    }
}
