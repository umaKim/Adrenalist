//
//  WorkoutListViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import Combine
import CombineCocoa
import UIKit.UIViewController

final class WorkoutViewController: UIViewController {
    
    private let contentView = WorkoutView()
    
    private let viewModel: WorkoutViewModel
    
    private var cancellables: Set<AnyCancellable>
    
    //MARK: - Init
    init(viewModel: WorkoutViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
        
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Bind
extension WorkoutViewController {
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                    
                case .back:
                    self.viewModel.backToWorkoutList()
                    
                case .didTapSkip:
                    self.viewModel.didTapSkip()
                    
                case .didTapAction:
                    self.viewModel.didTapNext()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink { noti in
                switch noti {
                    
                case .updateInlineStrokeEnd(let value):
                    self.contentView.updateInterline(value)
                    
                case .updatePulse(let value):
                    self.contentView.updatePulse(value)
                    
                case .updateOutlineStrokeEnd(let value):
                    self.contentView.updateOutline(value)
                    
                case .updateToCurrentWorkout(let currentWorkout):
                    self.contentView.updateCurrentWorkoutLabel(currentWorkout?.title ?? "")
                    
                case .updateNextWorkout(let nextWorkout):
                    self.contentView.updateNextWorkoutLabel(nextWorkout?.title ?? "")
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - Setup UI
extension WorkoutViewController {
    
    private func setupUI() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.tintColor = .pinkishRed
        navigationItem.leftBarButtonItems = [contentView.backButton]
    }
    
}
