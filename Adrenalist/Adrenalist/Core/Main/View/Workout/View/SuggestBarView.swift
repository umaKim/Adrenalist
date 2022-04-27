//
//  SuggestBarView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import UIKit

final class SuggestBarView: UIView  {
    
    private lazy var sections = 10
    private lazy var itemsInSection = 2
    
    private lazy var data: [[CellModel]] = {
        var count = 0
        return (0 ..< sections).map { _ in
            return (0 ..< itemsInSection).map { _ -> CellModel in
                count += 1
                return .simple(text: "cell \(count)")
            }
        }
    }()
    
    private(set) lazy var suggestedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(WorkoutListCell.self, forCellWithReuseIdentifier: WorkoutListCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.dragDelegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .blue
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(suggestedCollectionView)
        
        NSLayoutConstraint.activate([
            suggestedCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            suggestedCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            suggestedCollectionView.topAnchor.constraint(equalTo: topAnchor),
            suggestedCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum CellModel {
    case simple(text: String)
    case availableToDropAtEnd
}

extension SuggestBarView: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        []
    }
}

extension SuggestBarView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutListCell.identifier, for: indexPath) as? WorkoutListCell else {return UICollectionViewCell()}
        cell.backgroundColor = .green
        return cell
    }
}

extension SuggestBarView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.bounds.width / 4, height: 40)
    }
}
