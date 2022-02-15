//
//  StartEndPropsViewModel.swift
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

import Foundation

class StartEndPropsViewModel : ObservableObject{
    
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
