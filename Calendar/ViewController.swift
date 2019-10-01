//
//  ViewController.swift
//  Calendar
//
//  Created by Thaliees on 9/30/19.
//  Copyright © 2019 Thaliees. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? CalendarCell else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
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
    
    func handleCellSelected(cell: CalendarCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.layer.cornerRadius =  20
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
    }
}
