//
//  FavoriteSetListView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/07/07.
//

import Combine
import UIKit

enum FavoriteSetListViewAction {
    case add
    case delete
    
    case bottomSheetDidTapDelete
    case bottomSheetDidTapCreateSet
}

class FavoriteSetListView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<FavoriteSetListViewAction, Never>()
    
    private(set) lazy var addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: nil, action: nil)
    private(set) lazy var deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: nil, action: nil)
    
    private(set) lazy var workoutListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.register(WorkoutlistCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutlistCollectionViewCell.identifier)
        cv.contentInset = .init(top: 0, left: 0, bottom: UIScreen.main.height/4, right: 0)
        return cv
    }()
    
    private lazy var bottomNavigationView = AdrenalistBottomNavigationBarView(configurator: .init(height: 110,
                                                                                                  backgroundColor: .lightDarkNavy))
    
    public func dismissBottomNavigationView() {
        self.bottomNavigationView.hideBottomNavigationView()
    }
    
    public func reload() {
        self.workoutListCollectionView.reloadData()
    }
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
        bind()
        setupUI()
    }
    
    private var cancellables: Set<AnyCancellable>
    
    private func bind() {
        addButton.tapPublisher.sink { _ in
            self.actionSubject.send(.add)
        }
        .store(in: &cancellables)
        
        deleteButton.tapPublisher.sink { _ in
            self.actionSubject.send(.delete)
        }
        .store(in: &cancellables)
        
        bottomNavigationView
            .actionPublisher
            .sink { action in
                switch action {
                case .delete:
                    self.actionSubject.send(.bottomSheetDidTapDelete)
                    
                case .cancel:
                    self.actionSubject.send(.bottomSheetDidTapCreateSet)
                    
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        workoutListCollectionView.backgroundColor = .darkNavy
        
        [workoutListCollectionView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        addSubview(bottomNavigationView)
        
        NSLayoutConstraint.activate([
            workoutListCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            workoutListCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            workoutListCollectionView.topAnchor.constraint(equalTo: topAnchor),
            workoutListCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
