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
    
    private(set) lazy var calendarButton = UIBarButtonItem(image: UIImage(systemName: Constant.Button.calendar), style: .done, target: nil, action: nil)
    private(set) lazy var settingButton = UIBarButtonItem(image: UIImage(systemName: Constant.Button.setting), style: .done, target: nil, action: nil)
    
    private let circularView = CircularView()
    
    private var workoutLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        return lb
    }()
    
    private var weightLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        return lb
    }()
    
    var updateWorkout: Workout? {
        didSet {
            self.workoutLabel.text = updateWorkout?.title
            self.weightLabel.text = String(updateWorkout?.weight ?? 0)
        }
    }
    
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
//        addSubview(circularView)
//        circularView.translatesAutoresizingMaskIntoConstraints = false
//
        let labelStackView = UIStackView(arrangedSubviews: [workoutLabel, weightLabel])
        labelStackView.axis = .vertical
        labelStackView.distribution = .fill
        labelStackView.alignment = .center
        labelStackView.spacing = 6
        
        [circularView, labelStackView].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            circularView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circularView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
