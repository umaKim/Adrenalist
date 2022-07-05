//
//  WorkoutListViewModel.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//

import FloatingPanel
import UIKit
import Combine

enum WorkoutListViewModel2Notification {
    case isWorkoutListEmpty(Bool)
    case isFavoriteEmpty(Bool)
    case reloadWorkoutList
    case reloadFavorites
    case calendarDidSelect(Date)
    case setDates(Int, Int, [Date])
}

enum WorkoutListCellMode: Codable {
    case reorder
    case psotpone
    case delete
    case complete
    case normal
}

enum UpdateMode {
    case edit
    case delete
    case createSet
}

enum WorkoutListViewModelListener {
    case present(UINavigationController)
    case dismiss
    
    case push(UIViewController)
    case pop
    
    case moveToCircularView
}

final class WorkoutListViewModel2  {
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<WorkoutListViewModel2Notification, Never>()
    
    private(set) lazy var listenerPublisher = listenerSubject.eraseToAnyPublisher()
    private let listenerSubject = PassthroughSubject<WorkoutListViewModelListener, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    private let favoriteManager = FavoriteManager.shared
    private let favoriteSetManager = FavoriteSetManager.shared
    private let workoutManager = Manager.shared
    
    private(set) var favorites = [WorkoutModel]()
    private(set) var favorites = [WorkoutResponse]()
    private(set) var workoutList = [WorkoutModel]()
    
    private(set) var mode: WorkoutListCellMode
    
    private(set) var selectedDate: Date = Date().stripTime()
    
    //MARK: - Init
    private var setName: String = ""
    
    init() {
        self.mode = .complete
        self.cancellables = .init()
        
        fetchFavorites()
        fetchWorkoutResponse()
    }
    
    //MARK: - Public Methods
}

//MARK: - Public Methods
extension WorkoutListViewModel2 {
    /// This method moves a cell from source indexPath to destination indexPath within the same collection view. It works for only 1 item. If multiple items selected, no reordering happens.
    ///
    /// - Parameters:
    ///   - coordinator: coordinator obtained from performDropWith: UICollectionViewDropDelegate method
    ///   - destinationIndexPath: indexpath of the collection view where the user drops the element
    ///   - collectionView: collectionView in which reordering needs to be done.
    public func reorderItems(coordinator: UICollectionViewDropCoordinator,
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
                    if let lastFavorite = favorites.last,
                       favorites[sourceIndexPath.row] == lastFavorite ||
                       favorites[dIndexPath.row] == lastFavorite { return }
                    self.favorites.remove(at: sourceIndexPath.row)
                    self.favorites.insert(item.dragItem.localObject as! WorkoutModel, at: dIndexPath.row)
                    self.updateSuggestionsPersistance()
                    self.favorites.insert(item.dragItem.localObject as! WorkoutResponse, at: dIndexPath.row)
                } else {
                    self.workoutList.remove(at: sourceIndexPath.row)
                    self.workoutList.insert(item.dragItem.localObject as! WorkoutModel, at: dIndexPath.row)
                    self.updateWorkoutPersistance()
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
    public func copyItems(coordinator: UICollectionViewDropCoordinator,
                   destinationIndexPath: IndexPath,
                   collectionView: UICollectionView,
                   currentCollectionView: UICollectionView
    ) {
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                
                if collectionView === currentCollectionView {
                    guard let item = item.dragItem.localObject as? WorkoutModel else { return }
                    let newItem = WorkoutModel(uuid: UUID(), title: item.title, reps: item.reps, weight: item.weight, timer: item.timer, isFavorite: item.isFavorite, isSelected: item.isSelected, isDone: item.isDone)
                    self.favorites.insert(newItem, at: indexPath.row)
                    self.updateSuggestionsPersistance()
                    
                } else {
                    guard let item = item.dragItem.localObject as? WorkoutModel else { return }
                    let newItem = WorkoutModel(uuid: UUID(), title: item.title, reps: item.reps, weight: item.weight, timer: item.timer, isFavorite: item.isFavorite, isSelected: item.isSelected, isDone: item.isDone)
                    self.workoutList.insert(newItem, at: indexPath.row)
                    self.updateWorkoutPersistance()
                }
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        })
    }
    
    public func didSelectDate(_ date: Date) {
        self.workoutManager.selectedWorkoutlist(of: date)
        self.notifySubject.send(.calendarDidSelect(self.selectedDate))
        self.notifySubject.send(.reloadWorkoutList)
    }
    
    public func setupMode(_ mode: WorkoutListCellMode) {
        self.mode = mode
    }
    
    public func updateIsComplete(_ isSelected: Bool, at index: Int) {
        switch mode {
        case .reorder:
            break
            
        case .psotpone:
            self.workoutList[index].isSelected = isComplete
            
        case .delete:
            self.workoutList[index].isSelected = isSelected
            
        case .complete:
            self.workoutList[index].isDone = isSelected
            self.workoutManager.setWorkoutlist(with: workoutList)
            
        case .normal:
            break
        case .createSet:
            self.workoutList[index].isSelected = isSelected
        }
    }
    
    public func setSetName(_ text: String) {
        self.setName = text
    }
    
    public func createSet() {
        let selectedWorkout = initializeSelectedWorkout(workoutList.filter({$0.isSelected}))
        let newFavorite = WorkoutResponse(uuid: UUID(), name: setName, date: nil, workouts: selectedWorkout)
        var temp = [newFavorite]
        temp.append(contentsOf: favorites)
        favoriteSetManager.setFavorites(temp)
    }
        }
    
    public func editWorkout(with workout: WorkoutModel?) {
        guard
            let workout = workout,
            let index = self.workoutList.firstIndex(where: {$0.uuid == workout.uuid})
        else { return }
        self.workoutList[index] = workout
        workoutManager.setWorkoutlist(with: workoutList)
    }
    
    public func setupWorkout(with workouts: [WorkoutModel]) {
//        workouts.forEach { workout in
//            if workout.isFavorite &&
//                !self.favorites.contains(where: {
//                    $0.title == workout.title &&
//                    $0.timer == workout.timer &&
//                    $0.weight == workout.weight &&
//                    $0.reps == workout.reps
//                }) {
//
    func setupWorkout(with workouts: [WorkoutModel]) {
        self.workoutList.append(contentsOf: workouts)
        self.workoutManager.setWorkoutlist(with: workoutList)
    }
    
    public func updateMode(type: WorkoutListCellMode) {
        self.mode = type
        
        var workouts = [WorkoutModel]()
        
        workoutList.forEach { model in
            workouts.append(.init(
                title: model.title,
                reps: model.reps,
                weight: model.weight,
                timer: model.timer,
                isFavorite: model.isFavorite,
                isSelected: model.isSelected,
                isDone: model.isDone))
        }
        
        workoutList = initializeSelectedWorkout(workouts)
        
        notifySubject.send(.reloadWorkoutList)
    }
    
    public func moveToCircularView() {
        listenerSubject.send(.moveToCircularView)
    }
    
    public func presentThis(_ vc: UINavigationController) {
        self.listenerSubject.send(.present(vc))
    }
    
    public func dismiss() {
        self.listenerSubject.send(.dismiss)
    }
    
    public func pushThis(_ vc: UIViewController) {
        self.listenerSubject.send(.push(vc))
    }
    
    public func pop() {
        self.listenerSubject.send(.pop)
    }
    
    public func deleteSuggestion(at index: Int, completion: () -> Void) {
        favorites.remove(at: index)
        completion()
        updateSuggestionsPersistance()
        checkIfWorkoutIsFinished()
    }
    
    public func deleteWorkout(at index: Int, completion: () -> Void) {
        workoutList.remove(at: index)
        completion()
        updateWorkoutPersistance()
    }
    
    public func deleteSelectedItems() {
        self.workoutList.removeAll(where: {$0.isSelected == true })
        self.notifySubject.send(.reloadWorkoutList)
    }
    
    //MARK: - Private Methods
    
    private func fetchFavorites() {
        favoriteManager
            .$favorites
            .sink { favorites in
                self.favorites = favorites
            }
            .store(in: &cancellables)
    }
    
    private func fetchWorkoutResponse() {
        workoutManager
            .$workoutDates
            .receive(on: RunLoop.main)
            .sink { dates in
                self.notifySubject.send(.setDates(1, 36500, dates))
        }
        .store(in: &cancellables)
        
        workoutManager
            .$workoutlist
            .receive(on: RunLoop.main)
            .sink { workoutlist in
                self.workoutList = workoutlist
                self.notifySubject.send(.reloadWorkoutList)
            }
            .store(in: &cancellables)
        
        workoutManager
            .$selectedDate
            .receive(on: RunLoop.main)
            .sink { date in
                self.selectedDate = date
            }
            .store(in: &cancellables)
    }
    
    private func checkIfWorkoutIsFinished() {
        let finished = workoutList.filter({$0.isDone})
        let unfinished = workoutList.filter({!$0.isDone})
        
        if finished.count == unfinished.count {
            print("finished")
        }
    }
    
    private func updateSuggestionsPersistance() {
        favoriteManager.setFavorites(favorites)
    }
    
    private func updateWorkoutPersistance() {
        workoutManager.setWorkoutlist(with: workoutList)
    }
}
