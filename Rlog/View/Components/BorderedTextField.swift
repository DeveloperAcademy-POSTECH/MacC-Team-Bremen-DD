//
//  BorderedTextField.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

struct BorderedTextField: View {
    let textFieldType: BorderedTextFieldType
    @FocusState var isFocused: Bool
    @State var maximumText = ""
    @Binding var text: String

    var body: some View {
        borderedTextFieldView
    }
}

private extension BorderedTextField {
    var borderedTextFieldView: some View {
        VStack {
            HStack {
                // 🔥
                prefixView
                contents
                Spacer()
                suffixView
            }
            .padding(.vertical, 13)
            .padding(.horizontal)
            .background(Color.backgroundCard)
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isFocused == false ? .backgroundStroke : isErrorOnTextField(),
                        lineWidth: 2
                    )
            }
        }
        .frame(maxWidth: .infinity, minHeight: 30, maxHeight: 30)
    }
    
    var prefixView: some View {
        HStack {
            if textFieldType == .payday {
                Text("매월")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.leading)
            }
        }
    }
    
    var contents: some View {
        TextField(
            textFieldType.placeholder,
            text: $text
        )
        .padding(.horizontal)
        .keyboardType(textFieldType.keyboardType)
        .focused($isFocused)
        .onChange(of: text) { newValue in
            // 🔥
            switch textFieldType {
            case .workplace:
                if text.count == 20 { maximumText = newValue }
                if newValue.count > 20 { text = maximumText }
            case .wage:
                guard let textToInt = Int(newValue) else { return text = "" }
                if newValue.hasPrefix("0") { text = "" }
                if newValue.count == 7 { maximumText = newValue }
                if textToInt >= 1000000 { text = maximumText }
            case .payday:
                guard let textToInt = Int(newValue) else { return text = "" }
                if newValue.hasPrefix("0") { text = "" }
                if text.count == 2 { maximumText = newValue }
                if textToInt > 28 || textToInt < 1 { text = maximumText }
            case .reason, .time, .none:
                return
            }
        }
    }

    // 🔥
    @ViewBuilder
    var suffixView: some View {
        switch textFieldType {
        case .workplace:
            Text("\(String(describing: text).count)/20")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.trailing)
        case .payday:
            Text("일")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.trailing)
        case .wage:
            Text("원")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.trailing)
        case .reason, .time, .none(title: _):
            EmptyView()
        }
    }
    
    // 🔥
    func isErrorOnTextField() -> Color {
        switch textFieldType {
        case .workplace:
            if text.count == 20 { return .red }
        case .wage:
            guard let textToInt = Int(text) else { return .red }
            if textToInt >= 1000000 { return .red }
        case .payday:
            guard let textToInt = Int(text) else { return .red }
            if textToInt > 28 || textToInt < 1 { return .red }
        case .reason, .time, .none:
            return .primary
        }
        
        return .primary
    }
}

enum BorderedTextFieldType: Equatable {
    case workplace
    case wage
    case payday
    case reason
    case time
    case none(title: String)

    var title: String {
        switch self {
        case .workplace: return "근무지"
        case .wage: return "시급"
        case .payday: return "급여일"
        case .reason: return "사유"
        case .time: return "시간"
        case .none(let title): return title
        }
    }
    
    var placeholder: String {
        switch self {
        case .workplace: return "예시) 편의점"
        case .wage: return "최저시급 9,160원"
        case .payday: return "10"
        case .reason: return "사유를 입력해주세요."
        case .time: return "00"
        case .none: return "내용을 입력해주세요."
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .wage, .payday, .time: return .decimalPad
        case .workplace, .reason, .none: return .default
        }
    }
}
