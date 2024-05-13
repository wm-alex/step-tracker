//
//  Date+Extension.swift
//  Step tracker
//
//  Created by Alexander Gunnarsson on 2024-05-13.
//

import Foundation

extension Date {
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
}
