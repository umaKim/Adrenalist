//
//  MainViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import FloatingPanel
import Combine
import UIKit.UIViewController

final class MainViewController: UIViewController {
    
    private let contentView = MainView()
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
        
        
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .top, animated: false)
    }
    
    private func setupCollectionView() {
        contentView.collectionView.delegate     = self
        contentView.collectionView.dataSource   = self
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCollectionViewCell.identifier, for: indexPath) as? SettingCollectionViewCell else {return UICollectionViewCell()}
            cell.backgroundColor = .green
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutCollectionViewCell.identifier, for: indexPath) as? WorkoutCollectionViewCell else {return UICollectionViewCell()}
            cell.configure()
            
            cell
                .action
                .sink { action in
                    switch action {
                    case .setting:
                        self.scrollTo(index: 0)
                    case .calendar:
                        self.scrollTo(index: 2)
                    }
                }
                .store(in: &cancellables)
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutHistoryCollectionViewCell.identifier, for: indexPath) as? WorkoutHistoryCollectionViewCell else {return UICollectionViewCell()}
            cell.backgroundColor = .blue
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    private func scrollTo(index: Int) {
        contentView.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .top, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(view.frame.width)
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
}
