//
//  ModalViewController.swift
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
        
       
    }
    
    override func loadView() {
        super.loadView()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables: Set<AnyCancellable>
    
    private func bind() {
        modal
            .actionPublisher
            .sink {action in
//                guard let self = self else { return }
                switch action {
                case .cancelDidTap:
                    self.delegate?.modalDidTapCancel()
                    
                case .titleDidChange(let text):
                    self.delegate?.modalDidChangeText(text)
                    
                case .confirmDidTap:
                    self.delegate?.modalDidTapConfirm()
                    
                case .titleTextFieldDidTapDone:
                    //                self.delegate?.modalDidDismissKeyboard()
                    self.view.endEditing(true)
                }
            }
            .store(in: &cancellables)
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
//            modal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
//            modal.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
//            modal.heightAnchor.constraint(equalToConstant: UIScreen.main.width - 32),
        ])
    }
}

