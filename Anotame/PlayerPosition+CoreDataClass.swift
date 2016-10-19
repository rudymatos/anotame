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
    
    static func getPlayerPositionsString(positions : [PlayerPosition]) -> String{
        if positions.count == 1{
            if let shortPositionName = PlayerPositionEnum(rawValue: positions[0].name!)?.getShortPositionName(){
                return shortPositionName
            }
        }else{
            var positionString = ""
            for index in 0..<positions.count{
                if let shortPositionName = PlayerPositionEnum(rawValue: positions[index].name!)?.getShortPositionName(){
                    positionString.append(shortPositionName)
                    if index < positions.count - 1{
                        positionString.append(",")
                    }
                }
            }
            return positionString
        }
        return "Posicion no disponible"
    }
    
    func getShortPositionName() -> String{
        switch self{
        case .Center:
            return "C"
        case .PointGuard:
            return "PG"
        case .PowerForward:
            return "PF"
        case .ShootingGuard:
            return "SG"
        case .SmallForward:
            return "SF"
            
        }
    }
    
}
