//
//  ItemSetupViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/02.
//

import CombineCocoa
import Combine
import UIKit



final class ItemSetupViewController: UIViewController {
    
    private let contentView = WorkoutSetupView()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupUI()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                case .confirm:
                    self.dismiss(animated: true)
                    
                case .cancel:
                    self.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
        
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
