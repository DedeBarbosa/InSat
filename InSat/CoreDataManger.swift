//
//  CoreDataManger.swift
//  InSat
//
//  Created by Dmitry Pavlov on 19.01.2020.
//  Copyright © 2020 Dmitry Pavlov. All rights reserved.
//

import CoreData
import Foundation


class CoreDataManager {
    
    //MARK: - Constants
    enum EntityEnum: String{
        case Courier
        case Destination
        case Trip
        case Day
    }
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
    
    let destinationDefaultSettings = [(destination: "SPB", days: 1),
                                      (destination: "Ufa", days: 2),
                                      (destination: "NiNo", days: 3),
                                      (destination: "Vladimir", days: 4),
                                      (destination: "Kostroma", days: 5),
                                      (destination: "EKB", days: 1),
                                      (destination: "Kovrov", days: 2),
                                      (destination: "Voronezh", days: 3),
                                      (destination: "Samara", days: 4),
                                      (destination: "Astrahan'", days: 5)]
    
    
    // Singleton
    static let shared = CoreDataManager()
    
    private init() {
    }
    
    func getEntityDescription(by entityEnum: EntityEnum) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityEnum.rawValue, in: self.persistentContainer.viewContext)!
    }
    // MARK: - My Core Data Code
    
    lazy var dbManager = self
    lazy var dbContext = dbManager.persistentContainer.viewContext
    var destinations = [Destination]()
    var couriers = [Courier]()
    let calendar = Calendar.current
    
    
    func firstInit() {
        do{
            if let result = try dbContext.fetch(Courier.fetchRequest()) as? [Courier]{
                couriers = result
                for cName in courierDefaultNames{
                    if !couriers.contains{c in c.name == cName}{
                        let courierObject = Courier()
                        courierObject.name = cName
                        dbManager.saveContext()
                        couriers.append(courierObject)
                    }
                }
            }
            if let result = try dbContext.fetch(Destination.fetchRequest()) as? [Destination]{
                destinations = result
                for dSettings in destinationDefaultSettings{
                    if !destinations.contains{d in d.destination == dSettings.destination}{
                        let destinationObject = Destination()
                        destinationObject.destination = dSettings.destination
                        destinationObject.daysInTrip = Int16(dSettings.days)
                        dbManager.saveContext()
                        destinations.append(destinationObject)
                    }
                }
            }
        }
        catch{}
    }
    
    func randomlyFillTripsData(){
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
                let freeCouriers : [Courier] = getFreeCouriers(by: dayDate)
                sendCouriers(couriers: freeCouriers, startDay: day)
            }
            else{
                let day = createDay(by: dayDate)
                sendCouriers(couriers: couriers, startDay: day)
            }
        }
        
    }
    
    func createDay(by date: Date) -> Day{
        let day = Day()
        day.date = date
        dbManager.saveContext()
        return day
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
    
    private func getBusyCouriers(by day: Day) -> [Courier]{
        var busyCouriers = [Courier]()
        if let trips = day.trips?.allObjects as? [Trip]{
            for t in trips{
                busyCouriers.append(t.courier)
            }
        }
        return busyCouriers
    }
    
    func getFreeCouriers(by date: Date) -> [Courier]{
        var freeCouriers = couriers
        if let day = getDay(by: date){
            let busyCouriers = getBusyCouriers(by: day)
            freeCouriers = couriers.filter({c in !busyCouriers.contains(c)})
        }
        return freeCouriers
    }
    
    private func sendCouriers(couriers: [Courier], startDay: Day){
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
    
    func sendCourier(by name: String, startDate: Date, to destination: String){
        if let courier = couriers.last(where: {c in c.name == name}), let destination = destinations.last(where: {d in d.destination == destination}){
            let day: Day
            if let existDay = getDay(by: startDate){
                day = existDay
            }
            else{
                day = createDay(by: startDate)
            }
            let trip = Trip()
            trip.courier = courier
            trip.startDate = startDate
            trip.destination = destination
            day.addToTrips(trip)
            dbManager.saveContext()
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
    
}


