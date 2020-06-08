//
//  DataCell.swift
//  Calendar
//
//  Created by Thaliees on 9/30/19.
//  Copyright © 2019 Thaliees. All rights reserved.
//

import JTAppleCalendar
import UIKit

class CalendarCell: JTACDayCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var currentDate: UIView!
    @IBOutlet var selectedView: UIView!
    @IBOutlet var dotView1: UIView!
    @IBOutlet var dotView2: UIView!
    @IBOutlet var dotView3: UIView!
}
