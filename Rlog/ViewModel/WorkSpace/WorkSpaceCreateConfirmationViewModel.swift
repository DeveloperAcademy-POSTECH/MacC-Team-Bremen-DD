//
//  WorkSpaceCreateConfirmationViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/25.
//

import SwiftUI

final class WorkSpaceCreateConfirmationViewModel: ObservableObject {
    let hasTax = false
    let hasJuhyu = false
}
extension WorkSpaceCreateConfirmationViewModel {
    func popToRoot() {
        //https://stackoverflow.com/questions/57334455/how-can-i-pop-to-the-root-view-using-swiftui
    }
    func writeCoredata() {
        // 코어데이터에 저장하는 함수를 구현
    }
}

struct datasample {
    let name: String
    let paymentDay: Int
    let hourlyWage: Int
    let Color: String
    let hasTax: Bool
    let hasJuhyu: Bool
}
