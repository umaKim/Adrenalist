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
        
        bind()
        setupTableView()
        setupNavigationBar()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                switch action {
                case .backButtonDidTap:
                    self.viewModel.didTapBackButton()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupTableView() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .pinkishRed
        navigationItem.leftBarButtonItems = [contentView.backButton]
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
        cell.backgroundColor = .systemGray2
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch viewModel.models[indexPath.row] {
        case "About":
            let vc = AboutViewController()
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true)
        default:
            break
        }
    }
}
