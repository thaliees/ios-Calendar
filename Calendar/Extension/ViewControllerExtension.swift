//
//  ViewControllerExtension.swift
//  Calendar
//
//  Created by Thaliees on 9/30/19.
//  Copyright © 2019 Thaliees. All rights reserved.
//

import UIKit
import JTAppleCalendar

var initDate:Date = Date()
var finalDate:Date = Date()
var numberOfRows:Int = 6

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
        initDate = calendar.date(from: cStartDate)!
        // Indicate the end date
        finalDate = calendar.date(from: cEndDate)!
        
        if numberOfRows == 6 {
            return ConfigurationParameters(startDate: initDate, endDate: finalDate, numberOfRows: numberOfRows, calendar: calendar, generateInDates: .forAllMonths, generateOutDates: .tillEndOfRow, firstDayOfWeek: .sunday, hasStrictBoundaries: false)
        }
        
        return ConfigurationParameters(startDate: initDate, endDate: finalDate, numberOfRows: numberOfRows, calendar: calendar, generateInDates: .forAllMonths, generateOutDates: .off, firstDayOfWeek: .sunday, hasStrictBoundaries: false)
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
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCellSelected(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCellSelected(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return true // Based on a criteria, return true or false
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        handleGuideMonth(numberMonth: calendar.currentSection()!)
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = CustomerDateFormat.FORMATTER_NAME_MONTH
        
        // We obtain the calendar width (according to the device)
        // and divide it between 7 days of the week
        let width = calendar.frame.size.width
        let widthDay = width / 7
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "dateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        header.sunday.constant = widthDay
        header.monday.constant = widthDay
        header.tuesday.constant = widthDay
        header.wednesday.constant = widthDay
        header.thursday.constant = widthDay
        header.friday.constant = widthDay
        header.saturday.constant = widthDay
        
        return header
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 55)
    }
}
