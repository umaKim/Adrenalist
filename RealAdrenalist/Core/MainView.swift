//
//  MainView.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2022/04/26.
//

import UIKit.UIView

final class MainView: UIView {
    private(set) var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(SettingCollectionViewCell.self, forCellWithReuseIdentifier: SettingCollectionViewCell.identifier)
        cv.register(WorkoutCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutCollectionViewCell.identifier)
        cv.register(WorkoutHistoryCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutHistoryCollectionViewCell.identifier)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = false
        return cv
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
