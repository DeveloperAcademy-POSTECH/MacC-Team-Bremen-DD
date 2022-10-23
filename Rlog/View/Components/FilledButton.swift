//
//  CompleteButtonView.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

struct FilledButton: View {
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button("확인") { action() }
            .buttonStyle(CustomButtonStyle())
    }
    
    private struct CustomButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            StyleButton(configuration: configuration)
        }
        
        private struct StyleButton: View {
            @Environment(\.isEnabled) var isEnabled
            
            let configuration: CustomButtonStyle.Configuration
            var backgroundColor: Color {
                if configuration.isPressed {
                    return .primary.opacity(0.5)
                }
                return isEnabled ? .primary : .fontLightGray
            }
            
            var body: some View {
                    configuration.label
                        .font(.body)
                        .foregroundColor(.white)
                        .fontWeight(isEnabled ? .none : .bold)
                        .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                        .background(backgroundColor)
                        .cornerRadius(10)
            }
        }
    }
}
