//
//  PlayerType+CoreDataProperties.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/4/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData 

extension PlayerType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerType> {
        return NSFetchRequest<PlayerType>(entityName: "PlayerType");
    }

    @NSManaged public var icon: String?
    @NSManaged public var name: String?
    @NSManaged public var players: NSSet?

}

// MARK: Generated accessors for players
extension PlayerType {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: Player)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: Player)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}
