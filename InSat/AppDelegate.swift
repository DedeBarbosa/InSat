//
//  AppDelegate.swift
//  InSat
//
//  Created by Dmitry Pavlov on 18.01.2020.
//  Copyright © 2020 Dmitry Pavlov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
   
    func applicationDidFinishLaunching(_ application: UIApplication) {
        CoreDataManager.shared.firstInit()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }
    
    //MARK: - Oreintation Lock
    
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
}

