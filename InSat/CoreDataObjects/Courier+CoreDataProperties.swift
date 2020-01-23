//
//  Courier+CoreDataProperties.swift
//  
//
//  Created by Dmitry Pavlov on 22.01.2020.
//
//

import Foundation
import CoreData


extension Courier {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Courier> {
        return NSFetchRequest<Courier>(entityName: "Courier")
    }

    @NSManaged public var busyNow: Bool
    @NSManaged public var name: String
    @NSManaged public var trip: NSSet?

}

// MARK: Generated accessors for trip
extension Courier {

    @objc(addTripObject:)
    @NSManaged public func addToTrip(_ value: Trip)

    @objc(removeTripObject:)
    @NSManaged public func removeFromTrip(_ value: Trip)

    @objc(addTrip:)
    @NSManaged public func addToTrip(_ values: NSSet)

    @objc(removeTrip:)
    @NSManaged public func removeFromTrip(_ values: NSSet)

}
