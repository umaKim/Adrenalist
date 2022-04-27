//
//  WorkoutViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import FloatingPanel
import Combine
import CombineCocoa
import UIKit.UIViewController

final class WorkoutViewController: UIViewController {
    
    private let contentView = WorkoutView()
    
    private let viewModel: WorkoutViewModel
    
    private var cancellables: Set<AnyCancellable>
    
    init(viewModel: WorkoutViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupUI()
        setUpFloatingPanel()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                case .didTapCalendar:
                    self.viewModel.didTapCalendar()
                    
                case .didTapSetting:
                    self.viewModel.didTapSetting()
                    
                case .doubleTap:
                    self.viewModel.didDoubleTap()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        navigationController?.navigationBar.tintColor = .red
        navigationItem.leftBarButtonItems = [contentView.settingButton]
        navigationItem.rightBarButtonItems = [contentView.calendarButton]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - FloatingPanelControllerDelegate
extension WorkoutViewController: FloatingPanelControllerDelegate  {
    /// Sets up floating news panel
    private func setUpFloatingPanel() {
        let viewModel = WorkoutListViewModel()
        let vc = WorkoutListViewController(viewModel: viewModel)
        let panel = FloatingPanelController(delegate: self)
        panel.set(contentViewController: UINavigationController(rootViewController: vc))
        panel.addPanel(toParent: self)
        panel.track(scrollView: vc.collectionView)
        
        let appearance = SurfaceAppearance()
        appearance.backgroundColor = .systemBackground
        appearance.cornerRadius = 10
        panel.surfaceView.appearance = appearance
    }
    
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        MyFloatingPanelLayout()
    }
}

final class MyFloatingPanelLayout: FloatingPanelLayout {
    
    var position: FloatingPanelPosition {
        return .bottom
    }
    
    var initialState: FloatingPanelState {
        return .tip
    }
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] { // 가능한 floating panel: 현재 full, half만 가능하게 설정
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: UIScreen.main.bounds.height - 150, edge: .bottom, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(absoluteInset: UIScreen.main.bounds.height / 2, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 50, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}

final class WorkoutListViewController: UIViewController {
    private let edittingButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .done, target: nil, action: nil)
    private let addWorkoutButton = UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .done, target: nil, action: nil)
    
    private(set) lazy var suggestBarView: SuggestBarView = SuggestBarView()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(WorkoutListCell.self, forCellWithReuseIdentifier: WorkoutListCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.dropDelegate = self
        return cv
    }()
    
    private let viewModel: WorkoutListViewModel
    
    init(viewModel: WorkoutListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItems = [addWorkoutButton]
        navigationItem.leftBarButtonItems = [edittingButton]
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(suggestBarView)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            suggestBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            suggestBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            suggestBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            suggestBarView.heightAnchor.constraint(equalToConstant: 60),
            
            collectionView.topAnchor.constraint(equalTo: suggestBarView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WorkoutListViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
    }
}

extension WorkoutListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutListCell.identifier, for: indexPath) as? WorkoutListCell else {return UICollectionViewCell() }
        cell.backgroundColor = .red
        return cell
    }
}

extension WorkoutListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didTap cell")
    }
}

extension WorkoutListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.bounds.width - 50, height: 60)
    }
}

final class WorkoutListViewModel  {
    func didTapCell() {
        
    }
}

final class WorkoutListCell: UICollectionViewCell {
    static let identifier = "WorkoutListCell"
}
