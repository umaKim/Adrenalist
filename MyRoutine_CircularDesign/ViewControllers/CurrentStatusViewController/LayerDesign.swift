//
//  CurrentStatusViewControllerLayerDesign.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/04.
//

import UIKit
// layer Design
extension CurrentStatusViewController {
    func drawLayers() {
        self.drawPulsingLayer()
        self.drawTrackLayer()
        self.drawOutlineStrokeLayer()
        self.drawCurrentWorkOutLayer()
        self.drawNextWorkOutLabel()
        self.drawTimerLayer()
    }
}

private extension CurrentStatusViewController{
    func drawOutlineStrokeLayer() {
        outlineStrokeLayer.path = circularPath.cgPath
        outlineStrokeLayer.strokeColor = UIColor(red: 234/255, green: 46/255, blue: 111/255, alpha: 1).cgColor
        outlineStrokeLayer.lineWidth = 20
        outlineStrokeLayer.fillColor = UIColor.clear.cgColor
        outlineStrokeLayer.lineCap = CAShapeLayerLineCap.round
        outlineStrokeLayer.strokeEnd = 0
        outlineStrokeLayer.position = view.center
        outlineStrokeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        view.layer.addSublayer(outlineStrokeLayer)
    }
    
    func drawTimerLayer( ){
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 120, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        timerInsideStrokeLayer.path = circularPath.cgPath
        timerInsideStrokeLayer.strokeColor = UIColor(red: 234/255, green: 120/255, blue: 47/255, alpha: 1).cgColor
        timerInsideStrokeLayer.lineWidth = 10
        timerInsideStrokeLayer.fillColor = UIColor.clear.cgColor
        timerInsideStrokeLayer.lineCap = CAShapeLayerLineCap.round
        timerInsideStrokeLayer.strokeEnd = 0
        timerInsideStrokeLayer.position = view.center
        timerInsideStrokeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        self.view.layer.addSublayer(timerInsideStrokeLayer)
    }
    
    func drawTrackLayer() {
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor(red: 56/255, green: 25/255, blue: 49/255, alpha: 1).cgColor
        trackLayer.lineWidth = 20
        trackLayer.fillColor = UIColor.black.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.position = view.center
        view.layer.addSublayer(trackLayer)
    }
    
    func drawPulsingLayer() {
        let circularPathforPulsingLayer = UIBezierPath(arcCenter: .zero, radius: 125, startAngle: 0, endAngle:  2 * CGFloat.pi, clockwise: true)
        pulsingLayer.path = circularPathforPulsingLayer.cgPath
        pulsingLayer.strokeColor = UIColor.clear.cgColor
        pulsingLayer.fillColor = UIColor(red: 86/255, green: 30/255, blue: 63/255, alpha: 1).cgColor
        pulsingLayer.lineCap = CAShapeLayerLineCap.round
        pulsingLayer.position = view.center
        view.layer.addSublayer(pulsingLayer)
    }
    
    func drawCurrentWorkOutLayer() {
        currentWorkOutLabel.font = UIFont.boldSystemFont(ofSize: 26)
        currentWorkOutLabel.textColor = .white
        currentWorkOutLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        currentWorkOutLabel.center = view.center
        currentWorkOutLabel.numberOfLines = 3
        view.addSubview(currentWorkOutLabel)
    }
    
    func drawNextWorkOutLabel() {
        nextWorkOutLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nextWorkOutLabel.textColor = .white
        nextWorkOutLabel.alpha = 0.3
        nextWorkOutLabel.numberOfLines = 2
        view.addSubview(nextWorkOutLabel)
    }

}
