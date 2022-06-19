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
    case isStarButtonSelected(Bool)
}

final class AdrenalistTitleView: UIView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdrenalistTitleViewAction, Never>()
    
    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "titleTextField"
        return tf
    }()
    
    private let starButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "star"), for: .normal)
        bt.widthAnchor.constraint(equalToConstant: 32).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return bt
    }()
    
    private var starStatus: Bool = false
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        titleTextField
            .textPublisher
            .sink { text in
                self.actionSubject.send(.titleTextFieldDidChange(text ?? ""))
            }
            .store(in: &cancellables)
        
        starButton
            .tapPublisher
            .sink { _ in
                self.starStatus.toggle()
                self.actionSubject.send(.isStarButtonSelected(self.starStatus))
                let image: UIImage? = self.starStatus ? .init(systemName: "star.fill") : .init(systemName: "star")
                self.starButton.setImage(image, for: .normal)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        layer.cornerRadius = 20
        
        backgroundColor = .grey2
        
        let sv = UIStackView(arrangedSubviews: [titleTextField, starButton])
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
