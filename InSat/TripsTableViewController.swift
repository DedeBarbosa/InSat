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
    
    func updateTable(with trips: [Trip]){
        self.trips = trips
        tableView.reloadData()
    }
    func updateTitle(with date: Date){
        let navigationVC = self.navigationController as? UINavigationController
        navigationVC?.viewControllers[0].title = MyDateFormatter.shared.formatDateAsNumbers(date: date)
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
