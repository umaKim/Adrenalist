//
//  WorkoutHistoryViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import Combine
import UIKit

final class WorkoutHistoryViewController: UIViewController {
    
    private let contentView = WorkoutHistoryView()
    private let viewModel: WorkoutHistoryViewModel
    private var cancellables: Set<AnyCancellable>
    
    init(viewModel: WorkoutHistoryViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .red
        navigationItem.leftBarButtonItems = [contentView.backButton]
        
        bind()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {action in
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
