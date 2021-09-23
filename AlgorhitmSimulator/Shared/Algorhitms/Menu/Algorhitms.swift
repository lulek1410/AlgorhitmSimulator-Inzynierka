//
//  Algorhitms.swift
//  Test (iOS)
//
//  Created by Janek on 27/08/2021.
//

import Foundation
import SceneKit

struct Algorhitms {
    var dijkstra : Bool = false
    var astar : Bool = false
    var dijkstra_threads : Bool = false
    var grid : Grid?
    var disable_start_button = false
    var information : String = ""
    var algorhitm_time : Double = 0
    var algorhitm_nodes_processed : Int = 0
    var nodes_from_start_to_end : Int = 0
    var distance : Float = 0
    var obstacles : [SCNNode]?
}
