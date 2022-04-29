//
//  WorkoutView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import CombineCocoa
import Combine
import UIKit.UIView

enum WorkoutViewAction {
    case doubleTap
    case didTapCalendar
    case didTapSetting
}

final class WorkoutView: UIView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutViewAction, Never>()
    
    private(set) lazy var calendarButton = UIBarButtonItem(image: UIImage(systemName: "calendar.circle"), style: .done, target: self, action: nil)
    private(set) lazy var settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .done, target: self, action: nil)
    
    private let circularView = CircularView()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        calendarButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.actionSubject.send(.didTapCalendar)
            }
            .store(in: &cancellables)
        
        settingButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.actionSubject.send(.didTapSetting)
            }
            .store(in: &cancellables)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func didTap() {
        self.actionSubject.send(.doubleTap)
    }
    
    public func updatePulse(_ duration: CFTimeInterval) {
        circularView.animatePulse(duration)
    }
    
    public func updateOutline(_ strokeEnd: CGFloat) {
        circularView.animateOutlineStroke(strokeEnd)
    }
    
    private func setupUI() {
        backgroundColor = .black
        addSubview(circularView)
        circularView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circularView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circularView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
