//
//  ScheduleCreateViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Foundation

class ScheduleCreateViewModel: ObservableObject {
    let timeUnits = ["-1시간", "-30분", "+30분", "+1시간"]
    // TODO: - 현재 가지고 있는 workspace 받아오기
    let workspaces = ["제이든의 낚시 교실", "GS25 포항공대점"]
}
