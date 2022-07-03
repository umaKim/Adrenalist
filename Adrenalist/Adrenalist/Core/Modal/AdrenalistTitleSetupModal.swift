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
    private lazy var modal = AdrenalistTitleSetupModal()
    
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


enum AdrenalistTitleSetupModalAction {
    case titleDidChange(String)
    case confirmDidTap
    case cancelDidTap
}

class AdrenalistTitleSetupModal: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private var actionSubject = PassthroughSubject<AdrenalistTitleSetupModalAction, Never>()
    
    private lazy var setupTitle: UILabel = {
       let lb = UILabel()
        lb.text = "Set name"
        return lb
    }()
    
    private lazy var titleTextField = AdrenalistTextField(placeHolder: "Title")
    
    private lazy var confirmButton = AdrenalistTextRectangleButton(title: "confirm")
    private lazy var cancelButton = AdrenalistTextRectangleButton(title: "cancel")
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        titleTextField
            .textPublisher
            .receive(on: RunLoop.main)
            .compactMap({$0})
            .sink { text in
                self.actionSubject.send(.titleDidChange(text))
            }
            .store(in: &cancellables)
        
        confirmButton.tapPublisher.sink { _ in
            self.actionSubject.send(.confirmDidTap)
        }
        .store(in: &cancellables)
        
        cancelButton.tapPublisher.sink { _ in
            self.actionSubject.send(.cancelDidTap)
        }
        .store(in: &cancellables)
    }
    
    private func setupUI() {
        backgroundColor = .blue
        let sv = UIStackView(arrangedSubviews: [setupTitle, titleTextField])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        
        let buttonSv = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        buttonSv.axis = .horizontal
        buttonSv.spacing = 8
        buttonSv.alignment = .fill
        buttonSv.distribution = .fillEqually
        
        [sv, buttonSv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonSv.topAnchor.constraint(equalTo: sv.bottomAnchor, constant: 8),
            buttonSv.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
