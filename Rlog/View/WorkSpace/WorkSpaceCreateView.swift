//
//  WorkSpaceCreateView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI


struct WorkSpaceCreateView: View {
    @ObservedObject var viewModel = WorkSpaceCreateViewModel()
    @State var writingState: WritingState = .hourlyWage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            guidingTitle
            guidingText
                toggleInputs
            }
            // TODO: 컨포넌트로 대체
                VStack(alignment: .leading, spacing: 20)  {
                    Text("정산일")
                    TextField("10", text: $viewModel.payday)
                }
            }
                VStack(alignment: .leading, spacing: 20)  {
                    Text("시급")
                    TextField("최저시급 9,160원", text: $viewModel.hourlyWage)
                }
            VStack(alignment: .leading, spacing: 20)  {
                Text("근무지")
                TextField("예시) 편의점", text: $viewModel.workSpaceName)
            }
            Spacer()
                ConfirmButton
        }
        .padding()
        
    }
}

private extension WorkSpaceCreateView {
    // 타이틀
    var guidingTitle: some View {
            Text("새로운 아르바이트를 추가합니다.")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.fontBlack)
                .padding(.vertical, 20)
    }
    var toggleInputs: some View {
        VStack(spacing: 10) {
            Toggle(isOn: $viewModel.isOnIncomeTax, label: {
                HStack(alignment:.bottom) {
                    Text("소득세")
                    Text("3.3% 적용")
                        .font(.caption)
                        .foregroundColor(.fontLightGray)
                }
            })
            Toggle(isOn: $viewModel.isOnHolidayAllowance, label: {
                HStack(alignment:.bottom) {
                    Text("주휴수당")
                    Text("60시간 근무 시 적용")
                        .font(.caption)
                        .foregroundColor(.fontLightGray)
                }
            })
        }
    }
    // 가이드 텍스트
    var guidingText: some View {
        Text(viewModel.currentState.title)
            .font(.title3)
    }
    
    // 확인 버튼
    var ConfirmButton: some View {
        Button {
            print(viewModel.currentState.rawValue)
            viewModel.didTapConfirmButton()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(viewModel.isActivatedConfirmButton ? .green : .gray)
                    .frame(height: 58)
                Text("확인")
                    .foregroundColor(.white)
            }
        }
        
    }
}

struct WorkSpaceCreateView_Previews: PreviewProvider {
    static var previews: some View {
        WorkSpaceCreateView()
    }
}

extension View {
    /// hidden 방식을 고민하다가 좋은 코드를 발견해서 가져왔습니다. 직접 구현하는것도 가능하지만 더 깔끔하게 사용 가능할것 같아서 활용하고자합니다!
    /// https://github.com/GeorgeElsham/HidingViews
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
