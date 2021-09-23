//
//  PositionChecker.swift
//  Test
//
//  Created by Janek on 01/09/2021.
//
import SceneKit

struct PositionChecker {
    static func checkPositionIsideFloor(obstacle : SCNNode, size : [Int]) -> Bool {
        if Int(obstacle.position.x) >= 0,
           Int(obstacle.position.x + obstacle.width) <= size[0],
           Int(obstacle.position.y) >= 0,
           Int(obstacle.position.y + obstacle.height) <= size[1],
           Int(obstacle.position.z) >= 0,
           Int(obstacle.position.z + obstacle.length) <= size[2]/2 {
            return true
        }
        return false
    }
}
