//
//  SettingViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//
import CombineCocoa
import Combine
import UIKit

final class SettingViewController: UIViewController {
    
    private let contentView = SettingView()
    private let viewModel: SettingViewModel
    
    private var cancellables: Set<AnyCancellable>
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
        
        navigationItem.leftBarButtonItems = [contentView.backButton]
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        bind()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
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

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.models[indexPath.row]
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if viewModel.models[indexPath.row] == "About" {
            let vc = AboutViewController()
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true)
        }
    }
}
