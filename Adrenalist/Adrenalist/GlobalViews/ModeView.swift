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
    case tapDeleteButton(Bool)
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
        bt.setPreferredSymbolConfiguration(.init(pointSize: 27), forImageIn: .normal)
        return bt
    }()
    
    private let deleteButton: UIButton = {
       let bt = UIButton()
        bt.setImage(CheckButtonImage.delete, for: .normal)
        bt.tintColor = .red
        bt.setPreferredSymbolConfiguration(.init(pointSize: 27), forImageIn: .normal)
        return bt
    }()
    
    enum CheckButtonImage {
        static let check = UIImage(systemName: "checkmark.circle.fill")
        static let circle = UIImage(systemName: "circle")
        
        static let delete = UIImage(systemName: "minus.circle")
        static let deleteFill = UIImage(systemName: "minus.circle.fill")
    }
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        bind()
        setupUI()
    }
    
//    convenience init (mode: WorkoutListCellMode) {
//        self.init(frame: .zero)
////        self.updateMode(mode)
//        
//    }
    
    private func showDeleteButton() {
        deleteButton.isHidden = false
        checkButton.isHidden = true
    }
    
    private func showCheckButton() {
//        moveableImageView.isHidden = true
        deleteButton.isHidden = true
        checkButton.isHidden = false
    }
    
    private func showMoveableImageView() {
//        moveableImageView.isHidden = false
        checkButton.isHidden = true
    }
    
    private func hideAll() {
//        moveableImageView.isHidden = true
        checkButton.isHidden = true
    }
    
    @Published private var mode: WorkoutListCellMode = .complete
    
    func updateMode(_ mode: WorkoutListCellMode, of model: WorkoutModel) {
        self.mode = mode
        
//        if let isComplete = isComplete {
//            self.isCheckButtonTapped = isComplete
//            self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.check : CheckButtonImage.circle,
//                                      for: .normal)
//        }
        
        switch mode {
        case .complete:
            self.isCheckButtonTapped = model.isDone
            self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.check : CheckButtonImage.circle,
                                      for: .normal)
            
        case .delete:
            self.isDeleteButtonTapped = model.isSelected
            self.deleteButton.setImage(self.isDeleteButtonTapped ? CheckButtonImage.deleteFill : CheckButtonImage.delete,
                                      for: .normal)
            
        default:
            break
        }
    }
    
    private var isDeleteButtonTapped = false
    private var isCheckButtonTapped = false
    
    private func bind() {
        deleteButton
            .tapPublisher
            .sink { _ in
                self.isDeleteButtonTapped.toggle()
                self.deleteButton.setImage(self.isDeleteButtonTapped ? CheckButtonImage.deleteFill : CheckButtonImage.delete,
                                          for: .normal)
                self.actionSubject.send(.tapDeleteButton(self.isDeleteButtonTapped))
            }
            .store(in: &cancellables)
        
        checkButton
            .tapPublisher
            .sink { _ in
                self.isCheckButtonTapped.toggle()
                self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.check : CheckButtonImage.circle,
                                          for: .normal)
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
                    self.showDeleteButton()
                
//                case .normal:
//                    self.hideAll()
                    
                case .complete:
                    self.showCheckButton()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        deleteButton.tintColor = .red
        checkButton.tintColor = .purpleBlue
        
        [deleteButton, checkButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            self.deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.deleteButton.topAnchor.constraint(equalTo: topAnchor),
            
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
