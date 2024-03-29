//
//  AdrenalistTitleView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/17.
//
import Combine
import UIKit

enum AdrenalistTitleViewAction{
    case titleTextFieldDidChange(String)
//    case isStarButtonSelected(Bool)
    case done
}

final class AdrenalistTitleView: UIView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdrenalistTitleViewAction, Never>()
    
    private let titleTextField = UITextField()
    
    func setupTitleTextField(_ text: String) {
        self.titleTextField.text = text
    }
    
    func setupPlaceholder(_ text: String) {
        self.titleTextField.placeholder = text
    }
    
    private var cancellables: Set<AnyCancellable>
    
    init(placeholder: String) {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        titleTextField.placeholder = placeholder
        
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        titleTextField
            .textPublisher
            .sink {[weak self] text in
                guard let self = self else { return }
                self.actionSubject.send(.titleTextFieldDidChange(text ?? ""))
            }
            .store(in: &cancellables)
        
        doneBarButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.actionSubject.send(.done)
            }
            .store(in: &cancellables)
    }
    
    private let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.titleTextField.inputAccessoryView = keyboardToolbar
    }
    
    private func setupUI() {
        setDoneOnKeyboard()
        
        layer.cornerRadius = 20
        
        backgroundColor = .grey2
        
        let sv = UIStackView(arrangedSubviews: [titleTextField])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: centerYAnchor),
            sv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
