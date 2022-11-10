//
//  WorkSpaceCreateViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Combine
import SwiftUI

@MainActor
final class WorkSpaceCreateViewModel: ObservableObject {
    @Published var hasTax: Bool = false
    @Published var hasJuhyu: Bool = false
    @Published var isHiddenGuidingTitle: Bool = false
    @Published var isHiddenToggleInputs: Bool = false
    @Published var isHiddenPayday: Bool = false
    @Published var isHiddenHourlyWage: Bool = false
    @Published var isHiddenConfirmButton: Bool = false
    @Published var isHiddenToolBarItem: Bool = false
    @Published var isActivatedConfirmButton: Bool = false


    @Published var paymentDay = ""
    @Published var hourlyWage = ""
    @Published var name = ""
}

