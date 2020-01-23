//
//  CalendarViewController.swift
//  InSat
//
//  Created by Dmitry Pavlov on 21.01.2020.
//  Copyright © 2020 Dmitry Pavlov. All rights reserved.
//

import UIKit
import KDCalendar
class CalendarViewController: UIViewController {

    
    @IBOutlet weak var calendar: CalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.multipleSelectionEnable = false
    }
}
extension CalendarViewController: CalendarViewDelegate{
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        guard let masterNavigationVC = self.splitViewController?.viewControllers.first as? UINavigationController else {return}
        guard let tableVC = masterNavigationVC.viewControllers.first as? TripsTableViewController else {return}
        let trips = CoreDataManager.shared.getTrips(date: date)
        tableVC.updateTable(with: trips)
        tableVC.updateTitle(with: date)
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        true
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
        
    }
    
    
}

extension CalendarViewController: CalendarViewDataSource{
    func startDate() -> Date {
        Calendar.current.startOfDay(for: Calendar.current.date(from: DateComponents(year: 2019, month: 9, day: 1)) ?? Date())
    }
    
    func endDate() -> Date {
        Calendar.current.date(byAdding: DateComponents(month: 1), to: Date()) ?? Date()
    }
    
    func headerString(_ date: Date) -> String? {
        MyDateFormatter.shared.formatDateAsMonthYear(date: date)
    }
    
    
}
