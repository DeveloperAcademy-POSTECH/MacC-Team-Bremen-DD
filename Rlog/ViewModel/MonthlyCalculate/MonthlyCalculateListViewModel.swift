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
}
