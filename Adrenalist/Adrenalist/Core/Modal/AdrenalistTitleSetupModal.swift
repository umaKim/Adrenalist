//
//  AdrenalistTitleSetupModal.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/07/03.
//

import CombineCocoa
import Combine
import UIKit

protocol ModalViewControllerDelegate: AnyObject {
    func modalDidTapCancel()
    func modalDidTapConfirm()
    func modalDidChangeText(_ text: String)
}

final class ModalViewController: UIViewController {
    private lazy var modal = AdrenalistTitleSetupModalView()
    
    weak var delegate: ModalViewControllerDelegate?
    
    init() {
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
        
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables: Set<AnyCancellable>
    
    private func bind() {
        modal.actionPublisher.sink { action in
            switch action {
            case .cancelDidTap:
                self.delegate?.modalDidTapCancel()
                
            case .titleDidChange(let text):
                self.delegate?.modalDidChangeText(text)
                
            case .confirmDidTap:
                self.delegate?.modalDidTapConfirm()
                
            }
        }.store(in: &cancellables)
    }
    
    private func setupUI() {
        [modal].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(uv)
        }
        
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        NSLayoutConstraint.activate([
            modal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modal.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modal.widthAnchor.constraint(equalToConstant: 200),
            modal.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}

