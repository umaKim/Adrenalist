//
//  CurrentStatusViewControllerTapGesture.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/04.
//

import UIKit

//TapGesture
extension CurrentStatusViewController {
    @objc func tapToDrawOutlineStroke() {
        animateCircle()
    }
    
    @objc func tappedForNextWorkout() {
        
        SoundManager.shared.playSound("stoneButtonSound")
        
        if WorkOutToDoManager.shared.workOutToDos.isEmpty {
            presentWorkOutTableViewController()
            return
        }
        
        if TimerManager.shared.isTimeRunning == false {
            HapticManager.shared.vibrate(for: .success)
            
            WorkOutToDoManager.shared.completeCurrentWorkOut()
            animateCircle()
            showCurrentWorkOutLabel()
            textAnimation()
            
            if WorkOutToDoManager.shared.getUnfinishedWorkOut().count == 0 {
                showActionSheetAfterAllWorkOutIsDone()
                return
            }
            
            if TimerManager.shared.timeToBeSaved.countUptoThisSec == 0 {
                Storage.store(WorkOutToDoManager.shared.workOutToDos, to: .documents, as: "todos.json")
                return
            }
            
            TimerManager.shared.isTimeRunning = true
            TimerManager.shared.onGoingTime = 1
            
            TimerManager.shared.timer = Timer.scheduledTimer(timeInterval: 1,
                                                             target: self,
                                                             selector: #selector(self.animateTimerAsTimeFlows),
                                                             userInfo: nil,
                                                             repeats: true)
        }
        else if TimerManager.shared.isTimeRunning == true {
            TimerManager.shared.isTimeRunning = false
            TimerManager.shared.timer.invalidate()
            TimerManager.shared.onGoingTime = 0
            animateTimerInsideStroke()
        }
        Storage.store(WorkOutToDoManager.shared.workOutToDos, to: .documents, as: "todos.json")
    }
    
    @objc private func animateTimerAsTimeFlows() {
        animateTimerInsideStroke()
    }
    
    private func textAnimation(){
        fadeViewInThenOut(view: currentWorkOutLabel, delay: 0.02, ultimateAlpha: 1)
        fadeViewInThenOut(view: nextWorkOutLabel, delay: 0.02, ultimateAlpha: 0.25)
    }
    
    private func showActionSheetAfterAllWorkOutIsDone() {
        if WorkOutToDoManager.shared.getUnfinishedWorkOut().count == 0 {
            let actionSheet = UIAlertController(title: "Finished!!", message: "Do you want to record your workout schedule and finish for today?", preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Yes", style: .default, handler: {[weak self] _ in
                
                let todayDate = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"

//                if CalendarManager.shared.workOutInADayArray.contains(where: { $0.date == formatter.string(from: todayDate)}){
//                    for index in 0..<CalendarManager.shared.workOutInADayArray.count { // same day workout
//                        if CalendarManager.shared.workOutInADayArray[index].date == formatter.string(from: todayDate){
//                            CalendarManager.shared.workOutInADayArray[index].workOutWithTime.append(WorkOutWithTime(time: Date().description(with: .current), workOut: WorkOutToDoManager.shared.workOutToDos))
//                        }
//                    }
//                } else {
//                    CalendarManager.shared.workOutInADayArray.append(WorkOutInADay(date: formatter.string(from: todayDate), workOutWithTime: [WorkOutWithTime(time: Date().description(with: .current), workOut: WorkOutToDoManager.shared.workOutToDos)]))
//                }
                
                //만약 이미 오늘 날자에 workout이 존재를 한다면,
//                if CalendarManager.shared.workOutInADayArray.contains(where: {$0.key == formatter.string(from: todayDate)}) {
//                    CalendarManager.shared.workOutInADayArray[formatter.string(from: todayDate)]?.append(WorkOutWithTime(time: Date().description(with: .current), workOut: WorkOutToDoManager.shared.workOutToDos))
//                } else {
//                    CalendarManager.shared.workOutInADayArray =  [formatter.string(from: todayDate): [WorkOutWithTime(time: Date().description(with: .current), workOut: WorkOutToDoManager.shared.workOutToDos)]]
//                }
                    // print(CalendarManager.shared.workOutWithDate.selectedDateWorkOutWithTime)
                
        
                if CalendarManager.shared.workOutWithDate.selectedDateWorkOutWithTime.contains(where: {
                    return $0.key == formatter.string(from: todayDate)
                }){
                    CalendarManager.shared.workOutWithDate.selectedDateWorkOutWithTime[formatter.string(from: todayDate)]?.append(WorkOutWithTime(time: Date().description(with: .current), workOut: WorkOutToDoManager.shared.workOutToDos))
                } else {
                    CalendarManager.shared.workOutWithDate.selectedDateWorkOutWithTime.updateValue([WorkOutWithTime(time: Date().description(with: .current), workOut: WorkOutToDoManager.shared.workOutToDos)], forKey: formatter.string(from: todayDate))
                }

                WorkOutToDoManager.shared.workOutToDos = []
                self?.showCurrentWorkOutLabel()
                self?.animateCircle()
                
                Storage.store(CalendarManager.shared.workOutWithDate, to: .documents, as: "workOutCalendar.json")
                Storage.store(WorkOutToDoManager.shared.workOutToDos, to: .documents, as: "todos.json")
            }))
            
            actionSheet.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(actionSheet, animated: true)
        }
    }
}
