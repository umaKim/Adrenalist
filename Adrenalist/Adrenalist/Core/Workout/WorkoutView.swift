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
    //    case changeOrder
    //    case postponeToTommorow
    //    case delete
    
    //    case didTapAdd
    //    case titleCalendarDidTap
    
    case didTapSkip
    case didTapAction
    case back
}

final class WorkoutView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutViewAction, Never>()
    
    //    private(set) lazy var backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: nil, action: nil)
    
    private(set) lazy var backButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: nil, action: nil)
        bt.tintColor = .white
        return bt
    }()
    
    private let circularView = CircularView()
    
    private lazy var skipButton: AdrenalistTextRectangleButton = {
        let bt = AdrenalistTextRectangleButton(title: "SKIP", backgroundColor: .navyGray)
        bt.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.width/3.3).isActive = true
        return bt
    }()
    
    private lazy var actionButton: AdrenalistTextRectangleButton = {
        let bt = AdrenalistTextRectangleButton(title: "NEXT")
        bt.widthAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.width / 1.7).isActive = true
        return bt
    }()
    
    private lazy var nextWorkoutLabel: UILabel = {
        let lb = UILabel()
        lb.text = "next"
        lb.textColor = .brightGrey
        return lb
    }()
    
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
    
    func updatePulse(_ value: CGFloat) {
        circularView.animatePulse(value)
    }
    
    func updateOutline(_ value: CGFloat) {
        circularView.animateOutlineStroke(value)
    }
    
    func updateInterline(_ value: CGFloat) {
        circularView.animateInlineStroke(value)
    }
    
    //MARK: - Private Methods
    private func bind() {
        backButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.back)
            }
            .store(in: &cancellables)
        
        actionButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.didTapAction)
            }
            .store(in: &cancellables)
        
        skipButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.didTapSkip)
            }
            .store(in: &cancellables)
    }
    
    private lazy var resumeButtonStackView: UIStackView = {
        let bt = UIStackView(arrangedSubviews: [skipButton, actionButton])
        bt.axis = .horizontal
        bt.alignment = .fill
        bt.distribution = .fillProportionally
        bt.spacing = 8
        return bt
    }()
    
    private func setupUI() {
        backgroundColor = .black
        
        [circularView,
         nextWorkoutLabel,
         resumeButtonStackView]
            .forEach { uv in
                uv.translatesAutoresizingMaskIntoConstraints = false
                addSubview(uv)
            }
        
        NSLayoutConstraint.activate([
            circularView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circularView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -UIScreen.main.height/15),
            
            nextWorkoutLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextWorkoutLabel.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                      constant: UIScreen.main.height / 4),
            
            resumeButtonStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            resumeButtonStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIButton {
    var setResume: Void {
        self.setTitle("RESUME", for: .normal)
        self.backgroundColor = .purpleBlue
        self.setTitleColor(.white, for: .normal)
    }
    
    var setNext: Void {
        self.setTitle("NEXT", for: .normal)
        self.backgroundColor = .purpleBlue
        self.setTitleColor(.white, for: .normal)
    }
    
    var setPause: Void {
        self.setTitle("PAUSE", for: .normal)
        self.backgroundColor = UIColor(red: 86/255, green: 98/255, blue: 255/255, alpha: 0.3)
        self.setTitleColor(.purpleBlue, for: .normal)
    }
}
