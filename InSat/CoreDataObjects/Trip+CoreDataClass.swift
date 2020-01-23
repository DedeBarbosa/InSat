//
//  Trip+CoreDataClass.swift
//  InSat
//
//  Created by Dmitry Pavlov on 19.01.2020.
//  Copyright © 2020 Dmitry Pavlov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Trip)
public class Trip: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.shared.getEntityDescription(by: .Trip), insertInto: CoreDataManager.shared.persistentContainer.viewContext)
    }
}
