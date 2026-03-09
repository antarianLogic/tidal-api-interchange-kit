//
//  ISO8601Helpers.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/9/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

extension Date.ISO8601FormatStyle {

    static var dateOnlyStyle: Self {
        Date.ISO8601FormatStyle()
            .dateSeparator(.dash)
            .year()
            .month()
            .day()
    }

    static var dateTimeStyle: Self {
        Date.ISO8601FormatStyle()
            .dateSeparator(.dash)
            .year()
            .month()
            .day()
            .dateTimeSeparator(.standard)
            .timeSeparator(.colon)
            .time(includingFractionalSeconds: true)
            .timeZone(separator: .omitted)
    }
}
