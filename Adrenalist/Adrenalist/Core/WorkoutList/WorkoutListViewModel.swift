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
    //    case reloadWorkouts
    //    case reloadSuggestions
    //    case modeChanged(UpdateMode?)
    //    case delete(Int)
    //    case showKeyboard(CGRect)
    //    case hideKeyboard
    //    case fullPanel
    //    case tipPanel
    
//    case reorder
//    case postpone
//    case delete
//    case normal
    
    case isWorkoutListEmpty(Bool)
    case isFavoriteEmpty(Bool)
    case reloadWorkoutList
    case reloadFavorites
}

enum WorkoutListCellMode: Codable {
    case reorder
    case psotpone
    case delete
    case normal
}

enum UpdateMode {
    case edit
    case delete
}

enum WorkoutListViewModelListener {
    case dismiss
    case moveToCircularView
}

final class WorkoutListViewModel2  {
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<WorkoutListViewModel2Notification, Never>()
    
    private(set) lazy var listenerPublisher = listenerSubject.eraseToAnyPublisher()
    private let listenerSubject = PassthroughSubject<WorkoutListViewModelListener, Never>()
    
    //    private(set) lazy var suggestions: [Item] = []
    //    private(set) lazy var workouts: [Item] = []
    
    private var cancellables: Set<AnyCancellable>
    
    private let workoutManager = WorkoutManager.shared
    
    //    private(set) var panelState = PassthroughSubject<FloatingPanelState, Never>()
    
    private(set) var favorites = [WorkoutModel]()
    private(set) var workoutList = [WorkoutModel]()
    
    init() {
        self.cancellables = .init()
        bind()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchFavorites()
            self.fetchWorkoutList(of: Date().stripTime())
//        }
    }
    
    func fetchFavorites() {
        workoutManager
            .retrieveFavorites()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.notifySubject.send(.isFavoriteEmpty(self.favorites.isEmpty))
                    self.notifySubject.send(.reloadFavorites)
                case .failure(let error):
                    break
                }
            } receiveValue: { workouts in
                self.favorites = workouts
            }
            .store(in: &cancellables)
    }
    
    func fetchWorkoutList(of date: Date) {
        workoutManager
            .retrieveWorkoutList(of: date)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.notifySubject.send(.isWorkoutListEmpty(self.workoutList.isEmpty))
                    self.notifySubject.send(.reloadWorkoutList)
                case .failure(let error):
                    break
                }
            } receiveValue: { workouts in
                self.workoutList = workouts
            }
            .store(in: &cancellables)
    }
    
    //    private var keyboardHelper: KeyboardHelper?
    
    private func bind() {
//        ["Bench Press",
//         "pull up",
//         "nice",
//         "Incline Bench press",
//         "Bench Press",
//         "pull up",
//         "nice",
//         "Incline Bench press",
//         "Bench Press",
//         "pull up",
//         "nice",
//         "Incline Bench press"]
//            .forEach { text in
//                workoutList.append(WorkoutModel(
//                    mode: .normal,
//                    title: text,
//                    reps: 20,
//                    weight: 200,
//                    timer: 1000,
//                    isFavorite: nil,
//                    isSelected: false, isDone: false))
//            }
//        
//        ["Bench Press",
//         "pull up",
//         "nice",
//         "Incline Bench press",
//         "Bench Press",
//         "pull up",
//         "nice",
//         "Incline Bench press",
//         "Bench Press",
//         "pull up",
//         "nice",
//         "Incline Bench press"]
//            .forEach { text in
//                favorites.append(WorkoutModel(mode: .normal,
//                                              title: text,
//                                              reps: 20,
//                                              weight: 200,
//                                              timer: 1000,
//                                              isFavorite: nil, isSelected: false, isDone: false))
//                
//            }
//        
//        favorites.append(WorkoutModel(mode: .normal, title: "Last", isDone: false))
    }
    
    func updateMode(type: WorkoutListCellMode) {
        var workouts = [WorkoutModel]()
        
        workoutList.forEach { model in
            workouts.append(.init(mode: type,
                                  title: model.title,
                                  reps: model.reps,
                                  weight: model.weight,
                                  timer: model.timer,
                                  isFavorite: model.isFavorite,
                                  isSelected: model.isSelected,
                                  isDone: model.isDone))
        }
        
        workoutList = workouts
        
        switch type {
        case .reorder:
            self.notifySubject.send(.reloadWorkoutList)
        case .psotpone:
            self.notifySubject.send(.reloadWorkoutList)
        case .delete:
            self.notifySubject.send(.reloadWorkoutList)
        case .normal:
            self.notifySubject.send(.reloadWorkoutList)
        }
    }
    
    //    func moveToCircularView() {
    //        listenerSubject.send(.moveToCircularView)
    //    }
    //
    //    func dismiss() {
    //        listenerSubject.send(.dismiss)
    //    }
    //
    //    func editMode() {
    ////        mode.value = .edit
    //    }
    //
    //    func deleteMode() {
    ////        mode.value = .delete
    //    }
    //
    //    func noMode() {
    ////        mode.value = nil
    //    }
    //
    //    func didTapWorkoutCell(at index: Int) {
    //        workouts[index].isDone.toggle()
    //        updateWorkoutToDo()
    //    }
    
    //    func didTapSuggestion(at index: Int) {
    //        let tappedItem = suggestions[index]
    //        let item = Item(uuid: UUID(),
    //                        timer: tappedItem.timer,
    //                        title: tappedItem.title,
    //                        reps: tappedItem.reps,
    //                        weight: tappedItem.weight,
    //                        isDone: tappedItem.isDone,
    //                        type: tappedItem.type)
    //        workouts.append(item)
    //        updateWorkoutToDo()
    //        checkIfWorkoutIsFinished()
    //    }
    
    func deleteSuggestion(at index: Int, completion: () -> Void) {
        favorites.remove(at: index)
        completion()
        updateSuggestions()
        checkIfWorkoutIsFinished()
    }
    
    func deleteWorkout(at index: Int, completion: () -> Void) {
        workoutList.remove(at: index)
        completion()
        updateWorkoutToDo()
    }
    
    //    func addWorkout(for workout: String?, _ reps: String?, _ weight: String?) {
    //        workoutManager.appendWorkoutToDos(WorkoutModel(uuid: UUID(),
    //                                               timer: nil,
    //                                               title: workout ?? "",
    //                                               reps: Int(reps ?? ""),
    //                                               weight: Double(weight ?? ""),
    //                                               isDone: false,
    //                                               type: .workout))
    //    }
    
    //MARK: - Private Methods
    private func updateWorkoutToDo() {
        //        workoutManager.updateWorkoutToDos(workoutList)
        //        workoutManager.saveWorkoutList(WorkoutResponse(date: <#T##Date#>, workouts: <#T##[WorkoutModel]#>))
    }
    
    private func checkIfWorkoutIsFinished() {
        let finished = workoutList.filter({$0.isDone})
        let unfinished = workoutList.filter({!$0.isDone})
        
        if finished.count == unfinished.count {
            print("finished")
        }
    }
    
    private func updateSuggestions() {
        //        workoutManager.updateSuggestions(favorites)
        workoutManager.saveFavorite(of: favorites)
    }
    
    //MARK: - Public Methods
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
                    self.favorites.remove(at: sourceIndexPath.row)
                    self.favorites.insert(item.dragItem.localObject as! WorkoutModel, at: dIndexPath.row)
                    self.updateWorkoutToDo()
                } else {
                    self.workoutList.remove(at: sourceIndexPath.row)
                    self.workoutList.insert(item.dragItem.localObject as! WorkoutModel, at: dIndexPath.row)
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
                    guard let item = item.dragItem.localObject as? WorkoutModel else { return }
                    //                    let newItem = Item(uuid: UUID(), timer: item.timer, title: item.title, reps: item.reps, weight: item.weight, isDone: item.isDone, type: item.type)
                    let newItem = WorkoutModel(uuid: UUID(), mode: item.mode, title: item.title, reps: item.reps, weight: item.weight, timer: item.timer, isFavorite: item.isFavorite, isSelected: item.isSelected, isDone: item.isDone)
                    self.workoutList.insert(newItem, at: indexPath.row)
                    self.updateWorkoutToDo()
                    
                } else {
                    guard let item = item.dragItem.localObject as? WorkoutModel else { return }
                    let newItem = WorkoutModel(uuid: UUID(), mode: item.mode, title: item.title, reps: item.reps, weight: item.weight, timer: item.timer, isFavorite: item.isFavorite, isSelected: item.isSelected, isDone: item.isDone)
                    self.favorites.insert(newItem, at: indexPath.row)
                    self.updateSuggestions()
                }
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        })
    }
    
    func didSelectDate(_ date: Date) {
        self.fetchWorkoutList(of: date)
    }
}
