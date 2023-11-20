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
    case presentVC(UIViewController)
    case dismiss
    
    case push(UIViewController)
    case pop
}

final class WorkoutHistoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "WorkoutHistoryCollectionViewCell"
    
    private(set) lazy var action = PassthroughSubject<WorkoutHistoryCollectionViewCellAction, Never>()
    private lazy var viewModel = WorkoutListViewModel2()
    private lazy var nav = UINavigationController(rootViewController: WorkoutListViewController2(viewModel: viewModel))
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        setupUI()
    }
    
    func configure() {
        
    }
    
    private func setupUI() {
        
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
            .sink {[weak self] listen in
                guard let self = self else { return }
                switch listen {
                case .moveToCircularView:
                    self.action.send(.workout)
                    
                case .present(let vc):
                    self.action.send(.present(vc))
                    
                case .presentVC(let vc):
                    self.action.send(.presentVC(vc))
                    
                case .dismiss:
                    self.action.send(.dismiss)
                    
                case .push(let vc):
                    self.action.send(.push(vc))
                    
                case .pop:
                    self.action.send(.pop)
                }
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
