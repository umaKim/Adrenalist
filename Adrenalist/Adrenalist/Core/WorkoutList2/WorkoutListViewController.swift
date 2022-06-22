//
//  WorkoutList.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//
import Combine
import UIKit.UIViewController
import Foundation

final class WorkoutListViewController2: UIViewController {
    
    private(set) lazy var contentView = WorkoutListView2()
    
    private let viewModel: WorkoutListViewModel2
    //    private var mode: UpdateMode?
    
    private var cancellables: Set<AnyCancellable>
    
    init(viewModel: WorkoutListViewModel2) {
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
    
    private func isRightBarButtonItemsHidden(_ isHidden: Bool) {
        navigationItem.rightBarButtonItems = isHidden ? nil: [contentView.addButton]
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                    
                case .add:
                    self.showWorkoutSetupViewController(for: "Add")
                    
                case .reorder:
                    //TODO: change cell to be reorder mode
                    self.viewModel.updateMode(type: .reorder)
                    break
                    
                case .postpone:
                    //TODO: change cell to be postpone mode
                    self.viewModel.updateMode(type: .psotpone)
                    break
                    
                case .delete:
                    //TODO: change Cell to be delete mode
                    self.viewModel.updateMode(type: .delete)
                    break
                    
                case .tapTitleCalendar(let sheet):
                    self.present(sheet, animated: true)
                    
                case .bottomNavigationBarDidTapCancel:
                    self.viewModel.updateMode(type: .normal)
                    
                case .start:
                    self.viewModel.moveToCircularView()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink { noti in
                switch noti {
                case .delete:
                    self.contentView.workoutListCollectionView.reloadData()
                    break
                    
                case .postpone:
                    self.contentView.workoutListCollectionView.reloadData()
                    break
                    
                case .reorder:
                    self.contentView.workoutListCollectionView.reloadData()
                    break
                    
                case .normal:
                    self.contentView.workoutListCollectionView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showWorkoutSetupViewController(for title: String) {
        let vc = WorkoutSetupViewController()
        vc.title = title
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        contentView.calendarView.setDates
        contentView.calendarView.initialUISetup()
    }
    
    private func scrollToLast() {
        let lastItemIndex = IndexPath(item: viewModel.workouts.count - 1, section: 0)
        contentView.workoutListCollectionView.scrollToItem(at: lastItemIndex, at: .bottom, animated: true)
    }
    
    private func setupUI() {
        navigationItem.rightBarButtonItems  = [contentView.addButton]
        navigationItem.leftBarButtonItems   = [contentView.editButton]
        navigationItem.titleView            = contentView.calendarTitleButton
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
extension WorkoutListViewController2: WorkoutListCellDelegate {
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
extension WorkoutListViewController2: SuggestionListCellDelegate {
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
extension WorkoutListViewController2: ItemSetupViewControllerDelegate {
    func dismiss() {
        self.dismiss(animated: true)
    }
}

//MARK: - UICollectionView Drop Delegate
extension WorkoutListViewController2: UICollectionViewDropDelegate {
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
extension WorkoutListViewController2: UICollectionViewDragDelegate {
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
extension WorkoutListViewController2: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return collectionView == contentView.suggestedCollectionView ? viewModel.suggestions.count : viewModel.workouts.count
        return collectionView == contentView.suggestedCollectionView ? viewModel.favorites.count : viewModel.workoutList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.contentView.suggestedCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as? FavoriteCollectionViewCell else {return UICollectionViewCell() }
            //            cell.configure(with: viewModel.suggestions[indexPath.item], mode: self.mode)
            //            cell.delegate = self
            cell.configure(with: viewModel.favorites[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutlistCollectionViewCell.identifier, for: indexPath) as? WorkoutlistCollectionViewCell else {return UICollectionViewCell()}
            //            cell.configure(with: viewModel.workouts[indexPath.item], mode: self.mode)
            //            cell.delegate = self
            cell.configure(with: viewModel.workoutList[indexPath.item])
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension WorkoutListViewController2: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        if collectionView === contentView.workoutListCollectionView {
            //            viewModel.didTapWorkoutCell(at: indexPath.item)
            //            let vc = WorkoutSetupViewController()
            //            vc.title = "Edit"
            //            let nav = UINavigationController(rootViewController: vc)
            //            present(nav, animated: true)
            
            self.showWorkoutSetupViewController(for: "Edit")
        } else {
            //            viewModel.didTapSuggestion(at: indexPath.item)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension WorkoutListViewController2: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == contentView.suggestedCollectionView {
            //            return .init(width: UIScreen.main.bounds.width / 2.5, height: 40)
            let width = viewModel.favorites[indexPath.item].title.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]).width + 48
            let height: CGFloat = 39
            
            return CGSize(width: width, height: height)
        } else {
            return .init(width: UIScreen.main.bounds.width - 32, height: 78)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView === contentView.suggestedCollectionView{
            return .init(top: 0, left: 16, bottom: 0, right: 16)
        }
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
}
