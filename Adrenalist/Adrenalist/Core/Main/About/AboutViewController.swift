//
//  AboutViewController.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/05/04.
//
import CombineCocoa
import Combine
import UIKit.UIViewController

final class AboutViewController: UIViewController {
    private let contentView = AboutView()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        super.loadView()
        view = contentView
        
        navigationItem.setRightBarButton(contentView.dismissButton, animated: true)
        
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                case .dismiss:
                    self.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
    }
}
