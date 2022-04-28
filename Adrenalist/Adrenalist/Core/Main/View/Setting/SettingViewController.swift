//
//  SettingViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//
import CombineCocoa
import Combine
import UIKit

final class SettingViewController: UIViewController {
    
    private let contentView = SettingView()
    private let viewModel: SettingViewModel
    
    private var cancellables: Set<AnyCancellable>
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItems = [contentView.backButton]
        
        bind()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                case .backButtonDidTap:
                    self.viewModel.didTapBackButton()
                }
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
