//
//  WorkoutList.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//

import FloatingPanel
import Combine
import UIKit.UIViewController
import Foundation

final class WorkoutListViewController: UIViewController {
    
    private(set) lazy var contentView = WorkoutListView()
    
    private let viewModel: WorkoutListViewModel
    private var mode: UpdateMode?
    
    private var cancellables: Set<AnyCancellable>
    
    init(viewModel: WorkoutListViewModel) {
        self.cancellables = .init()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .black
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
        
        bind()
        setupUI()
        setupCollectionView()
    }
    
    private func presentItemSetupModalForUpdate(at indexPath: IndexPath, type: CollectionViewType) {
        var targetItem: Item?
        switch type {
        case .suggestion:
            targetItem = viewModel.suggestions[indexPath.row]
        case .mainWorkout:
            targetItem = viewModel.workouts[indexPath.row]
        }
        
        guard
            let targetItem = targetItem
        else { return }
        
        let vm = ItemSetupViewModel(workout: targetItem, collectionViewType: type)
        let vc = ItemSetupViewController(viewModel: vm)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                switch action {
                case .addWorkoutButtonDidTap(let workout, let reps, let weight):
                    self.viewModel.addWorkout(for: workout, reps, weight)
                    
                case .edit:
                    self.viewModel.editMode()
                    
                case .delete:
                    self.viewModel.deleteMode()
                    
                case .tapBackground:
                    self.viewModel.noMode()
                    
                case .dismiss:
                    self.viewModel.dismiss()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[weak self] noti in
                guard let self = self else {return }
                switch noti {
                case .reloadSuggestions:
                    self.contentView.suggestedCollectionView.reloadData()
                    
                case .reloadWorkouts:
                    self.contentView.workoutListCollectionView.reloadData()
                    self.scrollToLast()
                    
                case.modeChanged(let mode):
                    self.mode = mode
                    self.contentView.suggestedCollectionView.reloadData()
                    self.contentView.workoutListCollectionView.reloadData()
                    
                case .delete(let index):
                    self.contentView.workoutListCollectionView.performBatchUpdates {
                        let indexPath = IndexPath(row: index, section: 0)
                        self.contentView.workoutListCollectionView.deleteItems(at: [indexPath])
                    }
                case .showKeyboard(let frame):
                    self.contentView.showKeyboard(frame)
                    
                case .hideKeyboard:
                    self.contentView.hideKeyboard()
                    
                case .fullPanel:
                    self.contentView.hideKeyboard()
                    
                case .tipPanel:
                    self.contentView.hideKeyboard()
                }
            }
            .store(in: &cancellables)
    }
    
    private func scrollToLast() {
        let lastItemIndex = IndexPath(item: viewModel.workouts.count - 1, section: 0)
        contentView.workoutListCollectionView.scrollToItem(at: lastItemIndex, at: .bottom, animated: true)
    }
    
    private func setupUI() {
        navigationItem.rightBarButtonItems  = [contentView.dismissButton]
        navigationItem.leftBarButtonItems   = [contentView.updateButton]
        navigationItem.titleView            = contentView.upwardImageView
    }
    
    private func setupCollectionView() {
        contentView.suggestedCollectionView.delegate        = self
        contentView.suggestedCollectionView.dataSource      = self
        contentView.suggestedCollectionView.dropDelegate    = self
        contentView.suggestedCollectionView.dragDelegate    = self
        contentView.suggestedCollectionView.dragInteractionEnabled = true
        
        contentView.workoutListCollectionView.delegate      = self
        contentView.workoutListCollectionView.dataSource    = self
        contentView.workoutListCollectionView.dropDelegate  = self
        contentView.workoutListCollectionView.dragDelegate  = self
        contentView.workoutListCollectionView.dragInteractionEnabled = true
        contentView.workoutListCollectionView.reorderingCadence = .immediate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - WorkoutListCellDelegate
extension WorkoutListViewController: WorkoutListCellDelegate {
    func workoutListDidTapEdit(id: UUID) {
        guard
            let itemIndex = viewModel.workouts.firstIndex(where: {$0.uuid == id})
        else { return }
        
        let indexPath = IndexPath(row: itemIndex, section: 0)
        presentItemSetupModalForUpdate(at: indexPath, type: .mainWorkout)
        viewModel.noMode()
    }
    
    func workoutListDidTapdelete(id: UUID) {
        guard
            let itemIndex = viewModel.workouts.firstIndex(where: {$0.uuid == id})
        else { return }
        
        let indexPath = IndexPath(row: itemIndex, section: 0)
        viewModel.deleteWorkout(at: indexPath.row, completion: {
            self.contentView.workoutListCollectionView.deleteItems(at: [indexPath])
        })
    }
}

//MARK: - SuggestionListCellDelegate
extension WorkoutListViewController: SuggestionListCellDelegate {
    func suggestionDidTapEdit(id: UUID) {
        guard
            let itemIndex = viewModel.suggestions.firstIndex(where: {$0.uuid == id})
        else { return }
        
        let indexPath = IndexPath(row: itemIndex, section: 0)
        presentItemSetupModalForUpdate(at: indexPath, type: .suggestion)
        viewModel.noMode()
    }
    
    func suggestionDidTapDelete(id: UUID) {
        guard
            let itemIndex = viewModel.suggestions.firstIndex(where: {$0.uuid == id})
        else { return }
        
        let indexPath = IndexPath(row: itemIndex, section: 0)
        viewModel.deleteSuggestion(at: indexPath.row, completion: {
            self.contentView.suggestedCollectionView.deleteItems(at: [indexPath])
        })
    }
}

////MARK: - ItemSetupViewControllerDelegate
extension WorkoutListViewController: ItemSetupViewControllerDelegate {
    func dismiss() {
        self.dismiss(animated: true)
    }
}

//MARK: - UICollectionView Drop Delegate
extension WorkoutListViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        //        if collectionView === self.contentView.suggestedCollectionView {
        //            if collectionView.hasActiveDrag {
        //                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        //            } else {
        //                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        //            }
        //        } else
        //        {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        //        else {
        return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        //        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        //            }
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation {
        case .move:
            self.viewModel.reorderItems(coordinator: coordinator,
                                        destinationIndexPath:destinationIndexPath,
                                        collectionView: collectionView,
                                        currentCollectionView: contentView.workoutListCollectionView)
            
        case .copy:
            self.viewModel.copyItems(coordinator: coordinator,
                                     destinationIndexPath: destinationIndexPath,
                                     collectionView: collectionView,
                                     currentCollectionView: contentView.workoutListCollectionView)
        default:
            return
        }
    }
}

//MARK: - UICollectionView Drag Delegate
extension WorkoutListViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = collectionView == contentView.suggestedCollectionView ? viewModel.suggestions[indexPath.row] : viewModel.workouts[indexPath.row]
        let itemProvider = NSItemProvider(object: item.uuid.uuidString as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let item = collectionView == contentView.suggestedCollectionView ? viewModel.suggestions[indexPath.row] : viewModel.workouts[indexPath.row]
        let itemProvider = NSItemProvider(object: item.uuid.uuidString as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        if collectionView == contentView.suggestedCollectionView {
            let previewParameters = UIDragPreviewParameters()
            return previewParameters
        }
        return nil
    }
}

//MARK: - UICollectionViewDataSource
extension WorkoutListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == contentView.suggestedCollectionView ? viewModel.suggestions.count : viewModel.workouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.contentView.suggestedCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionListCell.identifier, for: indexPath) as? SuggestionListCell else {return UICollectionViewCell() }
            cell.configure(with: viewModel.suggestions[indexPath.item], mode: self.mode)
            cell.delegate = self
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutListCell.identifier, for: indexPath) as? WorkoutListCell else {return UICollectionViewCell()}
            cell.configure(with: viewModel.workouts[indexPath.item], mode: self.mode)
            cell.delegate = self
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension WorkoutListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === contentView.workoutListCollectionView {
            viewModel.didTapWorkoutCell(at: indexPath.item)
        } else {
            viewModel.didTapSuggestion(at: indexPath.item)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension WorkoutListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == contentView.suggestedCollectionView {
            return .init(width: UIScreen.main.bounds.width / 2.5, height: 40)
        } else {
            return .init(width: UIScreen.main.bounds.width - 50, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView === contentView.suggestedCollectionView{
            return .init(top: 0, left: 16, bottom: 0, right: 16)
        }
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
}
