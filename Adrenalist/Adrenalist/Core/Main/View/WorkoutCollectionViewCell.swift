//
//  WorkoutCollectionViewCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import UIKit.UICollectionViewCell
import Combine

enum WorkoutCollectionViewCellAction {
    case setting
//    case workout
//    case calendar
}

final class WorkoutCollectionViewCell: UICollectionViewCell {
    static let identifier = "WorkoutCollectionViewCell"
    
    private(set) lazy var action = PassthroughSubject<WorkoutCollectionViewCellAction, Never>()
    
    private lazy var viewModel = WorkoutViewModel()
    private lazy var nav = UINavigationController(rootViewController: WorkoutViewController(viewModel: viewModel))
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        setupUI()
    }
    
    func configure() {
        
    }
    
    private func setupUI() {
        guard let myListView = nav.view else { return }
        contentView.addSubview(myListView)
        
        NSLayoutConstraint.activate([
            myListView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            myListView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            myListView.topAnchor.constraint(equalTo: contentView.topAnchor),
            myListView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        viewModel
            .transitionPublisher
            .sink {[weak self] trans in
                guard let self = self else { return }
                switch trans {
//                case .setting:
//                    self.action.send(.setting)
//                case .calendar:
//                    self.action.send(.calendar)
                case .workoutList:
                    self.action.send(.setting)
                }
            }
            .store(in: &cancellables)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
