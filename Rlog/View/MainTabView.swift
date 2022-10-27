//
//  MainTabView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

struct MainTabView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        TabView {
            ForEach(Tab.allCases, id: \.self) { tab in
                tab.view
                    .tabItem {
                        Image(systemName: tab.systemName)
                        Text(tab.title)
                    }
            }
        }
    }
}

//struct MainTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainTabView()
//    }
//}
