//
//  Board+CoreDataProperties.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/5/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData

extension Board {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Board> {
        return NSFetchRequest<Board>(entityName: "Board");
    }

    @NSManaged public var creation_date: NSDate?
    @NSManaged public var active: Bool
    @NSManaged public var arriving_order_list: NSSet?
    @NSManaged public var events: NSSet?
    @NSManaged public var league: League?

}

// MARK: Generated accessors for arriving_order_list
extension Board {

    @objc(addArriving_order_listObject:)
    @NSManaged public func addToArriving_order_list(_ value: Player)

    @objc(removeArriving_order_listObject:)
    @NSManaged public func removeFromArriving_order_list(_ value: Player)

    @objc(addArriving_order_list:)
    @NSManaged public func addToArriving_order_list(_ values: NSSet)

    @objc(removeArriving_order_list:)
    @NSManaged public func removeFromArriving_order_list(_ values: NSSet)

}

// MARK: Generated accessors for events
extension Board {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Events)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Events)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
