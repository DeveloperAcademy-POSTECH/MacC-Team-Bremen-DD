//
//  DateFormatter+.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/18.
//

import Foundation

extension DateFormatter {
    func fetchTimeStringToDate(time: String) -> Date {
        self.dateFormat = "hh:mm"
        guard let date = self.date(from: time) else { return Date() }
        return date
    }
    
    func fetchTimeDateToString(time: Date) -> String {
        self.dateFormat = "hh:mm"
        return self.string(from: time)
    }
}
