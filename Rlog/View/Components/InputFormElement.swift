//
//  InputFormElement.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

struct InputFormElement: View {
    let containerType: BorderedTextFieldType
    var text: Binding<String>
    
    init(containerType: BorderedTextFieldType, text: Binding<String>) {
        self.containerType = containerType
        self.text = text
    }
    
    var body: some View {
        VStack {
            titleHeader
                .padding(.bottom, 8)
            container
        }
    }
}

private extension InputFormElement {
    var titleHeader: some View {
        HStack {
            Text(containerType.title)
                .font(.caption)
                .foregroundColor(.grayMedium)
            
            Spacer()
        }
    }
    
    @ViewBuilder var container: some View {
        switch containerType {
        case .workplace: workplaceView
        case .wage: wageView
        case .payday: paydayView
        case .reason: reasonView
        case .time: timeView
        case .none: noneView
        }
    }
    
    var workplaceView: some View {
        VStack {
            BorderedTextField(
                textFieldType: .workplace,
                text: text
            )
            
            if text.wrappedValue.count == 20 {
                HStack {
                    Text("20자 이상 입력할 수 없어요.")
                        .font(.footnote)
                        .foregroundColor(.red)
                    Spacer()
                }
            }
        }
    }
    
    var wageView: some View {
        VStack {
            BorderedTextField(
                textFieldType: .wage,
                text: text
            )
            
            if let textToInt = Int(text.wrappedValue), textToInt >= 1000000 {
                HStack {
                    Text("1,000,000원 이상 입력할 수 없어요.")
                        .font(.footnote)
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding(.top, 4)
            }
        }
    }
    
    var paydayView: some View {
        VStack(spacing: 0) {
            BorderedTextField(
                textFieldType: .payday,
                text: text
            )
            
            if let textToInt = Int16(text.wrappedValue), textToInt > 28 || textToInt < 1 {
                HStack {
                    Text("1~28 사이의 숫자를 입력해주세요")
                        .font(.footnote)
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding(.top, 4)
            }
        }
    }
    
    var reasonView: some View {
        BorderedTextField(
            textFieldType: .reason,
            text: text
        )
    }
    
    var timeView: some View {
        BorderedTextField(
            textFieldType: .time,
            text: text
        )
    }
    
    var noneView: some View {
        BorderedTextField(
            textFieldType: .none(title: containerType.title),
            text: text
        )
    }
}
