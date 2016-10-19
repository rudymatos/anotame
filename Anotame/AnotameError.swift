//
//  AnotameError.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/4/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation

enum AnotameError : Error{
    
    case CoreDataError(message : String)
    case LeagueAlreadyExist
    case ActiveBoardFound
    case ErrorCreatingDefaultBoard
    
}
