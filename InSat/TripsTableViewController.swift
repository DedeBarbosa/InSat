//
//  TripsTableViewController.swift
//  InSat
//
//  Created by Dmitry Pavlov on 22.01.2020.
//  Copyright © 2020 Dmitry Pavlov. All rights reserved.
//

import UIKit

class TripsTableViewController: UITableViewController {

    private var trips = [Trip]()
    
    @IBAction func FillDb(_ sender: Any) {
        CoreDataManager.shared.randomlyFillTripsData()
        CoreDataManager.shared.readDays()
        performSegue(withIdentifier: "goToCalendar", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCalendar"{
            if let vc = segue.destination as? CalendarViewController{
                vc.currentDate = getDateFromTitle()
            }
        }
    }
    
    func getDateFromTitle() -> Date?{
        let date = MyDateFormatter.shared.formatStringToDate(string: self.navigationController?.viewControllers[0].title)
        return date
    }
    
    func selfUpdateTrips(){
        if let date = getDateFromTitle(){
            let trips = CoreDataManager.shared.getTrips(date: date)
            updateTable(with: trips)
        }
    }
    
    func updateTable(with trips: [Trip]){
        self.trips = trips
        tableView.reloadData()
    }
    func updateTitle(with date: Date){
        let navigationVC = self.navigationController
        navigationVC?.viewControllers[0].title = MyDateFormatter.shared.formatDateToString(date: date)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trips.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        let trip = trips[indexPath.row]
        cell.textLabel?.text = "\(trip.courier.name) now in travel work to \(trip.destination.destination)"
        return cell
    }
}
