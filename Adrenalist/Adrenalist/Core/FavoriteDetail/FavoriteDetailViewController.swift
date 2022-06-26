//
//  FavoriteDetailViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/26.
//

import Combine
import UIKit

class FavoriteDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    private let contentView = FavoriteDetailView()
    
    private var cancellables: Set<AnyCancellable>
    
    init(viewModel: FavoriteDetailViewModel) {
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        bind()
        setupNavBar()
    }
    
    private func bind() {
        contentView.actionPublisher.sink { action in
            switch action {
            case .dismiss:
                self.navigationController?.popViewController(animated: true)
            }
        }
        .store(in: &cancellables)
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItems = [contentView.backButton]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
