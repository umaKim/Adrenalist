//
//  CircularView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import UIKit.UIView
import Combine

final class CircularView: UIView {
    
    private let circularPath            = UIBezierPath(arcCenter: .zero,
                                                       radius: 150,
                                                       startAngle: 0,
                                                       endAngle: 2 * CGFloat.pi,
                                                       clockwise: true)
    private let pulsingLayer            = CAShapeLayer()
    private let outlineStrokeLayer      = CAShapeLayer()
    private let trackLayer              = CAShapeLayer()
    private let timerInsideStrokeLayer  = CAShapeLayer()
    
    init() {
        super.init(frame: .zero)
        drawLayers()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Animate
extension CircularView {
    func animatePulse(_ duration: CGFloat) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        if(duration == 0) {
            animation.toValue = 1.0
        } else {
            animation.toValue = 1.5
        }
        
        animation.fromValue = 1.25
        animation.duration = CFTimeInterval(duration)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsingLayer.add(animation, forKey: "pulsing")
    }
    
    func animateOutlineStroke(_ strokeEnd: CGFloat) {
        outlineStrokeLayer.strokeEnd = strokeEnd
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = 0.5
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        outlineStrokeLayer.add(basicAnimation, forKey: "Basic")
    }
    
    func animateInlineStroke(_ duration: CGFloat) {
        timerInsideStrokeLayer.strokeEnd = duration
        timerInsideStrokeLayer.opacity = 1
        
        if duration == 0 {
            UIView.animate(withDuration: 1) {
                self.timerInsideStrokeLayer.opacity = 0.5
            }
        }
        
        //MARK: TIMER DESIGN HERE
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = 1
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        timerInsideStrokeLayer.add(basicAnimation, forKey: "Basic")
    }
}

//MARK: - Set up UI
extension CircularView {
    private func drawLayers() {
        self.drawPulsingLayer()
        self.drawTrackLayer()
        self.drawOutlineStrokeLayer()
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
}
