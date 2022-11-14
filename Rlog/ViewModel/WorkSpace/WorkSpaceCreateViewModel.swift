//
//  WorkSpaceCreateViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Combine
import SwiftUI

// 예외처리 : 마지막 스텝까지 가놓고 정보를 누락하는경우!!se


@MainActor
final class WorkSpaceCreateViewModel: ObservableObject {
    @Binding var isActive: Bool
    init(isActive: Binding<Bool>) {
        self._isActive = isActive
    }
    
    var currentState: WritingState = .workSpace
    @Published var isActivatedConfirmButton: Bool = false
    
     var isHiddenToggleInputs: Bool = true
     var isHiddenPayday: Bool = true
     var isHiddenHourlyWage: Bool = true
     var isHiddenConfirmButton: Bool = false
     var isHiddenToolBarItem: Bool = true
    
    @Published var hasTax: Bool = false
    @Published var hasJuhyu: Bool = false
    @Published var hourlyWage = "" {
        didSet {
            if !hourlyWage.isEmpty {
                activateButton(inputState: .hourlyWage)
                isActivatedConfirmButton = true
            } else {
                inActivateButton(inputState: .hourlyWage)
                isActivatedConfirmButton = false
                
            }
        }
    }
    @Published var paymentDay = "" {
        didSet {
            if !paymentDay.isEmpty {
                activateButton(inputState: .payday)
                isActivatedConfirmButton = true
                
            } else {
                inActivateButton(inputState: .payday)
                isActivatedConfirmButton = false
                
            }
        }
    }
    @Published var name = ""{
        didSet {
            if !name.isEmpty {
                activateButton(inputState: .workSpace)
                isActivatedConfirmButton = true
                
            } else {
                inActivateButton(inputState: .workSpace)
                isActivatedConfirmButton = false
            }
        }
    }
    
    func didTapConfirmButton() {
        // 컨포넌트 작동 방식에 따라 수정이 필요할지도!
        if isActivatedConfirmButton {
            switchToNextStatus()
        }
    }
}

private extension WorkSpaceCreateViewModel {
    
//        func getData() -> WorkSpaceModel {
//            return WorkSpaceModel(name: name, paymentDay: paymentDay, hourlyWage: hourlyWage, hasTax: hasTax, hasJuhyu: hasJuhyu)
//        }
    
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
    
    func inActivateButton(inputState: WritingState) {
        if currentState.rawValue == inputState.rawValue {
            isActivatedConfirmButton = false
        }
    }
    
    func activateButton(inputState: WritingState)  {
        if currentState.rawValue == inputState.rawValue {
            isActivatedConfirmButton = true
        }
    }
}

enum WritingState: Int {
    case workSpace, hourlyWage, payday, toggleOptions
    
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
