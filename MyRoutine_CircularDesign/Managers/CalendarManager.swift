//
//  CalendarManager.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/05/03.
//

import Foundation

class CalendarManager {
    static var shared = CalendarManager()
    
    var workOutWithDate = WorkOutWithDate()
    
    private init(){}
}
