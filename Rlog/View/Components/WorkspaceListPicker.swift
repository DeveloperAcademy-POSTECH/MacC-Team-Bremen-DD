//
//  WorkspaceListPicker.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/18.
//

import SwiftUI

struct WorkspaceListPicker: View {
    @State private var isTapped = false
    @Binding var selection: String
    let workspaceList: [String]
    
    var body: some View {
        borderedPicker
    }
}

private extension WorkspaceListPicker {
    var borderedPicker: some View {
        VStack {
            VStack(spacing: 0) {
                Text(selection != "" ? selection : "근무지를 선택해주세요.")
            }
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            .cornerRadius(10)
            .frame(maxWidth: .infinity, maxHeight: 56)
            .background(Color.backgroundCard)
            .onTapGesture { withAnimation { isTapped.toggle() } }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isTapped ? Color.primary : Color.backgroundStroke,
                        lineWidth: 2
                    )
            }
            
            if isTapped {
                wheelTimePicker
            }
        }
    }
    
    var wheelTimePicker: some View {
        Picker("Hello", selection: $selection) {
            ForEach(workspaceList, id: \.self) { workspace in
                Text(workspace)
            }
        }
        .pickerStyle(.segmented)
        .background(.white)
        .padding(.horizontal)
    }
}
