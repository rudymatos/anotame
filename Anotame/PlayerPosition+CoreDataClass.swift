//
//  PlayerPosition+CoreDataClass.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/4/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData


public class PlayerPosition: NSManagedObject {

    
    
    
}

enum PlayerPositionEnum : String{
    
    case PointGuard = "Point Guard"
    case ShootingGuard = "Shooting Guard"
    case SmallForward = "Small Forward"
    case PowerForward = "Power Forward"
    case Center = "Center"
    
    func getPositionImageName() -> String{
        return self.rawValue.replacingOccurrences(of: " ", with: "")
    }
    
}
