//
//  WorkSpaceCreateViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Combine
import SwiftUI

@MainActor
final class WorkspaceCreateViewModel: ObservableObject {
    @Binding var isActiveNavigation: Bool
    init(isActiveNavigation: Binding<Bool>) {
        self._isActiveNavigation = isActiveNavigation
    }
    
    var currentState: WritingState = .workspace
    var isActivatedConfirmButton: Bool = false
    
    @Published var isHiddenToggleInputs: Bool = true
    @Published var isHiddenPayday: Bool = true
    @Published var isHiddenHourlyWage: Bool = true
    var isHiddenConfirmButton: Bool = false
    var isHiddenToolBarItem: Bool = true
    
    @Published var workspace = "" {
        didSet {
            if workspace.isEmpty  {
                inActivateButton()
            } else {
                if workspace.count >= 21 { workspace = oldValue }
                if workspace.count >= 20 {
                    inActivateButton()
                } else {
                    activateButton()
                }
            }
        }
    }
    @Published var hourlyWage = "" {
        didSet {
            if hourlyWage.isEmpty {
                inActivateButton()
            } else {
                guard let textToInt = Int(hourlyWage) else { return hourlyWage = "" }
                if textToInt  >= 10000000 { hourlyWage = oldValue }
                if textToInt >= 1000000 {
                    inActivateButton()
                } else {
                    activateButton()
                }
            }
        }
    }
    @Published var payday = "" {
        didSet {
            if payday.isEmpty {
                inActivateButton()
            } else {
                guard let textToInt = Int(payday) else { return payday = "" }
                if textToInt > 289 {payday = oldValue}
                if textToInt > 28 {
                    inActivateButton()
                } else {
                    activateButton()
                }
            }
        }
    }
    @Published var hasTax: Bool = false
    @Published var hasJuhyu: Bool = false
    
    func didTapConfirmButton() {
        if isActivatedConfirmButton {
            switchToNextStatus()
        }
    }
}

private extension WorkspaceCreateViewModel {
    
    func switchToNextStatus() {
        withAnimation(.easeIn) {
            switch currentState {
            case .workspace:
                isHiddenHourlyWage = false
                currentState = .hourlyWage
            case .hourlyWage:
                isHiddenPayday = false
                currentState = .payday
            case .payday:
                isHiddenToggleInputs = false
                isHiddenConfirmButton = true
                isHiddenToolBarItem = false
                currentState = .toggleOptions
            case .toggleOptions:
                return
            }
            isActivatedConfirmButton = false
        }
    }
    
    func inActivateButton() {
        isActivatedConfirmButton = false
        if currentState == .toggleOptions {
            isHiddenToolBarItem = true
        }
    }
    
    func activateButton()  {
        switch currentState {
        case .workspace:
            isActivatedConfirmButton = true
            return
        case .hourlyWage:
            if workspace.isEmpty {return}
            if hourlyWage.isEmpty {return}
            guard let hourlyWageInt = Int(hourlyWage) else { return }
            if hourlyWageInt >= 1000000 {return}
            isActivatedConfirmButton = true
            return
        case .payday:
            if workspace.isEmpty {return}
            if hourlyWage.isEmpty {return}
            guard let hourlyWageInt = Int(hourlyWage) else { return }
            if hourlyWageInt >= 1000000 {return}
            if payday.isEmpty {return}
            guard let paydayInt = Int(payday) else { return }
            if paydayInt > 28 {return}
            isActivatedConfirmButton = true
            return
        case .toggleOptions:
            if workspace.isEmpty {return}
            if hourlyWage.isEmpty {return}
            guard let hourlyWageInt = Int(hourlyWage) else { return }
            if hourlyWageInt >= 1000000 {return}
            if payday.isEmpty {return}
            guard let paydayInt = Int(payday) else { return  }
            if paydayInt > 28 {return}
            isHiddenToolBarItem = false
            return
        }
    }
}

enum WritingState: Hashable {
    case workspace
    case hourlyWage
    case payday
    case toggleOptions
    
    var title: String {
        switch self {
        case .workspace:
            return "근무지를 입력해주세요."
        case .hourlyWage:
            return "시급을 입력해주세요."
        case .payday:
            return "급여일을 알려주세요."
        case .toggleOptions:
            return "소득세, 주휴수당 정보를 입력해주세요."
        }
    }
}
