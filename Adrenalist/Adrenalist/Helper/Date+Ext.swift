//
//  Date+Ext.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/14.
//

import Foundation

extension Date {
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
}
