//
//  WorkoutHistoryView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import FSCalendar
import CombineCocoa
import Combine
import UIKit

final class WorkoutHistoryView: UIView {
    private(set) lazy var backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: nil, action: nil)
    private let calendar = FSCalendar()
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SettingViewAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    private(set) lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.sectionFooterHeight = 0
        tv.register(WorkoutHistoryHeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: WorkoutHistoryHeaderTableViewCell.identifier)
        tv.register(WorkoutHistoryTableViewCell.self, forCellReuseIdentifier: WorkoutHistoryTableViewCell.identifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
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
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
