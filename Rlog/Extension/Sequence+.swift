//
//  Sequence+.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/24.
//
//  https://stackoverflow.com/questions/25738817/removing-duplicate-elements-from-an-array-in-swift

import Foundation

// Removing duplicate elements from an array
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
