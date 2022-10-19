//
//  TitleSubView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/19.
//

import SwiftUI

struct TitleSubView: View {
    let contents: String
    var body: some View {
        Text(contents)
            .font(.title3)
            .padding(.bottom,20)
    }
}

struct TitleSubView_Previews: PreviewProvider {
    static var previews: some View {
        TitleSubView(contents: "test")
    }
}
