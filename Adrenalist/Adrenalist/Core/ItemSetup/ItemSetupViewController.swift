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
    
    private let contentView = ItemSetupView()
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
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return }
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
        view.backgroundColor = .black.withAlphaComponent(0.7)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
        view.layer.cornerRadius = 12
        
        
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
