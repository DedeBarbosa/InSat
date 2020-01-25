//
//  DateFormatter.swift
//  InSat
//
//  Created by Dmitry Pavlov on 21.01.2020.
//  Copyright © 2020 Dmitry Pavlov. All rights reserved.
//

import Foundation

class MyDateFormatter{
    static let shared = MyDateFormatter()
    private let dateFormatter = DateFormatter()
    private let monthYearFormatter = DateFormatter()
    private init(){
        dateFormatter.dateFormat = "dd.MM.yyyy"
        monthYearFormatter.dateFormat = "MMMM yyyy"
    }
    
    func formatDateToString(date: Date) -> String{
        dateFormatter.string(from: date)
    }
    
    func formatStringToDate(string: String?) -> Date?{
        if let string = string{
           return dateFormatter.date(from: string)
        }
        return nil
    }
    
    func formatDateToMonthYear(date: Date) -> String{
        monthYearFormatter.string(from: date)
    }
}
