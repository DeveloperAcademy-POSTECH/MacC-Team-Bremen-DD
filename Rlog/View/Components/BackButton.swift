//
//  NavigationBackButton.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/25.
//

import SwiftUI

struct BackButton: View {
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack(spacing: 5) {
                Image(systemName: "chevron.backward")
                Text("이전")
            }
            .foregroundColor(Color.fontBlack)
        })

    }
}
