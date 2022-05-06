//
//  SettingView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import Combine
import UIKit.UIView

enum SettingViewAction {
    case backButtonDidTap
}

final class SettingView: UIView {
    private(set) lazy var backButton = UIBarButtonItem(image: UIImage(systemName: Constant.Button.back), style: .done, target: nil, action: nil)
    
    private(set) lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.backgroundColor = .black
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SettingViewAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        backButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.actionSubject.send(.backButtonDidTap)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        backgroundColor = .black
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
