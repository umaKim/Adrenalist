//
//  WorkoutViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import FloatingPanel
import Combine
import CombineCocoa
import UIKit.UIViewController

final class WorkoutViewController: UIViewController {
    
    private let contentView = WorkoutView()
    
    private let viewModel: WorkoutViewModel
    
    private var cancellables: Set<AnyCancellable>
    
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
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return }
                switch action {
                case .didTapCalendar:
                    self.viewModel.didTapCalendar()
                    
                case .didTapSetting:
                    self.viewModel.didTapSetting()
                    
                case .doubleTap:
                    self.viewModel.didDoubleTap()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink { listen in
                switch listen {
                case .updateInlineStrokeEnd(let value):
                    self.contentView.updateInline(value)
                    
                case .updateOutlineStrokeEnd(let value):
                    self.contentView.updateOutline(value)
                    
                case .updatePulse(let value):
                    self.contentView.updatePulse(value)
                    
                case .updateToCurrentWorkout(let workout):
                    self.contentView.updateWorkout = workout
                    
                case .updateNextWorkout(let nextWorkout):
                    self.contentView.nextWorkout = nextWorkout
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        navigationController?.navigationBar.tintColor = .pinkishRed
        navigationItem.leftBarButtonItems   = [contentView.settingButton]
        navigationItem.rightBarButtonItems  = [contentView.calendarButton]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
