//
//  Player+CoreDataProperties.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/4/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData 

extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player");
    }

    @NSManaged public var name: String?
    @NSManaged public var nick: String?
    @NSManaged public var number: Int16
    @NSManaged public var photo: NSData?
    @NSManaged public var arriving_order_list: NSSet?
    @NSManaged public var events: NSSet?
    @NSManaged public var league: League?
    @NSManaged public var player_type: PlayerType?
    @NSManaged public var positions: NSSet?

}

// MARK: Generated accessors for arriving_order_list
extension Player {

    @objc(addArriving_order_listObject:)
    @NSManaged public func addToArriving_order_list(_ value: Board)

    @objc(removeArriving_order_listObject:)
    @NSManaged public func removeFromArriving_order_list(_ value: Board)

    @objc(addArriving_order_list:)
    @NSManaged public func addToArriving_order_list(_ values: NSSet)

    @objc(removeArriving_order_list:)
    @NSManaged public func removeFromArriving_order_list(_ values: NSSet)

}

// MARK: Generated accessors for events
extension Player {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Events)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Events)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

// MARK: Generated accessors for positions
extension Player {

    @objc(addPositionsObject:)
    @NSManaged public func addToPositions(_ value: PlayerPosition)

    @objc(removePositionsObject:)
    @NSManaged public func removeFromPositions(_ value: PlayerPosition)

    @objc(addPositions:)
    @NSManaged public func addToPositions(_ values: NSSet)

    @objc(removePositions:)
    @NSManaged public func removeFromPositions(_ values: NSSet)

}
