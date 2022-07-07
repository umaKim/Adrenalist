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
        
        contentView.workoutListCollectionView.delegate = self
        contentView.workoutListCollectionView.dataSource = self
    }
    
    init(viewModel: FavoriteSetListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.title = viewModel.response.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavoriteSetListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.response.workouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutlistCollectionViewCell.identifier, for: indexPath) as? WorkoutlistCollectionViewCell
        else {return UICollectionViewCell() }
        cell.configure(with: viewModel.response.workouts[indexPath.item], mode: .complete)
        return cell
    }
}

extension FavoriteSetListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm =  WorkoutSetupViewModel(workout: viewModel.response.workouts[indexPath.item], type: .edit)
        let vc = WorkoutSetupViewController(viewModel: vm)
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
