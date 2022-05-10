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
    
    private lazy var titleTextfield = AdrenalistTextField(placeHolder: "Work out")
    
    private lazy var timerLabel: UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    private lazy var addButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("+", for: .normal)
        return bt
    }()
    
    private lazy var subtractButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("-", for: .normal)
        return bt
    }()
    
    private var timerSubject = CurrentValueSubject<Int, Never>(0)
    
    init() {
        self.cancellbales = .init()
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .blue
        
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
        titleTextfield
            .textPublisher
            .sink { [weak self] title in
                guard let self = self else {return }
                self.actionSubject.send(.title(title ?? ""))
            }
            .store(in: &cancellbales)
        
        addButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return }
                self.timerSubject.send(self.timerSubject.value + 10)
            }
            .store(in: &cancellbales)
        
        subtractButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return }
                self.timerSubject.send(self.timerSubject.value - 10)
            }
            .store(in: &cancellbales)
        
        timerSubject
            .compactMap({[weak self] in
                self?.actionSubject.send(.time(TimeInterval($0)))
                return "\($0)"
            })
            .assign(to: \.text,
                    on: timerLabel,
                    animation: .flip(direction: .top, duration: 0.5))
            .store(in: &cancellbales)
    }
    
    private func setupUI() {
        let buttonStackView = UIStackView(arrangedSubviews: [addButton, subtractButton])
        buttonStackView.distribution = .fill
        buttonStackView.alignment = .fill
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 6
        
        let verticalStackView = UIStackView(arrangedSubviews: [titleTextfield, timerLabel, buttonStackView])
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