//
//  CircularView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import UIKit.UIView
import Combine

final class CircularView: UIView {
    
    private let circularPath = UIBezierPath(arcCenter: .zero, radius: 150, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
    private let pulsingLayer = CAShapeLayer()
    private let outlineStrokeLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    private let timerInsideStrokeLayer = CAShapeLayer()
    
    init() {
        super.init(frame: .zero)
        drawLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawLayers() {
        self.drawPulsingLayer()
        self.drawTrackLayer()
        self.drawOutlineStrokeLayer()
//        self.drawCurrentWorkOutLayer()
//        self.drawNextWorkOutLabel()
        self.drawTimerLayer()
    }
    
    private func drawOutlineStrokeLayer() {
        outlineStrokeLayer.path = circularPath.cgPath
        outlineStrokeLayer.strokeColor = UIColor(red: 234/255, green: 46/255, blue: 111/255, alpha: 1).cgColor
        outlineStrokeLayer.lineWidth = 20
        outlineStrokeLayer.fillColor = UIColor.clear.cgColor
        outlineStrokeLayer.lineCap = CAShapeLayerLineCap.round
        outlineStrokeLayer.strokeEnd = 0
        outlineStrokeLayer.position = center
        outlineStrokeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        layer.addSublayer(outlineStrokeLayer)
    }
    
    private func drawTimerLayer( ){
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 120, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        timerInsideStrokeLayer.path = circularPath.cgPath
        timerInsideStrokeLayer.strokeColor = UIColor(red: 234/255, green: 120/255, blue: 47/255, alpha: 1).cgColor
        timerInsideStrokeLayer.lineWidth = 10
        timerInsideStrokeLayer.fillColor = UIColor.clear.cgColor
        timerInsideStrokeLayer.lineCap = CAShapeLayerLineCap.round
        timerInsideStrokeLayer.strokeEnd = 0
        timerInsideStrokeLayer.position = center
        timerInsideStrokeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        layer.addSublayer(timerInsideStrokeLayer)
    }
    
    private func drawTrackLayer() {
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor(red: 56/255, green: 25/255, blue: 49/255, alpha: 1).cgColor
        trackLayer.lineWidth = 20
        trackLayer.fillColor = UIColor.black.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.position = center
        layer.addSublayer(trackLayer)
    }
    
    private func drawPulsingLayer() {
        let circularPathforPulsingLayer = UIBezierPath(arcCenter: .zero, radius: 125, startAngle: 0, endAngle:  2 * CGFloat.pi, clockwise: true)
        pulsingLayer.path = circularPathforPulsingLayer.cgPath
        pulsingLayer.strokeColor = UIColor.clear.cgColor
        pulsingLayer.fillColor = UIColor(red: 86/255, green: 30/255, blue: 63/255, alpha: 1).cgColor
        pulsingLayer.lineCap = CAShapeLayerLineCap.round
        pulsingLayer.position = center
        layer.addSublayer(pulsingLayer)
    }
    
    func animate() {
        animatePulse()
        animateOutlineStroke()
    }
    
    private func animatePulse() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        if(PersistanceManager.shared.retrieveWorkouts().count == 0){
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
    
    private func animateOutlineStroke() {
        print(PersistanceManager.shared.retrieveWorkouts())
        
//        guard let percentage = PersistanceManager.shared.retrieveWorkouts().count else { return }
        let percentage = CGFloat((PersistanceManager.shared.retrieveWorkouts().filter({$0.isDone}).count / PersistanceManager.shared.retrieveWorkouts().count) / 100)
        outlineStrokeLayer.strokeEnd = percentage / 100.0
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = 0.5
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        outlineStrokeLayer.add(basicAnimation, forKey: "Basic")
    }
    
    private func progressResult() -> CFTimeInterval {
        let finishedWorkOut = CGFloat(PersistanceManager.shared.retrieveWorkouts().filter({ $0.isDone}).count)
        let totalWorkout = CGFloat(PersistanceManager.shared.retrieveWorkouts().count)
        
        if 0.2 >= CFTimeInterval(finishedWorkOut / totalWorkout) {
            return 0.2
        } else {
            return CFTimeInterval(finishedWorkOut / totalWorkout)
        }
    }
    
//    func drawCurrentWorkOutLayer() {
//        currentWorkOutLabel.font = UIFont.boldSystemFont(ofSize: 26)
//        currentWorkOutLabel.textColor = .white
//        currentWorkOutLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
//        currentWorkOutLabel.center = view.center
//        currentWorkOutLabel.numberOfLines = 3
//        addSubview(currentWorkOutLabel)
//    }
//
//    func drawNextWorkOutLabel() {
//        nextWorkOutLabel.font = UIFont.boldSystemFont(ofSize: 18)
//        nextWorkOutLabel.textColor = .white
//        nextWorkOutLabel.alpha = 0.3
//        nextWorkOutLabel.numberOfLines = 2
//        addSubview(nextWorkOutLabel)
//    }
}
