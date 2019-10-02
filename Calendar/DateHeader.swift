//
//  DateHeader.swift
//  Calendar
//
//  Created by Thaliees on 10/1/19.
//  Copyright © 2019 Thaliees. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateHeader: JTACMonthReusableView  {
    @IBOutlet var monthTitle: UILabel!
    @IBOutlet var sunday: NSLayoutConstraint!
    @IBOutlet var monday: NSLayoutConstraint!
    @IBOutlet var tuesday: NSLayoutConstraint!
    @IBOutlet var wednesday: NSLayoutConstraint!
    @IBOutlet var thursday: NSLayoutConstraint!
    @IBOutlet var friday: NSLayoutConstraint!
    @IBOutlet var saturday: NSLayoutConstraint!
}
