//
//  ItemSetupViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/02.
//

import CombineCocoa
import Combine
import UIKit

protocol ItemSetupViewControllerDelegate: AnyObject {
    func dismiss()
}

final class ItemSetupViewController: UIViewController {
    
    private let contentView = WorkoutSetupView()
    private let viewModel: ItemSetupViewModel
    
    private var cancellables: Set<AnyCancellable>
    
    weak var delegate: ItemSetupViewControllerDelegate?
    
    init(viewModel: ItemSetupViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
        
        bind()
        setupUI()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                case .confirm(let workout):
                    self.viewModel.confirm(for: workout)
                    self.delegate?.dismiss()
                    
                case .cancel:
                    self.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        view.addTapGestureToViewForKeyboardDismiss()
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
