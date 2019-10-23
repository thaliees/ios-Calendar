//
//  CustomerDateFormat.swift
//  Calendar
//
//  Created by Thaliees on 10/22/19.
//  Copyright © 2019 Thaliees. All rights reserved.
//

import UIKit

class CustomerDateFormat {
    static let FORMATTER_DATE = "yyyy-MM-dd"
    static let FORMATTER_DATE_SHORT = "MMM-yyyy"
    static let FORMATTER_NAME_MONTH = "MMMM"
    
    static var FormatterServer: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "EDT")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        // It depends on the format in which you receive the date
        formatter.dateFormat = "dd-MMM-yyyy'T'HH:mm:ss.SSS'Z'"
        return formatter
    }
}
