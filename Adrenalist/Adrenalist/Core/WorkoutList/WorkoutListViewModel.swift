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
    private let workoutManager = Manager.shared
    
    private(set) var favorites = [WorkoutModel]()
    private(set) var workoutList = [WorkoutModel]()
    
    private(set) var workoutResponses = [WorkoutResponse]()
    
    private(set) var mode: WorkoutListCellMode
    
    @Published private(set) var selectedDate: Date = Date().stripTime()
    
    func setupMode(_ mode: WorkoutListCellMode) {
        self.mode = mode
    }
    
    func updateIsComplete(_ isComplete: Bool, at index: Int) {
        
        switch mode {
        case .reorder:
            break
            
        case .psotpone:
            self.workoutList[index].isSelected = isComplete
            
        case .delete:
            self.workoutList[index].isSelected = isComplete
            
        case .complete:
            self.workoutList[index].isDone = isComplete
            
        case .normal:
            break
        }
        
    }
    
    init() {
        self.mode = .complete
        self.cancellables = .init()
        fetchFavorites()
        fetchWorkoutResponse()
        
//        $selectedDate
//            .sink { date in
//                self.workoutManager.setSelectedDate(date)
//            }
//            .store(in: &cancellables)
    }
    
    private func fetchFavorites() {
        favoriteManager
            .retrieve()
            .sink { completion in
                switch completion {
                case .finished:
                    //                    self.appendLastFavorite()
                    self.notifySubject.send(.reloadFavorites)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { favorites in
                self.favorites = favorites
            }
            .store(in: &cancellables)
    }
    
    private func appendLastFavorite() {
        favorites.append(WorkoutModel(title: "Last", isFavorite: false, isSelected: false, isDone: false))
    }
    
    private func fetchWorkoutResponse() {
//        workoutManager
//            .retrieve()
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    self.fetchWorkoutList(of: self.selectedDate)
//                    self.notifySubject.send(.reloadWorkoutList)
//
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//
//            } receiveValue: { responses in
//                self.workoutResponses = responses
//            }
//            .store(in: &cancellables)
        
//        workoutManager
//            .$workoutResponses
//            .sink { responses in
//                self.workoutResponses = responses
//                self.fetchWorkoutList(of: self.selectedDate)
//                self.notifySubject.send(.reloadWorkoutList)
//            }
//            .store(in: &cancellables)
        
        workoutManager
            .$selectedWorkouts
            .receive(on: RunLoop.main)
            .sink { responses, date in
                self.workoutResponses = responses
                self.fetchWorkoutList(of: self.selectedDate)
                self.notifySubject.send(.setDates(1, 36500, self.workoutDates))
                self.notifySubject.send(.reloadWorkoutList)
        }
        .store(in: &cancellables)
    }
    
    
    private func fetchWorkoutList(of date: Date) {
        self.workoutList = workoutResponses
            .filter({ $0.date == date.stripTime()})
            .flatMap({$0.workouts})
    }
    
    var workoutDates: [Date] {
        workoutResponses.map({$0.date.stripTime()})
    }
    
    func updateMode(type: WorkoutListCellMode) {
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
        
        workoutList = workouts
        
        notifySubject.send(.reloadWorkoutList)
    }
    
    func moveToCircularView() {
        listenerSubject.send(.moveToCircularView)
    }
    
    func presentThis(_ vc: UINavigationController) {
        self.listenerSubject.send(.present(vc))
    }
    
    func dismiss() {
        self.listenerSubject.send(.dismiss)
    }
    
    func pushThis(_ vc: UIViewController) {
        self.listenerSubject.send(.push(vc))
    }
    
    func pop() {
        self.listenerSubject.send(.pop)
    }
    
    func deleteSuggestion(at index: Int, completion: () -> Void) {
        favorites.remove(at: index)
        completion()
        updateSuggestionsPersistance()
        checkIfWorkoutIsFinished()
    }
    
    func deleteWorkout(at index: Int, completion: () -> Void) {
        workoutList.remove(at: index)
        completion()
        updateWorkoutPersistance()
    }
    
    func deleteSelectedItems() {
        self.workoutList.removeAll(where: {$0.isSelected == true })
        print(workoutList)
        self.notifySubject.send(.reloadWorkoutList)
    }
    
    //MARK: - Private Methods
    private func checkIfWorkoutIsFinished() {
        let finished = workoutList.filter({$0.isDone})
        let unfinished = workoutList.filter({!$0.isDone})
        
        if finished.count == unfinished.count {
            print("finished")
        }
    }
    
    private func updateSuggestionsPersistance() {
        favoriteManager.save(favorites)
    }
    
    private func updateWorkoutPersistance() {
        guard
            let index = workoutResponses.firstIndex(where: {$0.date == self.selectedDate.stripTime()})
        else {
            makeNewResponse(with: workoutList)
            return
        }
        self.workoutResponses[index] = WorkoutResponse(date: workoutResponses[index].date,
                                                       mode: workoutResponses[index].mode,
                                                       workouts: workoutList)
//        workoutManager.save(workoutResponses)
        self.workoutManager.updateByReplacing(workoutResponses)
        self.workoutManager.sendSelectedDateWorkout(workoutResponses,
                                                    date: selectedDate)
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
                    self.updateSuggestionsPersistance()
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
    
    func didSelectDate(_ date: Date) {
        self.selectedDate = date.stripTime()
        self.fetchWorkoutList(of: selectedDate)
        self.notifySubject.send(.calendarDidSelect(self.selectedDate))
        self.notifySubject.send(.reloadWorkoutList)
    }
    
    func setupWorkout(with model: WorkoutModel?, for type: WorkoutSetupType, set: Int) {
        guard let model = model else { return }
        
        if model.isFavorite {
            let favoriteModel = WorkoutModel(uuid: UUID(),
                                             title: model.title,
                                             reps: model.reps,
                                             weight: model.weight,
                                             timer: model.timer,
                                             isFavorite: model.isFavorite,
                                             isSelected: model.isSelected,
                                             isDone: false)
            if favorites.isEmpty == false {
                favorites.removeLast()
            }
            favorites.append(favoriteModel)
            appendLastFavorite()
            favoriteManager.save(favorites)
        }
        
        let newArray = Array(repeating: model, count: set)
        
        guard
            let responsesIndex = workoutResponses.firstIndex(where: {$0.date == self.selectedDate})
        else {
            makeNewResponse(with: newArray)
            workoutList.append(contentsOf: newArray)
            return
        }
        
        var selectedResponse = workoutResponses[responsesIndex]
        
        switch type {
        case .edit:
            guard
                let selectedIndex = selectedResponse.workouts.firstIndex(where: {$0.uuid == model.uuid})
            else { return }
            workoutList[selectedIndex] = model
            selectedResponse.workouts[selectedIndex] = model
            
        case .add:
            workoutList.append(contentsOf: newArray)
            selectedResponse.workouts = workoutList
        }
        
        workoutResponses[responsesIndex] = selectedResponse
        
        workoutManager.updateByReplacing(workoutResponses)
        workoutManager.sendSelectedDateWorkout(workoutResponses, date: selectedDate)
//        workoutManager.save(workoutResponses)
    }
    
    private func makeNewResponse(with models: [WorkoutModel]) {
//        workoutResponses.append(WorkoutResponse(date: self.selectedDate,
//                                                mode: .normal,
//                                                workouts: models))
//        workoutManager.save(workoutResponses)
//        workoutManager.updateByAdding(WorkoutResponse(date: self.selectedDate,
//                                                      mode: .normal,
//                                                      workouts: models))
        workoutResponses.append(WorkoutResponse(date: self.selectedDate,
                                                mode: .normal,
                                                workouts: models))
        workoutManager.updateByReplacing(workoutResponses)
    }
}
