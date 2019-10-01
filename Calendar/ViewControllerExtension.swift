//
//  ViewControllerExtension.swift
//  Calendar
//
//  Created by Thaliees on 9/30/19.
//  Copyright © 2019 Thaliees. All rights reserved.
//

import UIKit
import JTAppleCalendar

extension ViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        // Get current date
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.year], from: currentDate)
        
        var cStartDate = DateComponents()
        cStartDate.year = components.year!
        cStartDate.month = 1
        cStartDate.day = 1
        
        var cEndDate = DateComponents()
        cEndDate.year = components.year!
        cEndDate.month = 12
        cEndDate.day = 1
        
        // Indicate the initial date
        let startDate = Date() //calendar.date(from: cStartDate)!
        // Indicate the end date
        let endDate = calendar.date(from: cEndDate)!
        
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}


extension ViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! CalendarCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? CalendarCell else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: CalendarCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        }
        else {
            cell.dateLabel.textColor = UIColor.gray
        }
        // Or you can also make them hidden.
        /*if cellState.dateBelongsTo == .thisMonth {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }*/
    }
}
