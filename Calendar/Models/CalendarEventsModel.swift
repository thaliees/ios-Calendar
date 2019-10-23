//
//  CalendarEventsModel.swift
//  Calendar
//
//  Created by Thaliees on 10/23/19.
//  Copyright © 2019 Thaliees. All rights reserved.
//

import Foundation

class CalendarEventInfo: Codable {
    let date: String
    let events: [ScheduledEvents]

    init(date: String, events: [ScheduledEvents]) {
        self.date = date
        self.events = events
    }
}

class ScheduledEvents: Codable {
    let id, title, color: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, color
    }

    init(id: String, title: String, color: String) {
        self.id = id
        self.title = title
        self.color = color
    }
}
