//
//  Destination+CoreDataProperties.swift
//  
//
//  Created by Dmitry Pavlov on 22.01.2020.
//
//

import Foundation
import CoreData


extension Destination {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Destination> {
        return NSFetchRequest<Destination>(entityName: "Destination")
    }

    @NSManaged public var daysInTrip: Int16
    @NSManaged public var destination: String
    @NSManaged public var trip: NSSet?

}

// MARK: Generated accessors for trip
extension Destination {

    @objc(addTripObject:)
    @NSManaged public func addToTrip(_ value: Trip)

    @objc(removeTripObject:)
    @NSManaged public func removeFromTrip(_ value: Trip)

    @objc(addTrip:)
    @NSManaged public func addToTrip(_ values: NSSet)

    @objc(removeTrip:)
    @NSManaged public func removeFromTrip(_ values: NSSet)

}
