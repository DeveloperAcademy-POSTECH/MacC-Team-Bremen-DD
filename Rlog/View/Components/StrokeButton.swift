//
//  StrokeButton.swift
//  MacCPlayGround
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

enum StrokeButtonType {
    case add
    case destructive
}

struct StrokeButton: View {
    let label: String
    let buttonType: StrokeButtonType
    let action: () -> Void
    
    init(label: String, buttonType: StrokeButtonType, action: @escaping () -> Void) {
        self.label = label
        self.buttonType = buttonType
        self.action = action
    }
    
    var body: some View {
        Button(label) { action() }
            .buttonStyle(StrokeButtonStyle(buttonType: buttonType))
    }
    
    private struct StrokeButtonStyle: ButtonStyle {
        let buttonType: StrokeButtonType
        
        func makeBody(configuration: Configuration) -> some View {
            StyleButton(
                buttonType: buttonType,
                configuration: configuration
            )
        }
        
        private struct StyleButton: View {
            @Environment(\.isEnabled) var isEnabled
            
            let buttonType: StrokeButtonType
            let configuration: StrokeButtonStyle.Configuration
            var backgroundColor: Color {
                if configuration.isPressed {
                    return buttonType == .add
                    ? .fontLightGray.opacity(0.5)
                    : .red.opacity(0.5)
                }
                return buttonType == .add ? .fontLightGray : .red
            }
            
            var body: some View {
                configuration.label
                    .font(.body)
                    .foregroundColor(backgroundColor)
                    .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(backgroundColor, lineWidth: 1)
                    )
            }
        }
    }
}
