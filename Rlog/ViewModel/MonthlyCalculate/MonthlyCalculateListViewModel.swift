//
//  MonthlyCalculateListViewModel.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/10.
//

import Foundation

@MainActor
final class MonthlyCalculateListViewModel: ObservableObject {
    @Published var date = Date()
    
    func fecthYear() -> String {
        return String(Calendar.current.component(.year, from: date))
    }
    
    func fetchMonth() -> String {
        return String(Calendar.current.component(.month, from: date))
    }
}
