//
//  DrawPathDelegate.swift
//  Test
//
//  Created by Janek on 06/09/2021.
//

import Foundation

protocol DrawPathDelegate : AnyObject {
    func drawPath(grid : Grid)
    func clearPreviousPath()
}
