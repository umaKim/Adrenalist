//
//  WorkoutList.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/28.
//

import FloatingPanel
import Combine
import UIKit.UIViewController

final class WorkoutListViewController: UIViewController {
    
    private(set) lazy var contentView = WorkoutListView()
    
    private let viewModel: WorkoutListViewModel
    
    private var cancellables: Set<AnyCancellable>
    
    init(viewModel: WorkoutListViewModel) {
        self.cancellables = .init()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [contentView.addWorkoutButton]
        navigationItem.leftBarButtonItems = [contentView.edittingButton]
        
        bind()
        setupCollectionView()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                switch action {
                case .addWorkoutButtonDidTap:
                    let vm = ItemSetupViewModel()
                    let vc = ItemSetupViewController(viewModel: vm)
                    vc.delegate = self
                    self.present(vc, animated: true)
                    
                case .edittingButtonDidTap:
                    break
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .listenerPublisher
            .sink {[weak self] listener in
                guard let self = self else {return }
                switch listener {
                case .reloadWorkouts:
                    self.contentView.workoutListCollectionView.reloadData()
                    
                case .reloadSuggestions:
                    self.contentView.suggestedCollectionView.reloadData()
                }
            }
            .store(in: &cancellables)
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
        contentView.workoutListCollectionView.reorderingCadence = .slow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
        let itemProvider = NSItemProvider(object: item.uuid as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let item = collectionView == contentView.suggestedCollectionView ? viewModel.suggestions[indexPath.row] : viewModel.workouts[indexPath.row]
        let itemProvider = NSItemProvider(object: item.uuid as NSString)
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
            cell.configure(with: viewModel.suggestions[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutListCell.identifier, for: indexPath) as? WorkoutListCell else {return UICollectionViewCell()}
            cell.configure(with: viewModel.workouts[indexPath.item])
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension WorkoutListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didTapCell(at: indexPath.item)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension WorkoutListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == contentView.suggestedCollectionView {
            return .init(width: UIScreen.main.bounds.width / 3, height: 40)
        } else {
            return .init(width: UIScreen.main.bounds.width - 50, height: 60)
        }
    }
}

