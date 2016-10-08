//
//  League+CoreDataProperties.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/4/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData 

extension League {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<League> {
        return NSFetchRequest<League>(entityName: "League");
    }

    @NSManaged public var active: Bool
    @NSManaged public var address: String?
    @NSManaged public var creation_date: NSDate?
    @NSManaged public var icon: String?
    @NSManaged public var name: String?
    @NSManaged public var boards: NSSet?
    @NSManaged public var players: NSSet?

}

// MARK: Generated accessors for boards
extension League {

    @objc(addBoardsObject:)
    @NSManaged public func addToBoards(_ value: Board)

    @objc(removeBoardsObject:)
    @NSManaged public func removeFromBoards(_ value: Board)

    @objc(addBoards:)
    @NSManaged public func addToBoards(_ values: NSSet)

    @objc(removeBoards:)
    @NSManaged public func removeFromBoards(_ values: NSSet)

}

// MARK: Generated accessors for players
extension League {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: Player)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: Player)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}
