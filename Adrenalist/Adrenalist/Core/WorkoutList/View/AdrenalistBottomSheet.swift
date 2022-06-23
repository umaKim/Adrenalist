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
                                y: UIScreen.main.bounds.height,
                                width: UIScreen.main.bounds.width,
                                height: height))
        
        guard let vcView = vc.view else { return }
        
        [headerView,
         vcView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        backgroundColor = .darkNavy
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            vc.view.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            vc.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        addGestureRecognizer(viewPan)
    }
    
    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: self)
        let velocity = panGestureRecognizer.velocity(in: self)
        
        switch panGestureRecognizer.state {
            
        case .began:
            print("began: \(translation.y)")
            break
            
        case .changed:
            //            if 50 < translation.y {
            
            //            } else
            if translation.y > 0 {
                print("changed \(translation.y)")
                self.transform = .init(translationX: 0, y: translation.y)
            }
        case .ended:
            print("ended \(translation.y)")
            if translation.y > 200 || velocity.y > 1500 {
                self.hide()
            } else {
                UIView.animate(withDuration: 0.2) {
                    //                    self.transform = .init(translationX: 0, y: 0)
                    //                    self.transform = .init(translationX: 0, y: UIScreen.main.height - self.bottomSheetHeight)
                    self.show()
                }
                
            }
        default: break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
