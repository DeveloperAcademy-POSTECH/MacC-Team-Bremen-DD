//
//  TimeManager.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/16.
//

import Foundation

final class TimeManager: ObservableObject {
    let calendar = Calendar.current
    
    func increaseOneWeek(_ date: Date) -> Date {
        guard let date = calendar.date(byAdding: .weekOfMonth, value: 1, to: date)
        else { return Date() }
        
        return date
    }
    
    func decreaseOneWeek(_ date: Date) -> Date {
        guard let date = calendar.date(byAdding: .weekOfMonth, value: -1, to: date)
        else { return Date() }
        
        return date
    }
    
    func increaseOneMonth(_ date: Date) -> Date {
        guard let date = calendar.date(byAdding: .month, value: 1, to: date)
        else { return Date()}
        
        return date
    }
    
    func decreaseOneMonth(_ date: Date) -> Date {
        guard let date = calendar.date(byAdding: .month, value: -1, to: date)
        else { return Date() }
        
        return date
    }
}
