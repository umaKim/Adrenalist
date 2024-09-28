//
//  WorkoutHistoryCollectionViewCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import Combine
import UIKit.UICollectionViewCell

enum WorkoutHistoryCollectionViewCellAction {
    case workout
    case present(UINavigationController)
    case dismiss
    
    case push(UIViewController)
    case pop
}

final class WorkoutHistoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "WorkoutHistoryCollectionViewCell"
    
    private(set) lazy var action = PassthroughSubject<WorkoutHistoryCollectionViewCellAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        setupUI()
    }
    
    func configure() {
        
    }
    
    private func setupUI() {
<<<<<<< Updated upstream
        let viewModel = WorkoutListViewModel2()
        let vc = WorkoutListViewController2(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
        
        guard let myView = nav.view else {return }
        contentView.addSubview(myView)
        
        NSLayoutConstraint.activate([
            myView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            myView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            myView.topAnchor.constraint(equalTo: contentView.topAnchor),
            myView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        viewModel
            .listenerPublisher
            .sink { listen in
                switch listen {
                case .moveToCircularView:
                    self.action.send(.workout)
                    
                case .present(let vc):
                    self.action.send(.present(vc))
                    
                case .dismiss:
                    self.action.send(.dismiss)
                    
                case .push(let vc):
                    self.action.send(.push(vc))
                    
                case .pop:
                    self.action.send(.pop)
                }
            }
            .store(in: &cancellables)
=======
//        let viewModel = WorkoutHistoryViewModel()
//        viewModel
//            .transitionPublisher
//            .sink { trans in
//                switch trans {
//                case .workout:
//                    self.action.send(.workout)
//                }
//            }
//            .store(in: &cancellables)
//
//        let vc =  WorkoutHistoryViewController(viewModel: viewModel)
//        let nav = UINavigationController(rootViewController: vc)
//        guard let myHistoryView = nav.view else { return }
//        contentView.addSubview(myHistoryView)
//
//        NSLayoutConstraint.activate([
//            myHistoryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            myHistoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            myHistoryView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            myHistoryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//        ])
>>>>>>> Stashed changes
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
