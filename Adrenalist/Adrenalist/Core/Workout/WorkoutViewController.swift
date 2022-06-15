//
//  WorkoutListViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import FloatingPanel
import Combine
import CombineCocoa
import UIKit.UIViewController

final class WorkoutListViewController: UIViewController {
    
    private let contentView = WorkoutListView()
    
    private let viewModel: WorkoutListViewModel
    
    private var cancellables: Set<AnyCancellable>
    
    init(viewModel: WorkoutListViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
        
        
        bind()
        setupUI()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return }
                switch action {
                case .didTapCalendar:
                    //                    self.viewModel.didTapCalendar()
                    break
                    
                case .didTapSetting:
                    //                    self.viewModel.didTapSetting()
                    break
                    
                case .doubleTap:
                    //                    self.viewModel.didDoubleTap()
                    break
                    
                case .didTap(let date):
                    print(date)
                    
                case .didTapAdd:
                    print("didTapAdd")
                    
                case .didTapEdit:
                    print("didTapEdit")
                    
                case .titleCalendarDidTap(_):
                    break
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink { listen in
                switch listen {
                case .updateInlineStrokeEnd(let value):
                    self.contentView.updateInline(value)
                    
                case .updateOutlineStrokeEnd(let value):
                    self.contentView.updateOutline(value)
                    
                case .updatePulse(let value):
                    self.contentView.updatePulse(value)
                    
                case .updateToCurrentWorkout(let workout):
                    self.contentView.updateWorkout = workout
                    
                case .updateNextWorkout(let nextWorkout):
                    self.contentView.nextWorkout = nextWorkout
                }
            }
            .store(in: &cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.calendarView.setDates
        contentView.calendarView.initialUISetup()
    }
    
    private func setupUI() {
        contentView.workoutlistCollectionView.delegate = self
        contentView.workoutlistCollectionView.dataSource = self
        contentView.favoritesCollectionView.dataSource = self
        contentView.favoritesCollectionView.delegate = self
        
        navigationItem.titleView = contentView.calendarTitleButton
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.tintColor = .pinkishRed
        navigationItem.leftBarButtonItems   = [contentView.editButton]
        navigationItem.rightBarButtonItems  = [contentView.addButton]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WorkoutListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == contentView.favoritesCollectionView ? viewModel.favorites.count : viewModel.workouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == contentView.favoritesCollectionView {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier,
                                                              for: indexPath) as? FavoriteCollectionViewCell
            else { return UICollectionViewCell() }
            cell.configure(with: viewModel.favorites[indexPath.item])
            return cell
            
        } else if collectionView == contentView.workoutlistCollectionView {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutlistCollectionViewCell.identifier,
                                                              for: indexPath) as? WorkoutlistCollectionViewCell
            else { return UICollectionViewCell() }
            cell.configure(with: viewModel.workouts[indexPath.item])
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension WorkoutListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == contentView.favoritesCollectionView {
            
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier,
                                                              for: indexPath) as? FavoriteCollectionViewCell
            else { return .zero }
            
            let width = cell.calculateCellWidth(text: viewModel.favorites[indexPath.row].title)
            return CGSize(width: width, height: 39)
            
        } else if collectionView == contentView.workoutlistCollectionView {
            return .init(width: UIScreen.main.bounds.width - 32, height: 78)
        }
        
        return .init(width: 0, height: 0)
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
