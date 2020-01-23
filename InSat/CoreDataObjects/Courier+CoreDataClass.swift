//
//  Courier+CoreDataClass.swift
//  InSat
//
//  Created by Dmitry Pavlov on 19.01.2020.
//  Copyright © 2020 Dmitry Pavlov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Courier)
public class Courier: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.shared.getEntityDescription(by: .Courier), insertInto: CoreDataManager.shared.persistentContainer.viewContext)
    }
}
