//
//  WorkoutListView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//

import Combine
import CombineCocoa
import UIKit

enum WorkoutListViewAction {
    case edittingButtonDidTap
    case addWorkoutButtonDidTap
}

final class WorkoutListView: UIView {
    private(set) lazy var edittingButton = UIBarButtonItem(image: UIImage(systemName: Constant.Button.editting), style: .done, target: nil, action: nil)
    private(set) lazy var addWorkoutButton = UIBarButtonItem(image: UIImage(systemName: Constant.Button.addWorkout), style: .done, target: nil, action: nil)
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutListViewAction, Never>()
    
    private(set) lazy var suggestedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(SuggestionListCell.self, forCellWithReuseIdentifier: SuggestionListCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private(set) lazy var workoutListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(WorkoutListCell.self, forCellWithReuseIdentifier: WorkoutListCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        bind()
        setupUI()
    }
    
    private func bind() {
        addWorkoutButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.addWorkoutButtonDidTap)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        addSubview(suggestedCollectionView)
        addSubview(workoutListCollectionView)
        
        NSLayoutConstraint.activate([
            suggestedCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            suggestedCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            suggestedCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            suggestedCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            workoutListCollectionView.topAnchor.constraint(equalTo: suggestedCollectionView.bottomAnchor),
            workoutListCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            workoutListCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            workoutListCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
