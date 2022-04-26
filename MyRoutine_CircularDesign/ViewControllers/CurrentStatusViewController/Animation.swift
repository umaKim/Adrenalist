//
//  CurrentStatusViewControllerAnimation.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/04.
//

import UIKit

//animation
extension CurrentStatusViewController {
    
    func animateCircle(){
        animateOutlineStroke()
        animatePulsing()
        //animateTimerInsideStroke()
    }
    
    private func animateOutlineStroke() {
        WorkOutToDoManager.shared.calculateDonePercentage()
        guard let percentage = WorkOutToDoManager.shared.donePercentage else { return }
        outlineStrokeLayer.strokeEnd = percentage / 100.0
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = 0.5
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        outlineStrokeLayer.add(basicAnimation, forKey: "Basic")
    }
    
    func animateTimerInsideStroke() {
        
        if timerInsideStrokeLayer.strokeEnd == 1.0 || TimerManager.shared.timeToBeSaved.countUptoThisSec + 1 <= TimerManager.shared.onGoingTime {
            
            timerInsideStrokeLayer.strokeEnd = 0
            timerInsideStrokeLayer.isHidden = true
            
            SoundManager.shared.playSound("HighPitchBellRing")
            HapticManager.shared.vibrateForImpactFeedback(intensity: 1.0)
            TimerManager.shared.timer.invalidate()
            TimerManager.shared.onGoingTime = 0
            TimerManager.shared.isTimeRunning = false
            return
        }
        
        timerInsideStrokeLayer.strokeEnd = CGFloat(TimerManager.shared.onGoingTime) / CGFloat(TimerManager.shared.timeToBeSaved.countUptoThisSec)
        timerInsideStrokeLayer.isHidden = false
        TimerManager.shared.onGoingTime += 1
        
        //MARK: TIMER DESIGN HERE
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = 1
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        timerInsideStrokeLayer.add(basicAnimation, forKey: "Basic")
    }
    
    private func animatePulsing() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        if(WorkOutToDoManager.shared.workOutToDos.count == 0){
            animation.toValue = 1.0
        } else {
            animation.toValue = 1.5
        }
        
        animation.fromValue = 1.25
        animation.duration = progressResult()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsingLayer.add(animation, forKey: "pulsing")
    }
    
    func fadeViewInThenOut(view : UIView, delay: TimeInterval, ultimateAlpha: CGFloat) {
        let animationDuration = 0.25
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in view.alpha = 0 }) { (Bool) -> Void in
            UIView.animate(withDuration: animationDuration, delay: delay, options: .transitionCurlUp, animations: { () -> Void in
                view.alpha = ultimateAlpha
            })}
    }
    
    private func progressResult() -> CFTimeInterval {
        let finishedWorkOut = CGFloat(WorkOutToDoManager.shared.getUnfinishedWorkOut().count)
        let totalWorkout = CGFloat(WorkOutToDoManager.shared.workOutToDos.count)
        
        if 0.2 >= CFTimeInterval(finishedWorkOut / totalWorkout) {
            return 0.2
        } else {
            return CFTimeInterval(finishedWorkOut / totalWorkout)
        }
    }
}
