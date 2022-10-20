//
//  TitleSubView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/19.
//

import SwiftUI

struct TitleSubView: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.title3)
            .padding(.bottom,20)
    }
}

struct TitleSubView_Previews: PreviewProvider {
    static var previews: some View {
        TitleSubView(title: "test")
    }
}
