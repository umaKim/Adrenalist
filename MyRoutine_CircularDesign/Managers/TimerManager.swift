//
//  TimerManager.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/19.
//

import UIKit

final class TimerManager {
    static let shared = TimerManager()
    
    var timer = Timer()
    
    var isTimeRunning: Bool = false
    
    var timeToBeSaved = TimeToBeSaved()
    
    var onGoingTime: Int = 0

    private init(){}
    
}
