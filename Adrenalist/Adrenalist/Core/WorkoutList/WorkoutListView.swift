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
    case addWorkoutButtonDidTap
    case edit
    case delete
}

final class WorkoutListView: UIView {
    
    private(set) lazy var upwardImageView = UIImageView(image: UIImage(systemName: Constant.Button.upArrow))
    private(set) lazy var updateButton = UIBarButtonItem(title: "",
                                                         image: UIImage(systemName: Constant.Button.editting),
                                                         menu: UIMenu(options: .displayInline,
                                                                      children: [edit, delete]))
    
    private lazy var edit = UIAction(title: "Update",
                                     handler: {[weak self] _ in
        self?.actionSubject.send(.edit)
    })
    
    private lazy var delete = UIAction(title: "Delete",
                                       handler: {[weak self] _ in
        self?.actionSubject.send(.delete)
    })
    
    private(set) lazy var addWorkoutButton = UIBarButtonItem(image: UIImage(systemName: Constant.Button.addWorkout), style: .done, target: nil, action: nil)
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutListViewAction, Never>()
    
    private(set) lazy var suggestedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.register(SuggestionListCell.self, forCellWithReuseIdentifier: SuggestionListCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private(set) lazy var workoutListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
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
            .sink {[weak self] _ in
                guard let self = self else {return }
                self.actionSubject.send(.addWorkoutButtonDidTap)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        backgroundColor = .black
        addSubview(suggestedCollectionView)
        addSubview(workoutListCollectionView)
        
        suggestedCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        workoutListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
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
