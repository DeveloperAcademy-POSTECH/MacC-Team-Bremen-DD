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
        // TODO: systemGray 적용 필요
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, maxHeight: 1)
    }
}

struct HDivider_Previews: PreviewProvider {
    static var previews: some View {
        HDivider()
    }
}
