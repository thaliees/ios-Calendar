//
//  ViewControllerExtension.swift
//  Calendar
//
//  Created by Thaliees on 9/30/19.
//  Copyright © 2019 Thaliees. All rights reserved.
//

import UIKit
import JTAppleCalendar

var startDate:Date = Date()
var finalDate:Date = Date()
var numberOfRows:Int = 6

extension ViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        // Get current calendar
        let calendar = Calendar.current
        
        if numberOfRows == 6 {
            return ConfigurationParameters(startDate: startDate, endDate: finalDate, numberOfRows: numberOfRows, calendar: calendar, generateInDates: .forAllMonths, generateOutDates: .tillEndOfRow, firstDayOfWeek: .sunday, hasStrictBoundaries: false)
        }
        
        return ConfigurationParameters(startDate: startDate, endDate: finalDate, numberOfRows: numberOfRows, calendar: calendar, generateInDates: .forAllMonths, generateOutDates: .off, firstDayOfWeek: .sunday, hasStrictBoundaries: false)
    }
}

extension ViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! CalendarCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
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
        if numberOfRows == 6 { handleGuideMonth(numberMonth: calendar.currentSection()!) }
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = CustomerDateFormat.FORMATTER_NAME_MONTH
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "dateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        
        return header
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 55)
    }
    
    // MARK: - Configurations
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? CalendarCell else { return }
        cell.dateLabel.text = cellState.text
        
        handleViews(cell: cell, cellState: cellState)
        handleTextColor(cell: cell, cellState: cellState)
        handleSelected(cell: cell, cellState: cellState)
    }
    
    func configureCellSelected(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? CalendarCell else { return }
        
        handleTextColor(cell: cell, cellState: cellState)
        handleSelected(cell: cell, cellState: cellState)
    }
    
    func handleViews(cell: CalendarCell, cellState: CellState) {
        cell.dotView1.layer.cornerRadius = cell.dotView1.frame.width / 2
        cell.dotView2.layer.cornerRadius = cell.dotView2.frame.width / 2
        cell.dotView3.layer.cornerRadius = cell.dotView3.frame.width / 2
        cell.selectedView.layer.cornerRadius = cell.selectedView.frame.width / 2
        cell.currentDate.layer.cornerRadius = cell.currentDate.frame.width / 2
    }
    
    func handleTextColor(cell: CalendarCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth { cell.dateLabel.textColor = UIColor.black }
        else { cell.dateLabel.textColor = UIColor.gray }
        
        // Or you can also make them hidden.
        /*if cellState.dateBelongsTo == .thisMonth {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }*/
    }
    
    func handleSelected(cell: CalendarCell, cellState: CellState) {
        let result = Calendar.current.compare(Date(), to: cellState.date, toGranularity: .day)
        if result == .orderedSame {
            cell.currentDate.isHidden = false
            cell.currentDate.layer.borderColor = UIColor.gray.cgColor
            cell.currentDate.layer.borderWidth = 3
        }
        else { cell.currentDate.isHidden = true }
        
        if cellState.isSelected {
            cell.dateLabel.textColor = UIColor.white
            cell.selectedView.isHidden = false
            cell.dotView1.isHidden = true
            cell.dotView2.isHidden = true
            cell.dotView3.isHidden = true
            handleSelectedDate(date: cellState.date)
        } else {
            cell.selectedView.isHidden = true
            handleDots(cell: cell, cellState: cellState)
        }
    }
}
