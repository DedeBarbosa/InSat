//
//  CoreDataManger.swift
//  InSat
//
//  Created by Dmitry Pavlov on 19.01.2020.
//  Copyright © 2020 Dmitry Pavlov. All rights reserved.
//

import CoreData
import Foundation

enum EntityEnum: String{
    case Courier
    case Destination
    case Trip
    case Day
}
class CoreDataManager {
    
    // Singleton
    static let shared = CoreDataManager()
    
    private init() {}
    
    func getEntityDescription(by entityEnum: EntityEnum) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityEnum.rawValue, in: self.persistentContainer.viewContext)!
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "InSat")
        container.loadPersistentStores(completionHandler: { (storeDescription,error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror),\(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - My Core Data Code
    let courierDefaultNames = ["Mitya",
                               "Anton",
                               "Evgen",
                               "Radmir",
                               "Vova",
                               "Igor",
                               "Polina",
                               "Mary",
                               "Stas",
                               "Kamil"]
    
    let destinationDefaultSettings = [(c: "SPB", d: 1),
                                      (c: "Ufa", d: 2),
                                      (c: "NiNo", d: 3),
                                      (c: "Vladimir", d: 4),
                                      (c: "Kostroma", d: 5),
                                      (c: "EKB", d: 1),
                                      (c: "Kovrov", d: 2),
                                      (c: "Voronezh", d: 3),
                                      (c: "Samara", d: 4),
                                      (c: "Astrahan'", d: 5)]
    
    lazy var dbManager = CoreDataManager.shared
    lazy var dbContext = dbManager.persistentContainer.viewContext
    var destinations = [Destination]()
    var couriers = [Courier]()
    let calendar = Calendar.current
    
    
    func firstInit(with delete: Bool = false) {
        do{
            if let result = try dbContext.fetch(Courier.fetchRequest()) as? [Courier]{
                if delete{
                    for r in result{
                        dbContext.delete(r)
                        dbManager.saveContext()
                    }
                    for c in courierDefaultNames{
                        let courierObject = Courier()
                        courierObject.name = c
                        dbManager.saveContext()
                        couriers.append(courierObject)
                    }
                }
                else{
                    couriers = result
                }
            }
            for c in couriers{
                print(c.name)
            }
            
            if let result = try dbContext.fetch(Destination.fetchRequest()) as? [Destination]{
                if delete{
                    for r in result{
                        dbContext.delete(r)
                        dbManager.saveContext()
                    }
                    for c in destinationDefaultSettings{
                        let destinationObject = Destination()
                        destinationObject.destination = c.c
                        destinationObject.daysInTrip = Int16(c.d)
                        dbManager.saveContext()
                        destinations.append(destinationObject)
                    }
                }
                else{
                    destinations = result
                }
            }
            for d in destinations{
                print("\(d.destination) for \(d.daysInTrip) days")
            }
        }
        catch{
            
        }
    }
    
    func randomlyFillTripsData(){
        firstInit()
        var oneDayComponent = DateComponents()
        oneDayComponent.day = 1
        
        guard let startDay = calendar.date(from: DateComponents(year: 2019, month: 9, day: 1))  else {return}
        
        do{
            if let trips = try dbContext.fetch(Trip.fetchRequest()) as? [NSManagedObject]{
                for t in trips{
                    dbContext.delete(t)
                }
                dbManager.saveContext()
            }
            
            if let days = try dbContext.fetch(Day.fetchRequest()) as? [NSManagedObject]{
                for d in days{
                    dbContext.delete(d)
                }
                dbManager.saveContext()
            }
        }
        catch{}
        dbManager.saveContext()
        var dayDate = startDay
        let dayObject = Day()
        dayObject.date = startDay
        while dayDate < Date(){
            dayDate = calendar.date(byAdding: oneDayComponent, to: dayDate) ?? Date()
            
            if let day = getDay(by: dayDate){
                let freeCouriers : [Courier] = getFreeCouriers(by: day)
                sendCouriers(couriers: freeCouriers, startDay: day)
            }
            else{
                let day = Day()
                day.date = dayDate
                dbManager.saveContext()
                sendCouriers(couriers: couriers, startDay: day)
            }
        }
        
    }
    
    func getDay(by date: Date) -> Day?{
        do{
            let dayObj = try dbContext.fetch(Day.fetchRequest(with: date))
            if dayObj.count > 0 {
                return dayObj[0]
            }
            else{
                return nil
            }
        }
        catch{
            return nil
        }
    }
    
    func getBusyCouriers(by day: Day) -> [Courier]{
        var busyCouriers = [Courier]()
        if let trips = day.trips?.allObjects as? [Trip]{
            for t in trips{
                busyCouriers.append(t.courier)
            }
        }
        return busyCouriers
    }
    
    func getFreeCouriers(by day: Day) -> [Courier]{
        var freeCouriers = [Courier]()
        let busyCouriers = getBusyCouriers(by: day)
        freeCouriers = couriers.filter({c in !busyCouriers.contains(c)})
        return freeCouriers
    }
    
    func sendCouriers(couriers: [Courier], startDay: Day){
        if couriers.count == 0 { return }
        for c in couriers{
            let day = startDay
            let trip = Trip()
            trip.courier = c
            trip.startDate = startDay.date
            let destination = destinations[Int.random(in: 0...9)]
            trip.destination = destination
            day.addToTrips(trip)
            print("\(day.date) \(c.name) goes to \(destination.destination) till \(destination.daysInTrip) days")
            dbManager.saveContext()
            for i in 1 ..< destination.daysInTrip{
                var dayComponent = DateComponents()
                dayComponent.day = Int(i)
                guard let newDate = calendar.date(byAdding: dayComponent, to: startDay.date) else {return}
                do{
                    let result = try dbContext.fetch(Day.fetchRequest(with: newDate))
                    if result.count > 0{
                        result[0].addToTrips(trip)
                    }
                    else{
                        let nextDay = Day()
                        nextDay.date = newDate
                        nextDay.addToTrips(trip)
                    }
                    dbManager.saveContext()
                }
                catch{}
            }
        }
    }
    
    func readDays(){
        
        do{
            if let result = try dbContext.fetch(Day.fetchRequest()) as? [Day]{
                for r in result{
                    print(r.date)
                    if let tripsObj = r.trips{
                        if let trips = tripsObj.allObjects as? [Trip]{
                            for t in trips{
                                let courier = t.courier
                                let destination = t.destination
                                print("\(courier.name) goes to \(destination.destination)")
                            }
                        }
                        
                    }
                    
                }
            }
        }
        catch{}
    }
    
    func readCouriers() -> [Courier]{
        var couriers = [Courier]()
        do{
            if let result = try dbContext.fetch(Courier.fetchRequest()) as? [Courier]{
                for r in result{
                    couriers.append(r)
                }
            }
        }
        catch{}
        return couriers
    }
    
    func readDestinations() -> [Destination]{
        var destination = [Destination]()
        do{
            if let result = try dbContext.fetch(Destination.fetchRequest()) as? [Destination]{
                for r in result{
                    destination.append(r)
                }
            }
        }
        catch{}
        return destination
    }
    
    
    func getTrips(date: Date) -> [Trip]{
        var trips = [Trip]()
        do{
            let result = try dbContext.fetch(Day.fetchRequest(with: date))
            if result.count > 0, let tResult = result[0].trips?.allObjects as? [Trip]{
                trips = tResult
            }
        }
        catch{}
        return trips
    }
    
}


