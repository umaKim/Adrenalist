//
//  WorkoutList.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//
import Combine
import UIKit.UIViewController
import Foundation

final class WorkoutListViewController2: UIViewController, ModalViewControllerDelegate {
    func modalDidTapCancel() {
        self.dismiss(animated: true)
    }
    
    func modalDidTapConfirm() {
        self.dismiss(animated: true) {
            self.viewModel.createSet()
            self.viewModel.updateMode(type: .complete)
            self.contentView.dismissBottomNavigationView()
            self.isRightBarButtonItemsHidden(false)
        }
    }
    
    func modalDidChangeText(_ text: String) {
        self.viewModel.setSetName(text)
    }
    
    private(set) lazy var contentView = WorkoutListView2()
    
    private let viewModel: WorkoutListViewModel2
    
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

    private func isRightBarButtonItemsHidden(_ isHidden: Bool) {
        navigationItem.rightBarButtonItems = isHidden ? nil: [contentView.moveToCircularButton, contentView.addButton]
    }
    
    private func navSheet(_ vc: ContentViewController) -> UINavigationController {
        vc.delegate = self
        vc.selectedDate = self.viewModel.selectedDate
        let nav = UINavigationController(rootViewController: vc)
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        return nav
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                    
                case .add:
                    self.showWorkoutSetupViewController(for: .add, didSelect: WorkoutModel(title: "", isFavorite: false, isSelected: false, isDone: false))
                    
                case .createSet:
                    self.viewModel.updateMode(type: .createSet)
                    self.isRightBarButtonItemsHidden(true)
                    
                case .delete:
                    //TODO: change Cell to be delete mode
                    self.viewModel.updateMode(type: .delete)
                    self.isRightBarButtonItemsHidden(true)
                    
                case .tapTitleCalendar(let vc):
                    let nav = self.navSheet(vc)
                    self.viewModel.presentThis(nav)
                    
                case .start:
                    self.viewModel.moveToCircularView()
                
                case .didSelectDate(let date):
                    self.viewModel.didSelectDate(date.date)
                    
                case .bottomSheetDidTapDelete:
                    self.viewModel.deleteSelectedItems()
                    self.isRightBarButtonItemsHidden(false)
                    
                case .bottomSheetDidTapCreateSet:
                    //MARK: - Present pop up alert for set name
//                    self.viewModel.createSet()
                    let vc = ModalViewController()
                    vc.delegate = self
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                    
                case .bottomNavigationBarDidTapCancel:
                    self.viewModel.updateMode(type: .complete)
                    self.isRightBarButtonItemsHidden(false)
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink { noti in
                switch noti {
                case .reloadFavorites:
                    self.contentView.suggestedCollectionView.reloadData()
                    
                case .reloadWorkoutList:
                    self.contentView.workoutListCollectionView.reloadData()
                    
                case .isFavoriteEmpty(let isEmpty):
                    self.contentView.isFavoriteEmpty(isEmpty)
                    
                case .isWorkoutListEmpty(let isEmpty):
                    self.contentView.isWorkoutEmpty(isEmpty)
                    
                case .setDates(let min, let max, let dates):
                    self.contentView.setDates(min: min,
                                              max: max,
                                              dates: dates)
                    self.contentView.initialUISetup()
                    
                case .updateDeletedDate(let date):
                    self.contentView.deleteDot(of: date)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showWorkoutSetupViewController(for type: WorkoutSetupType, didSelect model: WorkoutModel) {
        let vm = WorkoutSetupViewModel(workout: model, type: type)
        let vc = WorkoutSetupViewController(viewModel: vm)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.accessibilityNavigationStyle = .separate
        }
        self.viewModel.presentThis(nav)
    }
    
    private func scrollToLast() {
        let lastItemIndex = IndexPath(item: viewModel.workoutList.count - 1, section: 0)
        contentView.workoutListCollectionView.scrollToItem(at: lastItemIndex, at: .bottom, animated: true)
    }

    private func setupUI() {
        navigationItem.rightBarButtonItems  = [contentView.moveToCircularButton, contentView.addButton]
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
                                        currentCollectionView: contentView.suggestedCollectionView)
            
        case .copy:
            self.viewModel.copyItems(coordinator: coordinator,
                                     destinationIndexPath: destinationIndexPath,
                                     collectionView: collectionView,
                                     currentCollectionView: contentView.suggestedCollectionView)
        default:
            return
        }
    }
}

//MARK: - UICollectionView Drag Delegate
extension WorkoutListViewController2: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let item = collectionView == contentView.suggestedCollectionView ? viewModel.favorites[indexPath.row].workouts[0] : viewModel.workoutList[indexPath.row]
        
        if collectionView == contentView.suggestedCollectionView {
            let item = viewModel.favorites[indexPath.row]
            if item == viewModel.favorites.last {print("no drag for favorites")
                return [] }
            let itemProvider = NSItemProvider(object: item.uuid.uuidString as NSString)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            print("suggestedCollectionView Drag")
            return [dragItem]
            
        } else if collectionView == contentView.workoutListCollectionView {
            let item = viewModel.workoutList[indexPath.row]
            let itemProvider = NSItemProvider(object: item.uuid.uuidString as NSString)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            print("workoutListCollectionView Drag")
            return [dragItem]
        }
       return []
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
//        let item = collectionView == contentView.suggestedCollectionView ? viewModel.favorites[indexPath.row].workouts[0] : viewModel.workoutList[indexPath.row]
//        let itemProvider = NSItemProvider(object: item.uuid.uuidString as NSString)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = item
//        return [dragItem]
        
        if collectionView == contentView.suggestedCollectionView {
            print("suggestedCollectionView Drop")
            return []
            
        } else if collectionView == contentView.workoutListCollectionView {
            print("workoutListCollectionView Drop")
            return []
        }
        
        return []
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
        return collectionView == contentView.suggestedCollectionView ? viewModel.favorites.count : viewModel.workoutList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.contentView.suggestedCollectionView {
            
            //MAKR: - Last Trailer
            if indexPath.item == viewModel.favorites.count - 1 {
                guard
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteLastCollectionViewCell.identifier,
                                                                  for: indexPath) as? FavoriteLastCollectionViewCell
                else { return UICollectionViewCell() }
                return cell
                
            } else {
                //MARK: - usual favorites
                guard
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier,
                                                                  for: indexPath) as? FavoriteCollectionViewCell
                else { return UICollectionViewCell() }
                cell.configure(with: viewModel.favorites[indexPath.item])
                return cell
            }
               
        } else {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutlistCollectionViewCell.identifier,
                                                                for: indexPath) as? WorkoutlistCollectionViewCell
            else {return UICollectionViewCell()}
            cell.configure(with: viewModel.workoutList[indexPath.item], mode: viewModel.mode)
            cell.delegate = self
            cell.tag = indexPath.item
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension WorkoutListViewController2: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === contentView.workoutListCollectionView {
            self.showWorkoutSetupViewController(for: .edit, didSelect: viewModel.workoutList[indexPath.item])
        } else {
            if indexPath.item == viewModel.favorites.count - 1 {
                let vm = FavoriteDetailViewModel()
                let vc = FavoriteDetailViewController(viewModel: vm)
                let nav = UINavigationController(rootViewController: vc)
//                present(nav, animated: true)
//                viewModel.pushThis(vc)
                
                viewModel.presentThis(nav)
            }
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension WorkoutListViewController2: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == contentView.suggestedCollectionView {
            if indexPath.item == viewModel.favorites.count - 1 {
                return CGSize(width: FavoriteLastCollectionViewCell.preferredHeight,
                              height: FavoriteLastCollectionViewCell.preferredHeight)
            } else {
                guard let name = viewModel.favorites[indexPath.item].name else { return .init() }
                let width = name.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]).width + 48
                let height: CGFloat = 39
                return CGSize(width: width, height: height)
            }
        } else {
            return .init(width: UIScreen.main.bounds.width - 32, height: 78)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView === contentView.suggestedCollectionView {
            return .init(top: 0, left: 16, bottom: 0, right: 16)
        }
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
}

//MARK: - WorkoutSetupViewControllerDelegate
extension WorkoutListViewController2: WorkoutSetupViewControllerDelegate {
    func workoutSetupDidTapDone(with models: [WorkoutModel], type: WorkoutSetupType) {
        self.viewModel.dismiss()
        switch type {
        case .edit:
            self.viewModel.editWorkout(with: models.first)
        case .add:
            self.viewModel.setupWorkout(with: models)
        }
        
        self.contentView.suggestedCollectionView.reloadData()
        self.contentView.workoutListCollectionView.reloadData()
        self.scrollToLast()
    }
    
//    func workoutSetupDidTapDone(with model: WorkoutModel?, for type: WorkoutSetupType, set: Int) {
//        self.viewModel.dismiss()
//        self.viewModel.setupWorkout(with: model, for: type, set: set)
//        self.contentView.suggestedCollectionView.reloadData()
//        self.contentView.workoutListCollectionView.reloadData()
//        self.scrollToLast()
//    }
//
    func workoutSetupDidTapCancel() {
        self.viewModel.dismiss()
    }
}

//MARK: - ContentViewControllerDelegate
extension WorkoutListViewController2: ContentViewControllerDelegate {
    func contentViewControllerDidTapDismiss() {
        viewModel.dismiss()
    }
    
    func didSelectDate(_ date: Date) {
        contentView.scrollToDate(date)
        contentView.updateCalendarTitleButton(date)
        viewModel.didSelectDate(date.stripTime())
    }
}

//MARK: - WorkoutlistCollectionViewCellDelegate
extension WorkoutListViewController2: WorkoutlistCollectionViewCellDelegate {
    func workoutlistCollectionViewCellDidTapComplete(_ isTapped: Bool, indexPathRow: Int) {
        viewModel.updateIsComplete(isTapped, at: indexPathRow)
    }
}
