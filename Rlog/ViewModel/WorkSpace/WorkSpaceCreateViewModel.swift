//
//  WorkSpaceCreateViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Combine
import SwiftUI


final class WorkSpaceCreateViewModel: ObservableObject {
    @Published var currentState: WritingState = .workSpace
    @Published var isTappedConfirmButton: Bool = false
    
    init() {
        $isTappedConfirmButton.filter {
            $0 == true
        }.sink { [weak self] _ in
            guard let self = self else { return }
            self.currentState = WritingState(rawValue: self.currentState.rawValue + 1) ?? .workSpace
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
