//
//  WorkoutListView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

//import ScrollableDatepicker
import CombineCocoa
import Combine
import UIKit.UIView

enum WorkoutViewAction {
    case didTapSkip
    case didTapAction
    case back
}

final class WorkoutView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutViewAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    //MARK: - UI Objects
    private(set) lazy var backButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: nil, action: nil)
        bt.tintColor = .white
        
        return bt
    }()
    
    private let circularView = CircularView()
    
    private lazy var skipButton: AdrenalistTextRectangleButton = {
        let bt = AdrenalistTextRectangleButton(title: "SKIP", backgroundColor: .navyGray)
        bt.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.width/3.3).isActive = true
        bt.isHidden = true
        return bt
    }()
    
    private lazy var actionButton: AdrenalistTextRectangleButton = {
        let bt = AdrenalistTextRectangleButton(title: "NEXT")
//        bt.widthAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.width / 1.7).isActive = true
        bt.widthAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.width - 32).isActive = true
        return bt
    }()
    
    private lazy var finishButton: AdrenalistTextRectangleButton = {
       let bt = AdrenalistTextRectangleButton(title: "Finish")
        bt.widthAnchor.constraint(equalToConstant: UIScreen.main.width - 32).isActive = true
        return bt
    }()
    
    private lazy var currentWorkoutLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .white
        lb.numberOfLines = 4
        lb.font = .boldSystemFont(ofSize: 34)
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var nextWorkoutLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .brightGrey
        lb.numberOfLines = 2
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var resumeButtonStackView: UIStackView = {
        let bt = UIStackView(arrangedSubviews: [skipButton, actionButton])
        bt.axis = .horizontal
        bt.alignment = .fill
        bt.distribution = .fillProportionally
        bt.spacing = 8
        return bt
    }()
    
    //MARK: - Init
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Public Methods
extension WorkoutView {
    func updateCurrentWorkoutLabel(_ text: String) {
        self.currentWorkoutLabel.text = text
    }
    
    func updateNextWorkoutLabel(_ text: String) {
        self.nextWorkoutLabel.text = "\(text)"
    }
    
    func updatePulse(_ value: CGFloat) {
        circularView.animatePulse(value)
    }
    
    func updateOutline(_ value: CGFloat) {
        circularView.animateOutlineStroke(value)
    }
    
    func updateInterline(_ value: CGFloat) {
        circularView.animateInlineStroke(value)
    }
    
    func showNextButton() {
        self.skipButton.isHidden = false
        self.actionButton.isHidden = false
        
        self.finishButton.isHidden = true
    }
    
    func showFinishButton() {
        self.skipButton.isHidden = true
        self.actionButton.isHidden = true
        
        self.finishButton.isHidden = false
    }
}

//MARK: - Private Methods
extension WorkoutView {
    
    private func bind() {
        backButton
            .tapPublisher
            .sink {[weak self] in
                guard let self = self else { return }
                self.actionSubject.send(.back)
            }
            .store(in: &cancellables)
        
        actionButton
            .tapPublisher
            .sink {[weak self] in
                guard let self = self else { return }
                self.actionSubject.send(.didTapAction)
            }
            .store(in: &cancellables)
        
        skipButton
            .tapPublisher
            .sink {[weak self] in
                guard let self = self else { return }
                self.actionSubject.send(.didTapSkip)
            }
            .store(in: &cancellables)
    }
    
}

//MARK: - Setup UI
extension WorkoutView {
    private func setupUI() {
        backgroundColor = .black
        
        [circularView,
         currentWorkoutLabel,
         nextWorkoutLabel,
         resumeButtonStackView]
            .forEach { uv in
                uv.translatesAutoresizingMaskIntoConstraints = false
                addSubview(uv)
            }
        
        NSLayoutConstraint.activate([
            circularView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circularView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -UIScreen.main.height/15),
            
            currentWorkoutLabel.centerXAnchor.constraint(equalTo: circularView.centerXAnchor),
            currentWorkoutLabel.centerYAnchor.constraint(equalTo: circularView.centerYAnchor),
            currentWorkoutLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.width/2),
            
            nextWorkoutLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextWorkoutLabel.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                      constant: UIScreen.main.height / 4),
            
            resumeButtonStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            resumeButtonStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
