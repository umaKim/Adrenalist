//
//  FavoriteDetailViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/26.
//

import Combine
import UIKit

protocol FavoriteDetailViewControllerDelegate: AnyObject {
    func favoriteDetailViewControllerDidTapDismiss()
}

class FavoriteDetailViewController: UIViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, WorkoutResponse>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, WorkoutResponse>
    
    enum Section { case main }
    
    private var dataSource: DataSource?
    
    private let contentView = FavoriteDetailView()
    
    private var viewModel: FavoriteDetailViewModel
    
    weak var delegate: FavoriteDetailViewControllerDelegate?
    
    private var cancellables: Set<AnyCancellable>
    
    init(viewModel: FavoriteDetailViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
        
        title = "Favorite Sets"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
        
        contentView.collectionView.delegate = self
//        contentView.collectionView.dataSource = self
        
        configureDataSource()
        updateSections()
        
        bind()
        setupNavBar()
    }
    
    private func bind() {
        contentView.actionPublisher.sink { action in
            switch action {
            case .dismiss:
//                self.dismiss(animated: true)
                self.delegate?.favoriteDetailViewControllerDidTapDismiss()
                
            case .add:
                let vc = SetupFavoriteSetViewController(SetupFavoriteSetViewModel(type: .add))
                vc.delegate = self
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true)
                
            case .deleteStatus:
                self.viewModel.status = .delete
                self.contentView.collectionView.reloadData()
                
            case .deleteItems:
                print("deleteItems")
                
            case .cancelDeleteAction:
                self.viewModel.status = .usual
                self.contentView.collectionView.reloadData()
            }
        }
        .store(in: &cancellables)
        
        viewModel.notifyPublisher.sink { noti in
            switch noti {
            case .reload:
                self.updateSections()
            }
        }
        .store(in: &cancellables)
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItems = [contentView.backButton]
        navigationItem.rightBarButtonItems = [contentView.deleteButton, contentView.addButton]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension FavoriteDetailViewController: SetupFavoriteSetViewControllerDelegate {
    func setupFavoriteDidTapDone() {
        self.dismiss(animated: true) {
        }
    }
    
    func setupFavoriteDidTapCancel() {
        self.dismiss(animated: true)
    }
}

extension FavoriteDetailViewController: FavoriteCollectionViewCellDelegate {
    func didTapDeleteButton(at index: Int) {
        viewModel.deleteItem(at: index)
    }
}

extension FavoriteDetailViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: contentView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier,
                                                              for: indexPath) as? FavoriteCollectionViewCell
            else {return UICollectionViewCell() }
            
            cell.status = self.viewModel.status
            cell.configure(with: self.viewModel.favorites[indexPath.item])
            cell.tag = indexPath.item
            cell.delegate = self
            return cell
        })
    }
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.favorites)
        dataSource?.apply(snapshot, animatingDifferences: true, completion: {
            self.contentView.collectionView.reloadData()
        })
    }
}

extension FavoriteDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.status {
        case .delete:
            self.didTapDeleteButton(at: indexPath.item)
            
        case .usual:
            let vm = SetupFavoriteSetViewModel(viewModel.favorites[indexPath.item], type: .edit)
            let vc = SetupFavoriteSetViewController(vm)
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let name = viewModel.favorites[indexPath.item].name else { return .init() }
        let width = name.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]).width + 48
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 16, right: 16)
    }
}

