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
    case reloadWorkouts
    case reloadSuggestions
    case modeChanged(UpdateMode?)
    case delete(Int)
    case showKeyboard(CGRect)
    case hideKeyboard
    case fullPanel
    case tipPanel
}

enum UpdateMode {
    case edit
    case delete
}

enum WorkoutListViewModelListener {
    case dismiss
}

final class WorkoutListViewModel2  {
    
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<WorkoutListViewModel2Notification, Never>()
    
    private(set) lazy var listenerPublisher = listenerSubject.eraseToAnyPublisher()
    private let listenerSubject = PassthroughSubject<WorkoutListViewModelListener, Never>()
    
    private(set) lazy var suggestions: [Item] = []
    private(set) lazy var workouts: [Item] = []
    
    private var cancellables: Set<AnyCancellable>
    
    private let workoutManager = ItemManager.shared
    
    private(set) var mode = CurrentValueSubject<UpdateMode?, Never>(nil)
    
    private(set) var panelState = PassthroughSubject<FloatingPanelState, Never>()
    
    private(set) var favorites = [WorkoutModel]()
    private(set) var workoutList = [WorkoutModel]()
    
    init() {
//        self.panelState = panelState
        self.cancellables = .init()
        bind()
    }
    
    private var keyboardHelper: KeyboardHelper?
    
    private func bind() {
//        workoutManager
//            .$itemToDos
//            .sink { workouts in
//                self.workouts = workouts
//                self.notifySubject.send(.reloadWorkouts)
//            }
//            .store(in: &cancellables)
//
//        workoutManager
//            .$suggestions
//            .sink { [weak self] suggestions in
//                guard let self = self else {return }
//                self.suggestions = suggestions
//                self.notifySubject.send(.reloadSuggestions)
//            }
//            .store(in: &cancellables)
        
        workouts = [
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout)
        ]
        
        suggestions = [
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout),
            .init(title: "", isDone: true, type: .workout)
        ]
        
        ["Bench Press",
         "pull up",
         "nice",
         "Incline Bench press",
         "Bench Press",
          "pull up",
          "nice",
          "Incline Bench press",
         "Bench Press",
          "pull up",
          "nice",
          "Incline Bench press"]
            .forEach { text in
                workoutList.append(WorkoutModel(title: text,
                                          reps: 20,
                                          weight: 200,
                                          timer: 1000,
                                          isFavorite: nil))
            }
        
        ["Bench Press",
         "pull up",
         "nice",
         "Incline Bench press",
         "Bench Press",
          "pull up",
          "nice",
          "Incline Bench press",
         "Bench Press",
          "pull up",
          "nice",
          "Incline Bench press"]
            .forEach { text in
                favorites.append(WorkoutModel(title: text,
                                          reps: 20,
                                          weight: 200,
                                          timer: 1000,
                                          isFavorite: nil))
            }
        
        mode
            .sink {[weak self] mode in
                guard let self = self else {return }
                self.notifySubject.send(.modeChanged(mode))
            }
            .store(in: &cancellables)
        
        panelState
            .sink { state in
                switch state {
                case .tip:
                    self.notifySubject.send(.tipPanel)
                    
                case .full:
                    self.notifySubject.send(.fullPanel)
                    
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        keyboardHelper = KeyboardHelper { [unowned self] animation, keyboardFrame, duration in
            switch animation {
            case .keyboardWillShow:
                self.notifySubject.send(.showKeyboard(keyboardFrame))
            case .keyboardWillHide:
                self.notifySubject.send(.hideKeyboard)
            }
        }
    }
    
    func dismiss() {
        listenerSubject.send(.dismiss)
    }
    
    func editMode() {
        mode.value = .edit
    }
    
    func deleteMode() {
        mode.value = .delete
    }
    
    func noMode() {
        mode.value = nil
    }
    
    func didTapWorkoutCell(at index: Int) {
        workouts[index].isDone.toggle()
        updateWorkoutToDo()
    }
    
    func didTapSuggestion(at index: Int) {
        let tappedItem = suggestions[index]
        let item = Item(uuid: UUID(),
                        timer: tappedItem.timer,
                        title: tappedItem.title,
                        reps: tappedItem.reps,
                        weight: tappedItem.weight,
                        isDone: tappedItem.isDone,
                        type: tappedItem.type)
        workouts.append(item)
        updateWorkoutToDo()
        checkIfWorkoutIsFinished()
    }
    
    func deleteSuggestion(at index: Int, completion: () -> Void) {
        suggestions.remove(at: index)
        completion()
        updateSuggestions()
        checkIfWorkoutIsFinished()
    }
    
    func deleteWorkout(at index: Int, completion: () -> Void) {
        workouts.remove(at: index)
        completion()
        updateWorkoutToDo()
    }
    
    func addWorkout(for workout: String?, _ reps: String?, _ weight: String?) {
        workoutManager.appendWorkoutToDos(Item(uuid: UUID(),
                                               timer: nil,
                                               title: workout ?? "",
                                               reps: Int(reps ?? ""),
                                               weight: Double(weight ?? ""),
                                               isDone: false,
                                               type: .workout))
    }
    
    //MARK: - Private Methods
    private func updateWorkoutToDo() {
        workoutManager.updateWorkoutToDos(workouts)
    }
    
    private func checkIfWorkoutIsFinished() {
        let finished = workouts.filter({$0.isDone})
        let unfinished = workouts.filter({!$0.isDone})
        
        if finished.count == unfinished.count {
            print("finished")
        }
    }
    
    private func updateSuggestions() {
        workoutManager.updateSuggestions(suggestions)
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
                    self.workouts.remove(at: sourceIndexPath.row)
                    self.workouts.insert(item.dragItem.localObject as! Item, at: dIndexPath.row)
                    self.updateWorkoutToDo()
                } else {
                    self.suggestions.remove(at: sourceIndexPath.row)
                    self.suggestions.insert(item.dragItem.localObject as! Item, at: dIndexPath.row)
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
                    guard let item = item.dragItem.localObject as? Item else { return }
                    let newItem = Item(uuid: UUID(), timer: item.timer, title: item.title, reps: item.reps, weight: item.weight, isDone: item.isDone, type: item.type)
                    self.workouts.insert(newItem, at: indexPath.row)
                    self.updateWorkoutToDo()
                    
                } else {
                    guard let item = item.dragItem.localObject as? Item else { return }
                    let newItem = Item(uuid: UUID(), timer: item.timer, title: item.title, reps: item.reps, weight: item.weight, isDone: item.isDone, type: item.type)
                    self.suggestions.insert(newItem, at: indexPath.row)
                    self.updateSuggestions()
                }
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        })
    }
}
