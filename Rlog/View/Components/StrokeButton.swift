//
//  StrokeButton.swift
//  MacCPlayGround
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

enum StrokeButtonStyle {
    case add
    case destructive
}

struct StrokeButton: View {
    let label: String
    let buttonStyle: StrokeButtonStyle
    let action: () -> Void
    
    init(label: String, buttonStyle: StrokeButtonStyle, action: @escaping () -> Void) {
        self.label = label
        self.buttonStyle = buttonStyle
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            strokeButtonContainerView
        }
    }
}

private extension StrokeButton {
    var strokeButtonContainerView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(
                    buttonStyle == .add ? .gray : .red,
                    lineWidth: 1
                )
                .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
            
            Text(label)
                .foregroundColor(buttonStyle == .add ? .gray : .red)
        }
    }
}

struct StrokeButton_Previews: PreviewProvider {
    static var previews: some View {
        StrokeButton(
            label: "+ 근무 추가하기",
            buttonStyle: .destructive
        ) { }
    }
}
