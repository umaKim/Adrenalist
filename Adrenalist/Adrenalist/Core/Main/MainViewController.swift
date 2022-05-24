//
//  MainViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import FloatingPanel
import Combine
import UIKit.UIViewController

final class MainViewController: UIViewController {
    
    private let contentView = MainView()
    private var cancellables: Set<AnyCancellable>
    
    private var panel: FloatingPanelController?
    private var vc: WorkoutListViewController?
    
    private var panelState = PassthroughSubject<FloatingPanelState, Never>()
    
    init() {
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
        
        setupCollectionView()
        setUpFloatingPanel(with: panelState)
    }
    
    private func bind() {
        contentView
            .collectionView
            .contentOffsetPublisher
            .filter({[weak self] _ in
                self?.view.frame.width != 0
            })
            .sink {[weak self] offset in
                self?.panelHiddenStatus(with: offset)
            }
            .store(in: &cancellables)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .top, animated: false)
    }
    
    private func setupCollectionView() {
        contentView.collectionView.delegate     = self
        contentView.collectionView.dataSource   = self
    }
    
    private func panelHiddenStatus(with contentOffSet: CGPoint) {
        let index = Int(contentOffSet.x / view.frame.width)
        UIView.animate(withDuration: 1) {
            self.panel?.surfaceView.isHidden = index == 1 ? false : true
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCollectionViewCell.identifier, for: indexPath) as? SettingCollectionViewCell else {return UICollectionViewCell()}
            cell.configure()
            cell.action
                .sink { action in
                    switch action {
                    case .workout:
                        self.scrollTo(index: 1)
                    }
                }
                .store(in: &cancellables)
            
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutCollectionViewCell.identifier, for: indexPath) as? WorkoutCollectionViewCell else {return UICollectionViewCell()}
            cell.configure(panelState)
            cell.action
                .sink { action in
                    switch action {
                    case .setting:
                        self.scrollTo(index: 0)
                        
                    case .workout:
                        break
                        
                    case .calendar:
                        self.scrollTo(index: 2)
                    }
                }
                .store(in: &cancellables)
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutHistoryCollectionViewCell.identifier, for: indexPath) as? WorkoutHistoryCollectionViewCell else {return UICollectionViewCell()}
            cell.configure()
            cell.action
                .sink { action in
                    switch action {
                    case .workout:
                        self.scrollTo(index: 1)
                    }
                }
                .store(in: &cancellables)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    private func scrollTo(index: Int) {
        contentView.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: collectionView.frame.height)
    }
}

//MARK: - FloatingPanelControllerDelegate
extension MainViewController: FloatingPanelControllerDelegate  {
    /// Sets up floating news panel
    private func setUpFloatingPanel(with panelState: PassthroughSubject<FloatingPanelState, Never>) {
        let viewModel = WorkoutListViewModel(panelState: panelState)
        vc = WorkoutListViewController(viewModel: viewModel)
        panel = FloatingPanelController()
        panel?.delegate = self
        panel?.set(contentViewController: UINavigationController(rootViewController: vc ?? UIViewController()))
        panel?.addPanel(toParent: self)
        panel?.track(scrollView: vc?.contentView.workoutListCollectionView ?? UIScrollView())
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 10
        appearance.backgroundColor = .black
        panel?.surfaceView.grabberHandle.isHidden = true
        panel?.surfaceView.appearance = appearance
    }
    
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        panelState.send(fpc.state)
        animateAlpha(isShown: fpc.state == .tip)
    }
    
    private func animateAlpha(isShown: Bool) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {[unowned self] in
            vc?.contentView.updateButton.tintColor          = .pinkishRed.withAlphaComponent(isShown ? 0 : 1)
            vc?.contentView.addWorkoutButton.tintColor      = .pinkishRed.withAlphaComponent(isShown ? 0 : 1)
            vc?.contentView.suggestedCollectionView.alpha   = isShown ? 0 : 1
            vc?.contentView.workoutListCollectionView.alpha = isShown ? 0 : 1
            vc?.contentView.upwardImageView.alpha = isShown ? 1 : 0
        }, completion: { _ in
            print("Animate")
        })
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
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 50, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
