//
//  NumberFormatter.swift
//  Test
//
//  Created by Janek on 22/04/2021.
//

import Foundation

/// Sctucture containing definitions for number formatters used in places when numerical user input is needed.
struct Formatter{
    
    /// Formatter for numerical values to make them positive integers.
    let number_formatter_int = NumberFormatter()
    
    /// Formatter for numerical values to make them floating point numbers with maximum of 1 fraction digits and minimal value of 1.
    let number_formatter_double = NumberFormatter()
    
    /// Initializes formatters.
    init(){
        number_formatter_int.numberStyle = .decimal
        number_formatter_int.minimumFractionDigits = 0
        number_formatter_int.maximumFractionDigits = 0
        number_formatter_int.minimum = 0
        
        number_formatter_double.numberStyle = .decimal
        number_formatter_double.minimumFractionDigits = 0
        number_formatter_double.maximumFractionDigits = 1
        number_formatter_double.decimalSeparator = "."
        number_formatter_double.minimum = 1.0
    }
}
