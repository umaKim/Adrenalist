//
//  WorkoutSetupViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/16.
//

import CombineCocoa
import Combine
import UIKit

protocol WorkoutSetupViewControllerDelegate: AnyObject {
    func workoutSetupDidTapDone(with models: [WorkoutModel], type: WorkoutSetupType)
    func workoutSetupDidTapCancel()
}

class WorkoutSetupViewController: UIViewController {
    
    private let contentView: WorkoutSetupView
    
    private let viewModel: WorkoutSetupViewModel
    
    private var cancellables: Set<AnyCancellable>
    
    weak var delegate: WorkoutSetupViewControllerDelegate?
    
    init(viewModel: WorkoutSetupViewModel) {
        self.viewModel = viewModel
        self.contentView = WorkoutSetupView(type: viewModel.type)
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
        
        self.title = viewModel.type.rawValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                    self.delegate?.workoutSetupDidTapCancel()
                    
                case .didTapDone:
                    self.viewModel.doneButtonDidTap()
                    
                case .titleDidChange(let text):
                    self.viewModel.setTitle(text)
                    
                case .repsDidChange(let text):
                    self.viewModel.setReps(text)
                    
                case .weightDidChange(let text):
                    self.viewModel.setWeight(text)
                    
                case .timeDidChange(let text):
                    self.viewModel.setTimer(text)
                    
                case .setDidChange(let text):
                    self.viewModel.setSet(text)
                    
                case .isFavorite(let isFavorite):
                    self.viewModel.setFavorite(isFavorite)
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .receive(on: RunLoop.main)
            .sink { noti in
                switch noti {
                case .doneButtonDidTap(models: let models, type: let type):
                    self.delegate?.workoutSetupDidTapDone(with: models, type: type)
                }
            }
            .store(in: &cancellables)
        
        contentView.setUpReceivedModel(model: viewModel.workout)
    }
    
    private func setupUI() {
        navigationItem.leftBarButtonItems = [contentView.cancelButton]
        navigationItem.rightBarButtonItems = [contentView.doneButton]
    }
}
