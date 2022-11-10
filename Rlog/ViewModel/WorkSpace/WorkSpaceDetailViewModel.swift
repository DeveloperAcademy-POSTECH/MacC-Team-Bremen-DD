//
//  WorkSpaceDetailViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Combine
import Foundation

@MainActor
final class WorkSpaceDetailViewModel: ObservableObject {
    @Published var name = ""
    @Published var hourlyWageString = ""
    @Published var paymentDayString = ""
    @Published var hasTax = true
    @Published var hasJuhyu = true
    @Published var isAlertOpen = false
}

