//
//  WorkSpaceCreateViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Combine
import SwiftUI


final class WorkSpaceCreateViewModel: ObservableObject {
    @Binding var isActive: Bool
    init(isActive: Binding<Bool>) {
        self._isActive = isActive
    }
    
    // 뷰 상태, 버튼 활성화 여부
    @Published var currentState: WritingState = .workSpace
    @Published var isActivatedConfirmButton: Bool = false
    
    // 버튼 숨김 여부
    @Published var isHiddenToolBarItem = true
    @Published var isHiddenConfirmButton = false
    @Published var isHiddenGuidingTitle = false
    @Published var isHiddenHourlyWage = true
    @Published var isHiddenPayday = true
    @Published var isHiddenToggleInputs = true

    // 인풋값과 입력여부
    @Published var hasTax = false
    @Published var hasJuhyu = false
    @Published var name = "" {
        didSet {
            if !name.isEmpty {
                activateButton(inputState: .workSpace)
            } else {
                inActivateButton(inputState: .workSpace)
            }
        }
    }
    @Published var hourlyWage = "" {
        didSet {
            if !hourlyWage.isEmpty {
                activateButton(inputState: .hourlyWage)
            } else {
                inActivateButton(inputState: .hourlyWage)
            }
        }
    }
    @Published var paymentDay = "" {
        didSet {
            if !paymentDay.isEmpty {
                activateButton(inputState: .payday)
            } else {
                inActivateButton(inputState: .payday)
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

extension WorkSpaceCreateViewModel {
    func getData() -> WorkSpaceModel {
        return WorkSpaceModel(name: name, paymentDay: paymentDay, hourlyWage: hourlyWage, hasTax: hasTax, hasJuhyu: hasJuhyu)
    }
    func switchToNextStatus() {
        withAnimation(.easeIn) {
            switch currentState {
            case .workSpace:
                isHiddenGuidingTitle = true
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
