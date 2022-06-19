//
//  AdrenalistBottomSheet.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/19.
//

import UIKit.UIView

class AdrenalistBottomSheet: UIView {
    
    private let bottomSheetHeight: CGFloat
    
    func show() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.frame.origin = .init(x: 0,
                                      y: UIScreen.main.bounds.height - self.bottomSheetHeight)
        } completion: { _ in }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.frame.origin = .init(x: 0,
                                      y: UIScreen.main.bounds.height)
        } completion: { _ in }
    }
    
    private lazy var headerView: UIView = {
       let uv = UIView()
        uv.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return uv
    }()
    
    init(with vc: UIViewController, height: CGFloat) {
        self.bottomSheetHeight = height
        super.init(frame: .init(x: 0,
                                y: UIScreen.main.height,
                                width: UIScreen.main.width,
                                height: height))
        
        guard let vcView = vc.view else {return }
        
        [headerView, vcView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        backgroundColor = .red
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            vc.view.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            vc.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            
//            vc.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        ])
        
//        let dragGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
//        addGestureRecognizer(dragGestureRecognizer)
        
        let v = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        v.direction = .down
        
        addGestureRecognizer(v)
    }
    
    private var initialCenter: CGPoint = .zero
    
    @objc private func swipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.state {
        case .began:
            print("began")
            break
        case .changed:
            print("changed")
            break
        case .ended:
            print("ended")
            break
        case .possible:
            print("possible")
            break
        case .cancelled:
            print("cancelled")
            break
        case .failed:
            print("failed")
            break
        @unknown default:
            break
        }
    }
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        self.center = sender.location(in: self)
        
        switch sender.state {
        case .began:
            print("began")
            self.initialCenter = self.center
            
        case .changed:
            print("changed")
            let translation = sender.translation(in: self)

            self.center = CGPoint(x: initialCenter.x + translation.x,
                                                 y: initialCenter.y + translation.y)
            
            
        case .ended:
            print("ended")
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
