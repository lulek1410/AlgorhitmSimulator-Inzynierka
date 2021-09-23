//
//  NumberFormatter.swift
//  Test
//
//  Created by Janek on 22/04/2021.
//

import Foundation

struct Formatter{
    let number_formatter = NumberFormatter()
    let rotation_formatter = NumberFormatter()
    init(){
        number_formatter.numberStyle = .decimal
        number_formatter.minimumFractionDigits = 0
        number_formatter.maximumFractionDigits = 0
        number_formatter.minimum = 0
    }
}
