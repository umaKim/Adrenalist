//
//  FavoriteDetailViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/26.
//

import Combine
import UIKit

class FavoriteDetailViewController: UIViewController {
    private let contentView = FavoriteDetailView()
    
    private var viewModel: FavoriteDetailViewModel
    
    private var cancellables: Set<AnyCancellable>
    
    init(viewModel: FavoriteDetailViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
        
        title = "Favorite Set"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
        
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
        
        bind()
        setupNavBar()
    }
    
    private func bind() {
        contentView.actionPublisher.sink { action in
            switch action {
            case .dismiss:
                self.dismiss(animated: true)
                
            case .add:
                break
            }
        }
        .store(in: &cancellables)
        
        viewModel.notifyPublisher.sink { noti in
            switch noti {
            case .reload:
                self.contentView.collectionView.reloadData()
            }
        }
        .store(in: &cancellables)
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItems = [contentView.backButton]
        navigationItem.rightBarButtonItems = [contentView.addButton]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension FavoriteDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.favorites.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteDetailCollectionViewCell.identifier, for: indexPath) as? FavoriteDetailCollectionViewCell
        else {return UICollectionViewCell() }
        cell.configure(with: viewModel.favorites[indexPath.item])
        return cell
    }
}

extension FavoriteDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm = FavoriteSetListViewModel(with: viewModel.favorites[indexPath.item])
        let vc = FavoriteSetListViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.bounds.width - 32, height: 78)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 16, right: 16)
    }
}

