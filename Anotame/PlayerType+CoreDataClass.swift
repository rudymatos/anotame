//
//  PlayerType+CoreDataClass.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/4/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData


public class PlayerType: NSManagedObject {
    
    
    
}


enum PlayerTypeEnum: String{
    case Guest = "Guest"
    case Member = "Member"
    
    func getSpanishValue() -> String{
        switch  self {
        case .Guest:
            return "Invitado"
        default:
            return "Miembro"
        }
    }
}
