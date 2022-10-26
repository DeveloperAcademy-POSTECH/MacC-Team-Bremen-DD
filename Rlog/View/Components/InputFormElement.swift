//
//  CustomTextFieldContainer.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

struct InputFormElement<T>: View {
    let containerType: UnderlinedTextFieldType
    var text: Binding<T>
    
    init(containerType: UnderlinedTextFieldType, text: Binding<T>) {
        self.containerType = containerType
        self.text = text
    }
    
    var body: some View {
        VStack {
            titleHeader
            container
        }
    }
}

private extension InputFormElement {
    var titleHeader: some View {
        HStack {
            Text(containerType.title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
    
    @ViewBuilder var container: some View {
        switch containerType {
        case .workplace: workplaceView
        case .wage: wageView
        case .payday: paydayView
        case .reason: reasonView
        case .none: noneView
        }
    }
    
    var workplaceView: some View {
        VStack {
            UnderlinedTextField(
                textFieldType: .workplace,
                text: text
            )

            if let text = text.wrappedValue as? String, text.count > 20 {
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
        HStack {
            UnderlinedTextField(
                textFieldType: .wage,
                text: text
            )
            
            Spacer()
            
            Text("원")
        }
    }
    
    var paydayView: some View {
        HStack(alignment: .top) {
            Text("매월")
            Spacer()
            VStack(spacing: 0) {
                UnderlinedTextField(
                    textFieldType: .payday,
                    text: text
                )
                
                if let number = text.wrappedValue as? Int16, number > 28 || number < 1 {
                    HStack {
                        Text("1~28 사이의 숫자를 입력해주세요")
                            .font(.footnote)
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .padding(.top, 4)
                }
                
            }
            Spacer()
            
            Text("일")
        }
    }
    
    var reasonView: some View {
        UnderlinedTextField(
            textFieldType: .reason,
            text: text
        )
    }
    
    var noneView: some View {
        UnderlinedTextField(
            textFieldType: .none(title: containerType.title),
            text: text
        )
    }
}
