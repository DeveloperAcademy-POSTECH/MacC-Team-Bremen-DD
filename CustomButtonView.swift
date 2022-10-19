//
//  CustomButtonView.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/19.
//

import SwiftUI

struct CustomButtonView: View {

    let action: () -> Void
    let systemName: String

    init(systemName: String,
       action: @escaping () -> Void) {
        self.action = action
        self.systemName = systemName
    }

    var body: some View {
        Button( action: action,
                label: {
                Image(systemName: systemName)
            }
        )
    }
}

//struct CustomButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomButtonView()
//    }
//}
