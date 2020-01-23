//
//  Day+CoreDataClass.swift
//  InSat
//
//  Created by Dmitry Pavlov on 19.01.2020.
//  Copyright © 2020 Dmitry Pavlov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Day)
public class Day: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.shared.getEntityDescription(by: .Day), insertInto: CoreDataManager.shared.persistentContainer.viewContext)
    }
    
}

extension Day {
    @nonobjc public class func fetchRequest(with date: Date) -> NSFetchRequest<Day> {
        let date = Calendar.current.startOfDay(for: date)
        let nextDate = Calendar.current.date(byAdding: DateComponents(day:1), to: date)!
        let nsDate = NSDate(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
        let nsNextDate = NSDate(timeIntervalSinceReferenceDate: nextDate.timeIntervalSinceReferenceDate)
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", nsDate, nsNextDate)
        let fetchRequest: NSFetchRequest<Day> = self.fetchRequest()
        fetchRequest.predicate = predicate
        return fetchRequest
    }
}
