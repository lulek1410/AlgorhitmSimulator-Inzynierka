//
//  OtherProperties.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 17/08/2021.
//

/// Start and End property holders.
struct StartEndProps {
    
    /// Weather object we are creating is starting point.
    var is_start : Bool = false
    
    /// Weather object we are creating is end point.
    var is_end : Bool = false
    
    ///  Disable view ability to be modified.
    var disabled : Bool = false
    
    /// Weather tarting ponit has already beed added.
    var start_point_added : Bool = false
    
    /// Weather end ponit has already beed added.
    var end_point_added : Bool = false
}
