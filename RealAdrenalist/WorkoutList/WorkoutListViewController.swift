//
//  WorkoutListViewController.swift
//  RealAdrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import UIKit.UIViewController

final class WorkoutListViewController: UIViewController {
    private let edittingButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .done, target: nil, action: nil)
    private let addWorkoutButton = UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .done, target: nil, action: nil)
    
    private(set) lazy var suggestBarView: SuggestBarView = SuggestBarView()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(WorkoutListCell.self, forCellWithReuseIdentifier: WorkoutListCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.dropDelegate = self
        return cv
    }()
    
    private let viewModel: WorkoutListViewModel
    
    init(viewModel: WorkoutListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItems = [addWorkoutButton]
        navigationItem.leftBarButtonItems = [edittingButton]
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(suggestBarView)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            suggestBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            suggestBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            suggestBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            suggestBarView.heightAnchor.constraint(equalToConstant: 60),
            
            collectionView.topAnchor.constraint(equalTo: suggestBarView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutListCell.identifier, for: indexPath) as? WorkoutListCell else {return UICollectionViewCell() }
        cell.backgroundColor = .red
        return cell
    }
}

extension WorkoutListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didTap cell")
    }
}

extension WorkoutListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.bounds.width - 50, height: 60)
    }
}
