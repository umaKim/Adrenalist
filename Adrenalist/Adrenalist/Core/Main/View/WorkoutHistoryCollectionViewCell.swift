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
        let viewModel = WorkoutHistoryViewModel()
        viewModel
            .transitionPublisher
            .sink { trans in
                switch trans {
                case .workout:
                    self.action.send(.workout)
                }
            }
            .store(in: &cancellables)
        
        let vc =  WorkoutHistoryViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
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