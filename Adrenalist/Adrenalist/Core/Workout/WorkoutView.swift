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
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 42, weight: .heavy)
        return lb
    }()
    
    private var nextLabel:  UILabel = {
        let lb = UILabel()
        lb.textColor = .systemGray3
        lb.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        return lb
    }()
    
    private var repsLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        return lb
    }()
    
    private var weightLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        return lb
    }()
    
    var updateWorkout: Item? {
        didSet {
            guard let updateWorkout = updateWorkout else { return }
            self.workoutLabel.text = updateWorkout.title
            self.repsLabel.text = "\(updateWorkout.reps) Reps"
            self.weightLabel.text = "\(updateWorkout.weight) Kg"
        }
    }
    
    var nextWorkout: Item? {
        didSet{
            self.nextLabel.text = nextWorkout?.title
        }
    }
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
    
    public func updateInline(_ strokeEnd: CGFloat) {
        circularView.animateInlineStroke(strokeEnd)
    }
    
    private func setupUI() {
        backgroundColor = .black
        
        let labelStackView2 = UIStackView(arrangedSubviews: [repsLabel, weightLabel])
        labelStackView2.axis = .vertical
        labelStackView2.distribution = .fill
        labelStackView2.alignment = .center
        labelStackView2.spacing = 12
        
        [circularView, workoutLabel, nextLabel, labelStackView2].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            circularView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circularView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            workoutLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            workoutLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            nextLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextLabel.topAnchor.constraint(equalTo: workoutLabel.bottomAnchor, constant: frame.height / 13),
            
            labelStackView2.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelStackView2.topAnchor.constraint(equalTo: centerYAnchor, constant: frame.height / 3.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
