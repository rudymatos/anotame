//
//  Events+CoreDataProperties.swift
//  Anotame
//
//  Created by Rudy E Matos on 10/4/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData

extension Events {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Events> {
        return NSFetchRequest<Events>(entityName: "Events");
    }

    @NSManaged public var creation_date: NSDate?
    @NSManaged public var player_status: String?
    @NSManaged public var board: Board?
    @NSManaged public var player: Player?
    @NSManaged public var team: Team?

}
