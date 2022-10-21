//
//  CustomTextFieldContainer.swift
//  MacCPlayGround
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

struct CustomTextFieldContainer: View {
    let containerType: CustomTextFieldType
    let keyboardType: UIKeyboardType
    var text: Binding<String>
    
    init(containerType: CustomTextFieldType, keyboardType: UIKeyboardType, text: Binding<String>) {
        self.containerType = containerType
        self.keyboardType = keyboardType
        self.text = text
    }
    
    var body: some View {
        VStack {
            titleHeader
            container
        }
    }
}

private extension CustomTextFieldContainer {
    var titleHeader: some View {
        HStack {
            Text(containerType.rawValue)
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
        case .none: EmptyView()
        }
    }
    
    var workplaceView: some View {
        VStack {
            CustomTextField(
                textFieldType: .workplace,
                keyboardType: keyboardType,
                text: text
            )
            
            if text.wrappedValue.count > 20 {
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
            CustomTextField(
                textFieldType: .wage,
                keyboardType: keyboardType,
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
                CustomTextField(
                    textFieldType: .payday,
                    keyboardType: keyboardType,
                    text: text
                )
                
                if Int(text.wrappedValue) ?? 10 > 31 {
                    HStack {
                        Text("1~31 사이의 숫자를 입력해주세요")
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
        CustomTextField(
            textFieldType: .reason,
            keyboardType: keyboardType,
            text: text
        )
        
    }
}
