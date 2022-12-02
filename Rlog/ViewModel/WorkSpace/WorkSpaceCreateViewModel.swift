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
    var textLimited = ""
    
    @Published var workspace = ""
    @Published var hourlyWage = ""
    @Published var payday = ""
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

extension WorkspaceCreateViewModel {
    func checkErrorOfInputText(type: WritingState, _ text: String) {
        switch type {
        case .workspace:
            if text.isEmpty { inActivateButton() }
            else { activateButton() }
            if text.count == 20 { textLimited = text }
            if text.count >= 20 {
                workspace = textLimited
                inActivateButton()
            }
        case .hourlyWage:
            if text.isEmpty { inActivateButton() }
            guard let textToInt = Int(text) else { return self.hourlyWage = "" }
            
            if textToInt > 1000000 && text.count < 8 { textLimited = text }
            if textToInt  >= 1000000 {
                hourlyWage = textLimited
                inActivateButton()
            } else {
                activateButton()
            }
        case .payday:
            if text.isEmpty { inActivateButton() }
            guard let textToInt = Int(text) else { return self.payday = "" }
            
            if textToInt > 28 && text.count <= 3 { textLimited = text }
            if textToInt > 28 {
                payday = textLimited
                inActivateButton()
            } else {
                activateButton()
            }
        case .toggleOptions:
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
