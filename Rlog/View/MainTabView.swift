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
                        Image(tab.systemName)
                            .foregroundColor(.primary)
                        Text(tab.title)
                    }
            }
        }
        .accentColor(.primary)
    }
}

