//
//  ModeView.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/27.
//

import CombineCocoa
import Combine
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
//        var config = UIButton.Configuration.plain()
//        config.imagePadding = 1
//        config.contentInsets = NSDirectionalEdgeInsets(top: 5,
//          leading: 5, bottom: 5, trailing: 5)
//        let bt = UIButton(configuration: config)
        let bt = UIButton()
        bt.setImage(CheckButtonImage.circle, for: .normal)
        bt.tintColor = .purpleBlue
//        bt.backgroundColor = .red
        bt.setPreferredSymbolConfiguration(.init(pointSize: 27), forImageIn: .normal)
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
    
    @Published private var mode: WorkoutListCellMode = .normal
    
    func updateMode(_ mode: WorkoutListCellMode, isComplete: Bool? = nil) {
        self.mode = mode
        
        if let isComplete = isComplete {
            self.isCheckButtonTapped = isComplete
            self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.check : CheckButtonImage.circle,
                                      for: .normal)
        }
    }
    
    private var isCheckButtonTapped = false
    
    private func bind() {
        checkButton
            .tapPublisher
            .sink { _ in
                self.isCheckButtonTapped.toggle()
                self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.check : CheckButtonImage.circle,
                                          for: .normal)
//                self.checkButton.configuration?.image = self.isCheckButtonTapped ? CheckButtonImage.check : CheckButtonImage.circle

                self.actionSubject.send(.tapCheckButton(self.isCheckButtonTapped))
            }
            .store(in: &cancellables)
        
//        self.checkButton.configurationUpdateHandler = { button in
////            print(button.isSelected)
////            print(button.isHighlighted)
//            self.isCheckButtonTapped.toggle()
//            button.configuration?.image = self.isCheckButtonTapped ? CheckButtonImage.check : CheckButtonImage.circle
////            button.configuration?.image?.withConfiguration(UIImage(systemName: self.isCheckButtonTapped ? CheckButtonImage.check : CheckButtonImage.circle,
////                                                                   withConfiguration: UIImage.SymbolConfiguration(scale: .large)))
//            self.actionSubject.send(.tapCheckButton(self.isCheckButtonTapped))
//        }
        
        $mode
            .sink { mode in
                switch mode {
                case .reorder:
                    self.showMoveableImageView()
                    
                case .psotpone:
                    self.showCheckButton()
                
                case .delete:
                    self.showCheckButton()
                
                case .normal:
                    self.hideAll()
                    
                case .complete:
                    self.showCheckButton()
                }
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
//            self.moveableImageView.widthAnchor.constraint(equalToConstant: 50),
//            self.moveableImageView.heightAnchor.constraint(equalToConstant: 50),
            self.moveableImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.moveableImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.moveableImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.moveableImageView.topAnchor.constraint(equalTo: topAnchor),
            
//            self.checkButton.widthAnchor.constraint(equalToConstant: 50),
//            self.checkButton.heightAnchor.constraint(equalToConstant: 50),
            self.checkButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.checkButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.checkButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.checkButton.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
