//
//  CustomTextField.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

enum UnderlinedTextFieldType: String {
    case workplace = "근무지"
    case wage = "시급"
    case payday = "급여일"
    case reason = "사유"
    case none = ""
    
    var placeholder: String {
        switch self {
        case .workplace: return "예시) 편의점"
        case .wage: return "최저시급 9,160원"
        case .payday: return "10"
        case .reason: return "사유를 입력해주세요."
        case .none: return "내용을 입력해주세요."
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .wage, .payday: return .numberPad
        case .workplace, .reason, .none: return .default
        }
    }
}

struct UnderlinedTextField: View {
    let textFieldType: UnderlinedTextFieldType
    @State var isFocused = false
    @Binding var text: String {
        didSet {
            switch textFieldType {
            case .workplace:
                if text.count > 20 && oldValue.count <= 20 {
                    text = oldValue
                }
            case .wage:
                if text.hasPrefix("0") { text = "" }
            case .payday:
                guard let textToInt = Int(text) else { return }
                if text.hasPrefix("0") || textToInt > 31 || textToInt < 1 { text = "" }
            case .reason:
                return
            case .none:
                return
            }
        }
    }

    var body: some View {
        underlinedTextFieldView
    }
}

private extension UnderlinedTextField {
    var underlinedTextFieldView: some View {
        VStack {
            HStack {
                UITextFieldRepresentable(
                    text: $text,
                    placeholder: textFieldType.placeholder,
                    isFocused: $isFocused
                )
                .padding(.horizontal)
                .keyboardType(textFieldType.keyboardType)

                Spacer()
                
                if textFieldType == .workplace {
                    HStack {
                        Spacer()
                        Text("\(text.count)/20")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing)
                }
            }
            
            Rectangle()
                .frame(maxWidth: .infinity, minHeight: 2, maxHeight: 2)
                .foregroundColor(isFocused == false ? .fontLightGray : .primary)
        }
        .frame(maxWidth: .infinity, minHeight: 30, maxHeight: 30)
    }
}

// https://medium.com/hcleedev/swift-textfield-기존-focus-방식과-새롭게-등장한-focusstate-활용하기-8725c7425140
private struct UITextFieldRepresentable: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var isFirstResponder = false
    @Binding var isFocused: Bool
    
    func makeUIView(context: UIViewRepresentableContext<UITextFieldRepresentable>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = self.placeholder
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<UITextFieldRepresentable>) {
        uiView.text = self.text
        if isFirstResponder && !context.coordinator.didFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didFirstResponder = true
        }
    }
    
    func makeCoordinator() -> UITextFieldRepresentable.Coordinator {
        Coordinator(text: self.$text, isFocused: self.$isFocused)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var isFocused: Bool
        var didFirstResponder = false
        
        init(text: Binding<String>, isFocused: Binding<Bool>) {
            self._text = text
            self._isFocused = isFocused
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            self.text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.isFocused = true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            self.isFocused = false
        }
    }
}
