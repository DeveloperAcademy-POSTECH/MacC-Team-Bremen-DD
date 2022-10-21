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
            // TODO: 컨포넌트로 대체
            VStack{
                Text("근무지")
                //                TextField(<#T##SwiftUI.LocalizedStringKey#>, text: <#T##SwiftUI.Binding<String>#>, onEditingChanged: <#T##(Bool) -> Void#>)
            }
            // TODO: 컨포넌트로 대체
            Button {
                print(viewModel.currentState.rawValue)
                viewModel.isTappedConfirmButton = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 58)
                    Text("확인")
                }
            }
            Spacer()
        }
        .padding()
        
    }
}

private extension WorkSpaceCreateView {
    var guidingTitle: some View {
        Text("새로운 아르바이트를 추가합니다.")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.fontBlack)
        //            .isHidden(true)
    }
    var guidingText: some View {
        Text(viewModel.currentState.title)
            .font(.title3)
        
    }
}

struct WorkSpaceCreateView_Previews: PreviewProvider {
    static var previews: some View {
        WorkSpaceCreateView()
    }
}
