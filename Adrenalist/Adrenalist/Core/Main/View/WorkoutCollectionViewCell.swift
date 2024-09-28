//
//  WorkoutCollectionViewCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import UIKit.UICollectionViewCell
import Combine

<<<<<<< Updated upstream
enum WorkoutCollectionViewCellAction {
    case setting
//    case workout
//    case calendar
=======
enum WorkoutListCollectionViewCellAction {
    case setting, workout ,calendar
>>>>>>> Stashed changes
}

final class WorkoutListCollectionViewCell: UICollectionViewCell {
    static let identifier = "WorkoutCollectionViewCell"
    
    private(set) lazy var action = PassthroughSubject<WorkoutListCollectionViewCellAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
    }
    
    func configure() {
        setupUI()
    }
    
    private func setupUI() {
<<<<<<< Updated upstream
        let viewModel = WorkoutViewModel()
        viewModel
            .transitionPublisher
            .sink { trans in
                switch trans {
=======
        let viewModel = WorkoutListViewModel()
//        viewModel
//            .transitionPublisher
//            .sink { trans in
//                switch trans {
>>>>>>> Stashed changes
//                case .setting:
//                    self.action.send(.setting)
//                case .calendar:
//                    self.action.send(.calendar)
<<<<<<< Updated upstream
                case .workoutList:
                    self.action.send(.setting)
                }
            }
            .store(in: &cancellables)
=======
//                }
//            }
//            .store(in: &cancellables)
>>>>>>> Stashed changes
        
        let nav = UINavigationController(rootViewController: WorkoutViewController(viewModel: viewModel))
        guard let myListView = nav.view else { return }
        contentView.addSubview(myListView)
        
        NSLayoutConstraint.activate([
            myListView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            myListView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            myListView.topAnchor.constraint(equalTo: contentView.topAnchor),
            myListView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
