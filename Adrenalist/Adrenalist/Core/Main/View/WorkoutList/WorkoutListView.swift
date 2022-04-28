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
    private(set) lazy var edittingButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .done, target: nil, action: nil)
    private(set) lazy var addWorkoutButton = UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .done, target: nil, action: nil)
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WorkoutListViewAction, Never>()
    
    private(set) lazy var suggestBarView: SuggestBarView = SuggestBarView()
    
    private(set) lazy var collectionView: UICollectionView = {
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
    }
    
    private func bind() {
        addWorkoutButton
            .tapPublisher
            .sink { _ in
                self.actionSubject.send(.addWorkoutButtonDidTap)
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
