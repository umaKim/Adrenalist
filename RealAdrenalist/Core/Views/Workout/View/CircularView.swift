//
//  CircularView.swift
//  RealAdrenalist
//
//  Created by 김윤석 on 2022/04/26.
//

import UIKit.UIView

enum CircularViewAction {
    case doubleTap
}

final class CircularView: UIView {
    let circularPath = UIBezierPath(arcCenter: .zero, radius: 150, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
    let pulsingLayer = CAShapeLayer()
    let outlineStrokeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let timerInsideStrokeLayer = CAShapeLayer()
    
    init() {
        super.init(frame: .zero)
        drawLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawLayers() {
        self.drawPulsingLayer()
        self.drawTrackLayer()
        self.drawOutlineStrokeLayer()
//        self.drawCurrentWorkOutLayer()
//        self.drawNextWorkOutLabel()
        self.drawTimerLayer()
    }
    
    func drawOutlineStrokeLayer() {
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
    
    func drawTimerLayer( ){
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
    
    func drawTrackLayer() {
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor(red: 56/255, green: 25/255, blue: 49/255, alpha: 1).cgColor
        trackLayer.lineWidth = 20
        trackLayer.fillColor = UIColor.black.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.position = center
        layer.addSublayer(trackLayer)
    }
    
    func drawPulsingLayer() {
        let circularPathforPulsingLayer = UIBezierPath(arcCenter: .zero, radius: 125, startAngle: 0, endAngle:  2 * CGFloat.pi, clockwise: true)
        pulsingLayer.path = circularPathforPulsingLayer.cgPath
        pulsingLayer.strokeColor = UIColor.clear.cgColor
        pulsingLayer.fillColor = UIColor(red: 86/255, green: 30/255, blue: 63/255, alpha: 1).cgColor
        pulsingLayer.lineCap = CAShapeLayerLineCap.round
        pulsingLayer.position = center
        layer.addSublayer(pulsingLayer)
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
