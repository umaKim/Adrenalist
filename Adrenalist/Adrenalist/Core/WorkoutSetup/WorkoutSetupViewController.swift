//
//  WorkoutSetupViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/16.
//

import CombineCocoa
import Combine
import UIKit

class WorkoutSetupViewController: UIViewController {
    
    private let contentView = WorkoutSetupView()
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func loadView() {
        super.loadView()
        
        view = contentView
        
        bind()
        setupUI()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                case .didTapCancel:
                    self.dismiss(animated: true)
                    
                case .didTapDone:
                    self.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        navigationItem.leftBarButtonItems = [contentView.cancelButton]
        navigationItem.rightBarButtonItems = [contentView.doneButton]
        
        view.backgroundColor = .red
    }
}
