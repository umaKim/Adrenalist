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
    case deleteStatus
    case deleteItems
    case cancelDeleteAction
}

class FavoriteDetailView: UIView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<FavoriteDetailViewAction, Never>()
    
    private(set) lazy var backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: nil, action: nil)
    private(set) lazy var addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: nil, action: nil)
    private(set) lazy var deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: nil, action: nil)
    
    private let minCellSpacing: CGFloat = 16.0
    private var maxCellWidth: CGFloat!
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = FlowLayout()
        layout.sectionInset = UIEdgeInsets(top: self.minCellSpacing, left: 2.0, bottom: self.minCellSpacing, right: 2.0)
        layout.minimumInteritemSpacing = self.minCellSpacing
        layout.minimumLineSpacing = 16.0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        cv.contentInset = .init(top: 0, left: 0, bottom: UIScreen.main.height/5, right: 0)
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
    
    private lazy var bottomNavigationView = AdrenalistBottomNavigationBarView(configurator: .init(height: 110,backgroundColor: .lightDarkNavy))
    
    private func bind() {
        backButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.actionSubject.send(.dismiss)
            }.store(in: &cancellables)
        
        addButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.actionSubject.send(.add)
            }
            .store(in: &cancellables)
        
        deleteButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.bottomNavigationView.show(.done)
                self.actionSubject.send(.deleteStatus)
            }
            .store(in: &cancellables)
        
        bottomNavigationView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                switch action {
                case .done:
                    self.actionSubject.send(.cancelDeleteAction)
                    
                default:
                    break
                }
            }
        .store(in: &cancellables)
    }
    
    private func setupUI() {
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .darkNavy
        
        [collectionView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        addSubview(bottomNavigationView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
