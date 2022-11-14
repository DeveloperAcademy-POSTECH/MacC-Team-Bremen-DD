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
    @Binding var isActive: Bool
    init(isActive: Binding<Bool>) {
        self._isActive = isActive
    }
    
    var currentState: WritingState = .workSpace
    var isActivatedConfirmButton: Bool = false
    
    @Published var isHiddenToggleInputs: Bool = true
    @Published var isHiddenPayday: Bool = true
    @Published var isHiddenHourlyWage: Bool = true
    var isHiddenConfirmButton: Bool = false
    var isHiddenToolBarItem: Bool = true
    
    @Published var workSpace = "" {
        didSet {
            if !workSpace.isEmpty {
                // TODO: 이전값을 돌려주는게 적합한 UX일까? -> 나중에 고민해보기
                if workSpace.count >= 21 { workSpace = oldValue }
                if workSpace.count >= 20 {
                    inActivateButton()
                } else {
                    activateButton()
                }
            } else {
                inActivateButton()
            }
        }
    }
    @Published var hourlyWage = "" {
        didSet {
            if !hourlyWage.isEmpty {
                guard let textToInt = Int(hourlyWage) else { return hourlyWage = "" }
                if textToInt  >= 10000000 { hourlyWage = oldValue }
                if textToInt >= 1000000 {
                    inActivateButton()
                } else {
                    activateButton()
                }
            } else {
                inActivateButton()
            }
        }
    }
    @Published var payday = "" {
        didSet {
            if !payday.isEmpty {
                guard let textToInt = Int(payday) else { return payday = "" }
                if textToInt > 289 {payday = oldValue}
                if textToInt > 28 {
                    inActivateButton()
                } else {
                    activateButton()
                }
            } else {
                inActivateButton()
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

private extension WorkSpaceCreateViewModel {
    
    func switchToNextStatus() {
        withAnimation(.easeIn) {
            switch currentState {
            case .workSpace:
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
        case .workSpace:
            isActivatedConfirmButton = true
            return
        case .hourlyWage:
            if workSpace.isEmpty {return}
            if hourlyWage.isEmpty {return}
            guard let hourlyWageInt = Int(hourlyWage) else { return }
            if hourlyWageInt >= 1000000 {return}
            isActivatedConfirmButton = true
            return
        case .payday:
            if workSpace.isEmpty {return}
            if hourlyWage.isEmpty {return}
            guard let hourlyWageInt = Int(hourlyWage) else { return }
            if hourlyWageInt >= 1000000 {return}
            if payday.isEmpty {return}
            guard let paydayInt = Int(payday) else { return }
            if paydayInt > 28 {return}
            isActivatedConfirmButton = true
            return
        case .toggleOptions:
            if workSpace.isEmpty {return}
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
    case workSpace
    case hourlyWage
    case payday
    case toggleOptions
    
    var title: String {
        switch self {
        case .workSpace:
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
