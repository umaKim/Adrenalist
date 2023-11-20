//
//  SetupFavoriteSetViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/07/12.
//

import Combine
import UIKit

protocol SetupFavoriteSetViewControllerDelegate: AnyObject {
    func setupFavoriteDidTapDone()
    func setupFavoriteDidTapCancel()
}

class SetupFavoriteSetViewController: UIViewController {
    private let contentView = SetupFavoriteSetView()
    
    weak var delegate: SetupFavoriteSetViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    private let viewModel: SetupFavoriteSetViewModel
    
    init(_ viewModel: SetupFavoriteSetViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    private var cancellables: Set<AnyCancellable>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItems = [contentView.dismissButton]
        navigationItem.rightBarButtonItems = [contentView.confirmButton, contentView.deleteButton, contentView.addButton]
        
        contentView.isModal = isModal
        contentView.workoutListCollectionView.delegate = self
        contentView.workoutListCollectionView.dataSource = self
        
        contentView.setSetName(viewModel.setName)
        
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                switch action {
                case .confirm:
                    self.viewModel.didTapDone()
                    self.delegate?.setupFavoriteDidTapDone()
                    
                case .dismiss:
                    self.delegate?.setupFavoriteDidTapCancel()
                    
                case .addNewWorkout:
                    self.showWorkoutSetupViewController(
                        for: .add,
                        didSelect: WorkoutModel(
                            title: "",
                            isFavorite: false,
                            isSelected: false,
                            isDone: false
                        )
                    )
                    
                case .delete:
                    self.viewModel.changeMode(.delete)
                    
                case .bottomSheetDidTapDelete:
                    self.viewModel.delete()
                    self.viewModel.changeMode(.none)
                    
                case .bottomSheetDidTapCancel:
                    self.viewModel.changeMode(.none)
                    
                case .titleTextFieldDidChange(let text):
                    self.viewModel.setupSetName(text)
                    
                case .titleTextFieldViewDidDismissKeyboard:
                    self.view.endEditing(true)
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[weak self] noti in
                guard let self = self else { return }
                switch noti {
                case .reload:
                    self.contentView.workoutListCollectionView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showWorkoutSetupViewController(for type: WorkoutSetupType, didSelect model: WorkoutModel) {
        let vm = WorkoutSetupViewModel(workout: model, type: type)
        let vc = WorkoutSetupViewController(viewModel: vm)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SetupFavoriteSetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.workoutList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutlistCollectionViewCell.identifier, for: indexPath) as? WorkoutlistCollectionViewCell else {return UICollectionViewCell()}
        cell.configure(with: viewModel.workoutList[indexPath.item], mode: viewModel.mode)
        cell.delegate = self
        cell.tag = indexPath.item
        return cell
    }
}

extension SetupFavoriteSetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showWorkoutSetupViewController(for: .edit, didSelect: viewModel.workoutList[indexPath.item])
    }
}

extension SetupFavoriteSetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.width - 32, height: 78)
    }
}

extension SetupFavoriteSetViewController: WorkoutSetupViewControllerDelegate {
    func workoutSetupDidTapDone(with models: [WorkoutModel], type: WorkoutSetupType) {
        self.dismiss(animated: true)
        switch type {
        case .edit:
            self.viewModel.editWorkout(with: models.first)
        case .add:
            self.viewModel.setupWorkout(with: models)
        }
        
        self.contentView.workoutListCollectionView.reloadData()
        self.scrollToLast()
    }
    
    private func scrollToLast() {
        let lastItemIndex = IndexPath(item: viewModel.workoutList.count - 1, section: 0)
        contentView.workoutListCollectionView.scrollToItem(at: lastItemIndex, at: .bottom, animated: true)
    }
    
    func workoutSetupDidTapCancel() {
        self.dismiss(animated: true)
    }
}

extension SetupFavoriteSetViewController: WorkoutlistCollectionViewCellDelegate {
    func workoutlistCollectionViewCellDidTapComplete(_ isTapped: Bool, indexPathRow: Int) {
        viewModel.updateIsComplete(isTapped, at: indexPathRow)
    }
}
