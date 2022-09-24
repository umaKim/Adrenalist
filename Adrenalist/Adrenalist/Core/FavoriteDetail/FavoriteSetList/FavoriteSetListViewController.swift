//
//  FavoriteSetListViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/07/07.
//

import Combine
import UIKit

class FavoriteSetListViewController: UIViewController {
    
    private let contentView = FavoriteSetListView()
    
    private let viewModel: FavoriteSetListViewModel
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    init(viewModel: FavoriteSetListViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
        
        bind()
        
        self.title = viewModel.response.name
        
        navigationItem.rightBarButtonItems = [contentView.deleteButton, contentView.addButton]
    }
    
    private var cancellables: Set<AnyCancellable>
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                case .delete:
                    self.viewModel.changeMode(.delete)
                    
                case .add:
                    self.showWorkoutSetupViewController(for: .add, didSelect: WorkoutModel(title: "", isFavorite: false, isSelected: false, isDone: false))
                    
                case .bottomSheetDidTapDelete:
                    self.viewModel.delete()
                    break
                    
                case .bottomSheetDidTapCreateSet:
                    break
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink { noti in
                switch noti {
                case .reload:
                    self.contentView.reload()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showWorkoutSetupViewController(for type: WorkoutSetupType, didSelect model: WorkoutModel) {
        let vm = WorkoutSetupViewModel(workout: model, type: type)
        let vc = WorkoutSetupViewController(viewModel: vm)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.accessibilityNavigationStyle = .separate
        }
        
        present(nav, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavoriteSetListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.workoutList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutlistCollectionViewCell.identifier, for: indexPath) as? WorkoutlistCollectionViewCell
        else {return UICollectionViewCell() }
        cell.configure(with: viewModel.workoutList[indexPath.item], mode: viewModel.mode)
        cell.delegate = self
        cell.tag = indexPath.item
        return cell
    }
}

extension FavoriteSetListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm =  WorkoutSetupViewModel(workout: viewModel.workoutList[indexPath.item], type: .edit)
        let vc = WorkoutSetupViewController(viewModel: vm)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteSetListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.bounds.width - 32, height: 78)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 16, right: 16)
    }
}

extension FavoriteSetListViewController: WorkoutSetupViewControllerDelegate {
    func workoutSetupDidTapDone(with models: [WorkoutModel], type: WorkoutSetupType) {
//        self.viewModel.dismiss()
        self.dismiss(animated: true) {
            switch type {
            case .edit:
                self.viewModel.editWorkout(with: models.first)
            case .add:
                self.viewModel.setupWorkout(with: models)
            }
            
    //        self.contentView.suggestedCollectionView.reloadData()
            self.contentView.workoutListCollectionView.reloadData()
//            self.scrollToLast()
        }
    }
    
    func workoutSetupDidTapCancel() {
        dismiss(animated: true)
    }
}

extension FavoriteSetListViewController: WorkoutlistCollectionViewCellDelegate {
    func workoutlistCollectionViewCellDidTapComplete(_ isTapped: Bool, indexPathRow: Int) {
        viewModel.updateIsComplete(isTapped, at: indexPathRow)
    }
}
