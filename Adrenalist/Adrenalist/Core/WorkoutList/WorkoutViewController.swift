//
//  WorkoutListViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import FloatingPanel
import Combine
import CombineCocoa
import UIKit.UIViewController

final class WorkoutListViewController: UIViewController {
    
    private let contentView = WorkoutListView()
    
    private let viewModel: WorkoutListViewModel
    
    private var cancellables: Set<AnyCancellable>
    
    init(viewModel: WorkoutListViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
        
        bind()
        setupUI()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                case .didTapAdd:
                    print("didTapAdd")
                    let vc = UINavigationController(rootViewController: WorkoutSetupViewController())
                    vc.modalPresentationStyle = .pageSheet
                    self.present(vc, animated: true)
                    
                case .didTapEdit:
                    print("didTapEdit")
                    
                case .titleCalendarDidTap(_):
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.calendarView.setDates
        contentView.calendarView.initialUISetup()
    }
    
    private func setupUI() {
        contentView.workoutlistCollectionView.delegate = self
        contentView.workoutlistCollectionView.dataSource = self
        contentView.favoritesCollectionView.dataSource = self
        contentView.favoritesCollectionView.delegate = self
        
        navigationItem.titleView = contentView.calendarTitleButton
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.tintColor = .pinkishRed
        navigationItem.leftBarButtonItems   = [contentView.editButton]
        navigationItem.rightBarButtonItems  = [contentView.addButton]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WorkoutListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectionView DidTap")
    }
}

extension WorkoutListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == contentView.favoritesCollectionView ? viewModel.favorites.count : viewModel.workouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == contentView.favoritesCollectionView {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier,
                                                              for: indexPath) as? FavoriteCollectionViewCell
            else { return UICollectionViewCell() }
            cell.configure(with: viewModel.favorites[indexPath.item])
            return cell
            
        } else if collectionView == contentView.workoutlistCollectionView {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutlistCollectionViewCell.identifier,
                                                              for: indexPath) as? WorkoutlistCollectionViewCell
            else { return UICollectionViewCell() }
            cell.configure(with: viewModel.workouts[indexPath.item])
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension WorkoutListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == contentView.favoritesCollectionView {
            
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier,
                                                              for: indexPath) as? FavoriteCollectionViewCell
            else { return .zero }
            
            let width = cell.calculateCellWidth(text: viewModel.favorites[indexPath.row].title)
            return CGSize(width: width, height: 39)
            
        } else if collectionView == contentView.workoutlistCollectionView {
            return .init(width: UIScreen.main.bounds.width - 32, height: 78)
        }
        
        return .init(width: 0, height: 0)
    }
}
