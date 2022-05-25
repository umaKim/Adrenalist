//
//  TimerSetupView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/05.
//
import Combine
import UIKit.UIView

enum TimerSetupViewAction {
    case title(String)
    case time(Double)
}

final class TimerSetupView: UIView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<TimerSetupViewAction, Never>()
    
    private var cancellbales: Set<AnyCancellable>
    
    private lazy var timerLabel: UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    private lazy var stepper: UIStepper = {
       let st = UIStepper()
        st.minimumValue = 0
        st.stepValue = 10
        return st
    }()
    
    init() {
        self.cancellbales = .init()
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        bind()
        setupUI()
    }
    
    func updateUI(with item: Item?) {
        guard
            let timer = item?.timer
        else { return }

        timerLabel.text = "\(timer) sec"
    }
    
    private func bind() {
        stepper
            .valuePublisher
            .compactMap({"\(Int($0)) sec"})
            .assign(to: \.text, on: timerLabel, animation: .flip(direction: .top, duration: 0.5))
            .store(in: &cancellbales)
        
        stepper
            .valuePublisher
            .sink {[weak self] value in
                self?.actionSubject.send(.time(value))
            }
            .store(in: &cancellbales)
    }
    
    private func setupUI() {
        let verticalStackView = UIStackView(arrangedSubviews: [timerLabel, stepper])
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .center
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 6
        
        addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
