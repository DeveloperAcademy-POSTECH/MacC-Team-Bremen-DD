//
//  CompleteButtonView.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

struct CompleteButtonView: View {
    let label: String
    var isAvailable: Bool
    let action: () -> Void
    
    init(label: String, isAvailable: Bool, action: @escaping () -> Void) {
        self.label = label
        self.isAvailable = isAvailable
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            compleButtonContainerView
        }
        .disabled(!isAvailable)
    }

}

extension CompleteButtonView {
    var compleButtonContainerView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                .foregroundColor(isAvailable ? .primary : .fontLightGray)

            completeButtonLabelView
        }
    }
    
    var completeButtonLabelView: some View {
        Text("확인")
            .font(.body)
            .foregroundColor(.white)
            .fontWeight(isAvailable ? .none : .bold)
    }
}
