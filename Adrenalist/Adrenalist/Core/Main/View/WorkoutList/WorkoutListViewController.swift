//
//  WorkoutList.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//

import Combine
import UIKit.UIViewController

final class WorkoutListViewController: UIViewController {
    
    private(set) lazy var contentView = WorkoutListView()
    
    private let viewModel: WorkoutListViewModel
    
    private var cancellables: Set<AnyCancellable>
    
    init(viewModel: WorkoutListViewModel) {
        self.cancellables = .init()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [contentView.addWorkoutButton]
        navigationItem.leftBarButtonItems = [contentView.edittingButton]
        
        bind()
        setupUI()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                case .addWorkoutButtonDidTap:
                    self.viewModel.didTapAddWorkoutButton()
                    self.contentView.collectionView.reloadData()
                    
                case .edittingButtonDidTap:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
        contentView.collectionView.dropDelegate = self
        
        view.addSubview(contentView.suggestBarView)
        view.addSubview(contentView.collectionView)
        
        NSLayoutConstraint.activate([
            contentView.suggestBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.suggestBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.suggestBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.suggestBarView.heightAnchor.constraint(equalToConstant: 60),
            
            contentView.collectionView.topAnchor.constraint(equalTo: contentView.suggestBarView.bottomAnchor),
            contentView.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WorkoutListViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
    }
}

extension WorkoutListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.workouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutListCell.identifier, for: indexPath) as? WorkoutListCell else {return UICollectionViewCell() }
        cell.configure(with: viewModel.workouts[indexPath.item])
        return cell
    }
}

extension WorkoutListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didTapCell(at: indexPath.item)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutListCell.identifier, for: indexPath) as? WorkoutListCell else {return}
        cell.update()
        contentView.collectionView.reloadItems(at: [indexPath])
    }
}

extension WorkoutListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.bounds.width - 50, height: 60)
    }
}
