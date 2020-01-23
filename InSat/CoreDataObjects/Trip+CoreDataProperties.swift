//
//  Trip+CoreDataProperties.swift
//  
//
//  Created by Dmitry Pavlov on 22.01.2020.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var startDate: Date
    @NSManaged public var courier: Courier
    @NSManaged public var day: NSSet
    @NSManaged public var destination: Destination

}

// MARK: Generated accessors for day
extension Trip {

    @objc(addDayObject:)
    @NSManaged public func addToDay(_ value: Day)

    @objc(removeDayObject:)
    @NSManaged public func removeFromDay(_ value: Day)

    @objc(addDay:)
    @NSManaged public func addToDay(_ values: NSSet)

    @objc(removeDay:)
    @NSManaged public func removeFromDay(_ values: NSSet)

}
