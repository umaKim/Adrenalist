//
//  WorkoutListViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//

import UIKit
import Combine

enum WorkoutListViewModelListener {
    case reloadWorkouts
    case reloadSuggestions
    
//    case addWorkout
//    case addSuggestion
}

final class WorkoutListViewModel  {
    
    private(set) lazy var listenerPublisher = listenerSubject.eraseToAnyPublisher()
    private let listenerSubject = PassthroughSubject<WorkoutListViewModelListener, Never>()
    
    private(set) lazy var suggestions: [Workout] = []
    private(set) lazy var workouts: [Workout] = []
    
    private var cancellables: Set<AnyCancellable>
    
    private let workoutManager = WorkoutManager.shared
    
    init() {
        self.cancellables = .init()
        bind()
    }
    
    private func bind() {
        workoutManager
            .$workOutToDos
            .sink { workouts in
                self.workouts = workouts
                self.listenerSubject.send(.reloadWorkouts)
            }
            .store(in: &cancellables)
        
        workoutManager
            .$suggestions
            .sink { suggestions in
                self.suggestions = suggestions
                self.listenerSubject.send(.reloadSuggestions)
            }
            .store(in: &cancellables)
    }
    
    func didTapCell(at index: Int) {
        workouts[index].isDone.toggle()
        updateWorkoutToDo()
    }
    
    //MARK: - Private Methods
    private func updateWorkoutToDo() {
        workoutManager.updateWorkoutToDos(workouts)
    }
    
    private func updateSuggestions() {
        workoutManager.updateSuggestions(suggestions)
    }
    
    /// This method moves a cell from source indexPath to destination indexPath within the same collection view. It works for only 1 item. If multiple items selected, no reordering happens.
    ///
    /// - Parameters:
    ///   - coordinator: coordinator obtained from performDropWith: UICollectionViewDropDelegate method
    ///   - destinationIndexPath: indexpath of the collection view where the user drops the element
    ///   - collectionView: collectionView in which reordering needs to be done.
    func reorderItems(coordinator: UICollectionViewDropCoordinator,
                      destinationIndexPath: IndexPath,
                      collectionView: UICollectionView,
                      currentCollectionView: UICollectionView
    ) {
        let items = coordinator.items
        if items.count == 1,
           let item = items.first,
           let sourceIndexPath = item.sourceIndexPath {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0) {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
                if collectionView === currentCollectionView {
                    self.workouts.remove(at: sourceIndexPath.row)
                    self.workouts.insert(item.dragItem.localObject as! Workout, at: dIndexPath.row)
                    self.updateWorkoutToDo()
                } else {
                    self.suggestions.remove(at: sourceIndexPath.row)
                    self.suggestions.insert(item.dragItem.localObject as! Workout, at: dIndexPath.row)
                    self.updateSuggestions()
                }
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
    }
    
    /// This method copies a cell from source indexPath in 1st collection view to destination indexPath in 2nd collection view. It works for multiple items.
    ///
    /// - Parameters:
    ///   - coordinator: coordinator obtained from performDropWith: UICollectionViewDropDelegate method
    ///   - destinationIndexPath: indexpath of the collection view where the user drops the element
    ///   - collectionView: collectionView in which reordering needs to be done.
    func copyItems(coordinator: UICollectionViewDropCoordinator,
                   destinationIndexPath: IndexPath,
                   collectionView: UICollectionView,
                   currentCollectionView: UICollectionView
    ) {
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                if collectionView === currentCollectionView {
                    self.workouts.insert(item.dragItem.localObject as! Workout, at: indexPath.row)
                    self.updateWorkoutToDo()
                } else {
                    self.suggestions.insert(item.dragItem.localObject as! Workout, at: indexPath.row)
                    self.updateSuggestions()
                }
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        })
    }
}
