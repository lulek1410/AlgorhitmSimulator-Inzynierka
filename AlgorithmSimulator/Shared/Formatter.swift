//
//  Formatter.swift
//  bcd
//
//  Created by Janek on 21/04/2021.
//

import Foundation

struct Formatter{
    let number_formatter = NumberFormatter()
    let rotation_formatter = NumberFormatter()
    init(){
        number_formatter.numberStyle = .decimal
        number_formatter.minimumFractionDigits = 0
        number_formatter.decimalSeparator = "."
        number_formatter.maximumFractionDigits = 1
        
        rotation_formatter.numberStyle = .decimal
        rotation_formatter.maximumFractionDigits = 0
    }
}
