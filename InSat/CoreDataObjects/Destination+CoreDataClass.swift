//
//  Destination+CoreDataClass.swift
//  InSat
//
//  Created by Dmitry Pavlov on 19.01.2020.
//  Copyright © 2020 Dmitry Pavlov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Destination)
public class Destination: NSManagedObject {

    convenience init() {
        self.init(entity: CoreDataManager.shared.getEntityDescription(by: .Destination), insertInto: CoreDataManager.shared.persistentContainer.viewContext)
    }
}
