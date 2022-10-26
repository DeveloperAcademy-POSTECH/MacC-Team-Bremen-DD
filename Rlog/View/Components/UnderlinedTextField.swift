//
//  CustomTextField.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

enum UnderlinedTextFieldType: Equatable {
    case workplace
    case wage
    case payday
    case reason
    case none(title: String)

    var title: String {
        switch self {
        case .workplace: return "근무지"
        case .wage: return "시급"
        case .payday: return "급여일"
        case .reason: return "사유"
        case .none(let title): return title
        }
    }
    
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

struct UnderlinedTextField<T>: View {
    let textFieldType: UnderlinedTextFieldType
    @State var isFocused = false
    @Binding var text: T {
        // TODO: 코드 미작동 원인 파악 필요
        didSet {
            switch textFieldType {
            case .workplace:
                guard let string = text as? String else { return }
                if string.count > 20 && "\(oldValue)".count <= 20 {
                    text = oldValue
                }
            case .wage:
                guard let string = text as? String else { return }
                if string.hasPrefix("0") { text = "" as! T }
            case .payday:
                guard let string = text as? String else { return }
                guard let textToInt = Int(string) else { return }
                if string.hasPrefix("0") || textToInt > 28 || textToInt < 1 { text = "" as! T }
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
                        Text("\(String(describing: text).count)/20")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing)
                }
            }
            
            Rectangle()
                .frame(maxWidth: .infinity, minHeight: 2, maxHeight: 2)
                .foregroundColor(isFocused == false ? .gray : .green)
        }
        .frame(maxWidth: .infinity, minHeight: 30, maxHeight: 30)
    }
}

// https://medium.com/hcleedev/swift-textfield-기존-focus-방식과-새롭게-등장한-focusstate-활용하기-8725c7425140
private struct UITextFieldRepresentable<T>: UIViewRepresentable {
    @Binding var text: T
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
        uiView.text = String(describing: self.text)
        if isFirstResponder && !context.coordinator.didFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didFirstResponder = true
        }
    }
    
    func makeCoordinator() -> UITextFieldRepresentable.Coordinator {
        Coordinator(text: self.$text, isFocused: self.$isFocused)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: T
        @Binding var isFocused: Bool
        var didFirstResponder = false
        
        init(text: Binding<T>, isFocused: Binding<Bool>) {
            self._text = text
            self._isFocused = isFocused
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            guard let genericText = textField.text as? T else { return }
            self.text = genericText
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
