//
//  Formatter.swift
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
//  copies or substantial portions of the Software

import Foundation

struct Formatter{
    
    let number_formatter_int = NumberFormatter()
    let number_formatter_double = NumberFormatter()
    
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
