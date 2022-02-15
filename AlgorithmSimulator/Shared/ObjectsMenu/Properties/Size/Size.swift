//
//  Size.swift
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

struct Size{
    
    var width: CGFloat = 0
    var height: CGFloat = 0
    var length: CGFloat = 0
    var radius: CGFloat = 0
    var disable_floor : Bool = false
    var disable_width_height: Bool = false
    var disable_radius: Bool = true
    var disable_startend : Bool = false
}
