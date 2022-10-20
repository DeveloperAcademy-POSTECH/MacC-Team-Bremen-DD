//
//  WorkSpaceListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

struct WorkSpaceListView: View {
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(models, id: \.self) { model in
                    NavigationLink(
                        destination: { WorkSpaceDetailView() },
                        label: { WorkSpaceCardContents(model: model) }
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("근무지")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { print("button pressed") }){
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

private extension WorkSpaceListView {
    func WorkSpaceCardContents(model: CustomModel) -> some View {
        VStack(alignment:. leading) {
            Text(model.title)
            
            ForEach(Info.allCases, id: \.self) { tab in
                HStack {
                    Text(tab.text)
                    Spacer()
                    Text(model.text(info: tab))
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .padding([.horizontal, .bottom])
    }
    
}

struct WorkSpaceListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkSpaceListView()
    }
}

enum Info: CaseIterable {
    case money
    case date
    
    var text: String {
        switch self {
        case .money: return "시급"
        case .date: return "급여일"
        }
    }
}

struct CustomModel: Hashable {
    let title: String
    let money: Int
    let date: String
    
    func text(info: Info) -> String {
        switch info {
        case .money: return "\(money)"
        case .date: return date
        }
    }
}

let models = [
    CustomModel(
        title: "팍이네 팍팍 감자탕",
        money: 2000,
        date: "2022.07.11"),
    CustomModel(
        title: "팍이네 퍽퍽 야스탕",
        money: 1020,
        date: "2022.07.12"),
    CustomModel(
        title: "팍이네 닭도리탕",
        money: 3000,
        date: "2022.08.11"),
]
