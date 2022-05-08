//
//  AboutView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/04.
//
import CombineCocoa
import Combine
import UIKit.UIView

enum AboutViewAction {
    case dismiss
}

final class AboutView: UIView {
    
    private(set) lazy var dismissButton = UIBarButtonItem(image: UIImage(systemName: Constant.ButtonImage.xmark), style: .done, target: nil, action: nil)
    
    private let aboutLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Created by Uma Kim"
        lb.textColor = .white
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AboutViewAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        dismissButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.dismiss)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        backgroundColor = .black
        
        addSubview(aboutLabel)
        NSLayoutConstraint.activate([
            aboutLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            aboutLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
