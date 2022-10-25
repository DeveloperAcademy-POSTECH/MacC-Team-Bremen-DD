//
//  SwiftUIView.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/10/25.
//

import SwiftUI

struct HDivider: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.fontLightGray)
            .frame(maxWidth: .infinity, maxHeight: 1.5)
            .padding(.vertical)
    }
}

struct HDivider_Previews: PreviewProvider {
    static var previews: some View {
        HDivider()
    }
}
