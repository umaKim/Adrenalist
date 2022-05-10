//
//  WorkoutHistoryViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import Combine
import UIKit

final class WorkoutHistoryViewController: UIViewController {
    
    private let contentView = WorkoutHistoryView()
    private let viewModel: WorkoutHistoryViewModel
    private var cancellables: Set<AnyCancellable>
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    init(viewModel: WorkoutHistoryViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .pinkishRed
        navigationItem.leftBarButtonItems = [contentView.backButton]
        
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        
        bind()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {action in
                switch action {
                case .backButtonDidTap:
                    self.viewModel.didTapBackButton()
                }
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WorkoutHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutHistoryTableViewCell.identifier, for: indexPath) as? WorkoutHistoryTableViewCell else {return UITableViewCell()}
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UIScreen.main.bounds.height / 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let weatherTableViewHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: WorkoutHistoryHeaderTableViewCell.identifier) as? WorkoutHistoryHeaderTableViewCell else { return UIView() }
        return weatherTableViewHeaderView
    }
}

extension WorkoutHistoryViewController: UITableViewDelegate {
    
}