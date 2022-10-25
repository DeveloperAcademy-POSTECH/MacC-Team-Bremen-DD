//
//  Date+.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/18.
//

import Foundation

extension Date {
    func fetchYearAndMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        return dateFormatter.string(from: self)
    }
}
