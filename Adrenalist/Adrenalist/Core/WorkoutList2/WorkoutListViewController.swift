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
    
    private(set) lazy var bottomSheet = AdrenalistBottomSheet(with: contentVC,
                                                              height: UIScreen.main.height/2)
    
    private lazy var contentVC = ContentViewController()
    
    private lazy var bottomNavigationView = AdrenalistBottomNavigationBarView(with: [bt1, bt2, bt3], configurator: .init(height: 83, backgroundColor: .red))
    
    private let bt1: UIButton = {
       let bt = UIButton()
        bt.setTitle("bt1", for: .normal)
        return bt
    }()
    
    private let bt2: UIButton = {
       let bt = UIButton()
        bt.setTitle("bt2", for: .normal)
        return bt
    }()
    
    private let bt3: UIButton = {
       let bt = UIButton()
        bt.setTitle("bt3", for: .normal)
        return bt
    }()
    
    
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
        
        view.addSubview(bottomSheet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBottomNavigationView()
        
        showBottomNavigationView()
        
        bt1.tapPublisher.sink { _ in
            self.hideBottomNavigationView()
        }
        .store(in: &cancellables)
    }
    
    private func setupBottomNavigationView() {
        view.addSubview(bottomNavigationView)
//        bottomNavigationView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func showBottomNavigationView() {
        let window = UIApplication.shared.windows.first
        let bottomPadding = window?.safeAreaInsets.bottom
        
        print(64 + bottomPadding! + 16)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.bottomNavigationView.frame.origin = .init(x: 0, y: UIScreen.main.height - 64 - bottomPadding! - 16)
        } completion: { _ in }
    }
    
    private func hideBottomNavigationView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.bottomNavigationView.frame.origin = .init(x: 0, y: UIScreen.main.height)
        } completion: { _ in }
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
    
    private func isToolBarHidden(_ isHidden: Bool, toolBarButtonType: ToolBarButtonType) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.navigationController?.isToolbarHidden = isHidden
        } completion: { _ in }

        var items = [UIBarButtonItem]()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        items.append( cancelButton )
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        
        switch toolBarButtonType {
        case .done:
            toolBarButton = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil)
            
        case .delete:
            toolBarButton = UIBarButtonItem(title: "Delete", style: .plain, target: nil, action: nil)
            
        case .move:
            toolBarButton = UIBarButtonItem(title: "Move", style: .plain, target: nil, action: nil)
        }
        
        guard let toolBarButton = toolBarButton else {return }
        items.append(toolBarButton)
        
        self.toolbarItems = items
        self.navigationController?.toolbar.backgroundColor = .lightDarkNavy
        
        toolBarButton.tapPublisher.sink(receiveValue: { _ in
            self.isToolBarHidden(true, toolBarButtonType: .done)
            self.isRightBarButtonItemsHidden(false)
        })
        .store(in: &cancellables)
        
        cancelButton.tapPublisher.sink { _ in
            self.cancelButtonDidTap()
        }
        .store(in: &cancellables)
    }
    
    private func cancelButtonDidTap() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.navigationController?.toolbar.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.contentView.isStartButtonHidden(false)
                self.contentView.startButton.alpha = 1
            } completion: { _ in }

        } completion: { _ in
//            self.contentView.isStartButtonHidden(false)
            self.isToolBarHidden(true, toolBarButtonType: .done)
            self.isRightBarButtonItemsHidden(false)
        }
    }
    
    private func isRightBarButtonItemsHidden(_ isHidden: Bool) {
        navigationItem.rightBarButtonItems = isHidden ? nil: [contentView.addButton]
    }
    
    var toolBarButton: UIBarButtonItem?
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                    
                case .addWorkoutButtonDidTap(_, _, _):
                    break
                case .edit:
                    break
                case .tapBackground:
                    break
                    
                case .add:
                    self.showWorkoutSetupViewController(for: "Add")
                    
                case .reorder:
                    self.isToolBarHidden(false, toolBarButtonType: .done)
                    self.isRightBarButtonItemsHidden(true)
                    break
                    
                case .postpone:
                    self.isToolBarHidden(false, toolBarButtonType: .move)
                    self.isRightBarButtonItemsHidden(true)
                    break
                    
                case .delete:
                    self.isToolBarHidden(false, toolBarButtonType: .delete)
                    self.isRightBarButtonItemsHidden(true)
                    break
                    
                case .tapTitleCalendar:
//                    self.bottomSheet.show()
//                    self.contentView.bottomSheet.show()
                    self.showMyViewControllerInACustomizedSheet()
                    
                    break
                }
            }
            .store(in: &cancellables)
        
        //        contentView
        //            .actionPublisher
        //            .sink {[weak self] action in
        //                guard let self = self else { return }
        //                switch action {
        //                case .addWorkoutButtonDidTap(let workout, let reps, let weight):
        //                    self.viewModel.addWorkout(for: workout, reps, weight)
        //
        //                case .edit:
        //                    self.viewModel.editMode()
        //
        //                case .delete:
        //                    self.viewModel.deleteMode()
        //
        //                case .tapBackground:
        //                    self.viewModel.noMode()
        //
        //                case .dismiss:
        //                    self.viewModel.dismiss()
        //                }
        //            }
        //            .store(in: &cancellables)
        
        //        viewModel
        //            .notifyPublisher
        //            .sink {[weak self] noti in
        //                guard let self = self else {return }
        //                switch noti {
        //                case .reloadSuggestions:
        //                    self.contentView.suggestedCollectionView.reloadData()
        //
        //                case .reloadWorkouts:
        //                    self.contentView.workoutListCollectionView.reloadData()
        //                    self.scrollToLast()
        //
        //                case.modeChanged(let mode):
        //                    self.mode = mode
        //                    self.contentView.suggestedCollectionView.reloadData()
        //                    self.contentView.workoutListCollectionView.reloadData()
        //
        //                case .delete(let index):
        //                    self.contentView.workoutListCollectionView.performBatchUpdates {
        //                        let indexPath = IndexPath(row: index, section: 0)
        //                        self.contentView.workoutListCollectionView.deleteItems(at: [indexPath])
        //                    }
        //                case .showKeyboard(let frame):
        //                    self.contentView.showKeyboard(frame)
        //
        //                case .hideKeyboard:
        //                    self.contentView.hideKeyboard()
        //
        //                case .fullPanel:
        //                    self.contentView.hideKeyboard()
        //
        //                case .tipPanel:
        //                    self.contentView.hideKeyboard()
        //                }
        //            }
        //            .store(in: &cancellables)
    }
    
    private func showWorkoutSetupViewController(for title: String) {
        let vc = WorkoutSetupViewController()
        vc.title = title
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .automatic
        self.present(nav, animated: true)
    }
    
    func showMyViewControllerInACustomizedSheet() {
        let viewControllerToPresent = ContentViewController()
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(viewControllerToPresent, animated: true, completion: nil)
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
