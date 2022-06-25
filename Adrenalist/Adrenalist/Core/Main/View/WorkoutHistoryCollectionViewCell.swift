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
}

final class WorkoutHistoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "WorkoutHistoryCollectionViewCell"
    
    private(set) lazy var action = PassthroughSubject<WorkoutHistoryCollectionViewCellAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
    }
    
    func configure() {
        setupUI()
    }
    
    private func setupUI() {
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
                    break
                    
                case .dismiss:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
