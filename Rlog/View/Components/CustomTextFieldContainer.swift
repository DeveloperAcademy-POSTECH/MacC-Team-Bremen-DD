//
//  CustomTextFieldContainer.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

struct CustomTextFieldContainer: View {
    let containerType: CustomTextFieldType
    var text: Binding<String>
    
    init(containerType: CustomTextFieldType, text: Binding<String>) {
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
                    text: text
                )
                
                if Int(text.wrappedValue) ?? 10 > 28 {
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
        CustomTextField(
            textFieldType: .reason,
            text: text
        )
        
    }
}
