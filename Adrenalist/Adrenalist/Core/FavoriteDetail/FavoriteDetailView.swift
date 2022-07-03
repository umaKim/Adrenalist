//
//  FavoriteDetailView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/26.
//
import CombineCocoa
import Combine
import UIKit

enum FavoriteDetailViewAction {
    case dismiss
    case add
}

class FavoriteDetailView: UIView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<FavoriteDetailViewAction, Never>()
    
    private(set) lazy var backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: nil, action: nil)
    private(set) lazy var addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: nil, action: nil)
    
    private(set) lazy var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(WorkoutlistCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutlistCollectionViewCell.identifier)
        return cv
    }()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        backButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.dismiss)
            }.store(in: &cancellables)
        
        addButton.tapPublisher.sink { _ in
            self.actionSubject.send(.add)
        }
        .store(in: &cancellables)
    }
    
    private func setupUI() {
        [collectionView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
