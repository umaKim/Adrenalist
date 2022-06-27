//
//  ModeView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/27.
//

import UIKit

enum ModeViewAction {
    case tapCheckButton(Bool)
}

final class ModeView: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<ModeViewAction, Never>()
    
    private var cancellables: Set<AnyCancellable>
    
    private let moveableImageView = UIImageView(image: UIImage(systemName: "line.3.horizontal"))
    
    private let checkButton: UIButton = {
        let bt = UIButton()
        bt.setImage(CheckButtonImage.circle, for: .normal)
        bt.tintColor = .purpleBlue
        return bt
    }()
    
    enum CheckButtonImage {
        static let check = UIImage(systemName: "checkmark.circle.fill")
        static let circle = UIImage(systemName: "circle")
    }
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        bind()
        setupUI()
    }
    
    convenience init (mode: WorkoutListCellMode) {
        self.init(frame: .zero)
        self.updateMode(mode)
    }
    
    private func showCheckButton() {
        moveableImageView.isHidden = true
        checkButton.isHidden = false
    }
    
    private func showMoveableImageView() {
        moveableImageView.isHidden = false
        checkButton.isHidden = true
    }
    
    private func hideAll() {
        moveableImageView.isHidden = true
        checkButton.isHidden = true
    }
    
    func updateMode(_ mode: WorkoutListCellMode) {
        switch mode {
        case .reorder:
            showMoveableImageView()
            
        case .psotpone:
            showCheckButton()
        
        case .delete:
            showCheckButton()
        
        case .normal:
            hideAll()
        }
    }
    
    private var isCheckButtonTapped = false
    
    private func bind() {
        checkButton.tapPublisher.sink { _ in
            self.isCheckButtonTapped.toggle()
            self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.check : CheckButtonImage.circle,
                                      for: .normal)
            self.actionSubject.send(.tapCheckButton(self.isCheckButtonTapped))
        }
        .store(in: &cancellables)
    }
    
    private func setupUI() {
        moveableImageView.tintColor = .purpleBlue
        checkButton.tintColor = .purpleBlue
        
        [moveableImageView, checkButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            self.moveableImageView.widthAnchor.constraint(equalToConstant: 24),
            self.moveableImageView.heightAnchor.constraint(equalToConstant: 24),
            self.moveableImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.moveableImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.moveableImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.moveableImageView.topAnchor.constraint(equalTo: topAnchor),
            
            self.checkButton.widthAnchor.constraint(equalToConstant: 24),
            self.checkButton.heightAnchor.constraint(equalToConstant: 24),
            self.checkButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.checkButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.checkButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.checkButton.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
