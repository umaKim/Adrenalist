//
//  WorkoutViewController.swift
//  RealAdrenalist
//
//  Created by 김윤석 on 2022/04/26.
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
