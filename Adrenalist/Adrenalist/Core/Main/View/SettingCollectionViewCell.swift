//
//  SettingCollectionViewCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import Combine

import UIKit.UICollectionViewCell

enum SettingCollectionViewCellAction {
    case workout
}

final class SettingCollectionViewCell: UICollectionViewCell {
    static let identifier = "SettingCollectionViewCell"
    
    private(set) lazy var action = PassthroughSubject<SettingCollectionViewCellAction, Never>()
    private var cancellables: Set<AnyCancellable>
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
    }
    
    func configure() {
        setupUI()
    }
    
    private func setupUI() {
        let viewModel = SettingViewModel()
        viewModel
            .transitionPublisher
            .sink {[weak self] trans in
                switch trans {
                case .workout:
                    self?.action.send(.workout)
                }
            }
            .store(in: &cancellables)
        
        let vc = SettingViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
        guard let settingView = nav.view else { return }
        
        contentView.addSubview(settingView)
        
        NSLayoutConstraint.activate([
            settingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            settingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            settingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            settingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
