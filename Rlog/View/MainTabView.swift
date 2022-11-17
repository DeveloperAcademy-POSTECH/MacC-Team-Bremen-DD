//
//  MainTabView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            switch viewRouter.currentTab {
            case .schedule:
                Tab.schedule.view
            case .workspace:
                Tab.workspace.view
            case .monthlyCalculte:
                Tab.monthlyCalculte.view
            }
            tabBarView
        }
        .ignoresSafeArea(.keyboard)
    }
}

private extension MainTabView {
    var tabBarView: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.grayLight)
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    tabItem(tab: tab)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 49)
        .background(Color.backgroundWhite)
    }

    func tabItem(tab: Tab) -> some View {
        VStack(spacing: 0) {
            Image(tab.systemName)
                .frame(width: 30, height: 30)
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 3, trailing: 0))
            Text(tab.title)
                .font(.system(size: 10))
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .foregroundColor(viewRouter.currentTab == tab ? Color.primary : Color.grayLight)
        .onTapGesture {
            viewRouter.currentTab = tab
        }
    }
}

