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
    
    @Published private var mode: WorkoutListCellMode = .complete
    
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
        
        static let centerfill = UIImage(systemName: "smallcircle.fill.circle")
        static let smallFill = UIImage(systemName: "smallcircle.fill.circle.fill")
    }
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        bind()
        setupUI()
    }
    
    private func showDeleteButton() {
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveLinear) {
            self.deleteButton.isHidden = false
            self.checkButton.isHidden = true
        } completion: { _ in }
    }
    
    private func showCheckButton() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
            self.deleteButton.isHidden = true
            self.checkButton.isHidden = false
        } completion: { _ in }
    }
    
    func updateMode(_ mode: WorkoutListCellMode, of model: WorkoutModel) {
        self.mode = mode
        
        switch mode {
        case .complete:
            self.isCheckButtonTapped = model.isDone
            self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.check : CheckButtonImage.circle,
                                      for: .normal)
            
        case .delete:
            self.isDeleteButtonTapped = model.isSelected
            self.deleteButton.setImage(self.isDeleteButtonTapped ? CheckButtonImage.deleteFill : CheckButtonImage.delete,
                                      for: .normal)
        case .createSet:
            self.isCheckButtonTapped = model.isSelected
            self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.smallFill : CheckButtonImage.centerfill,
                                      for: .normal)
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
               
                
                switch self.mode {
                case .complete:
                    self.isCheckButtonTapped.toggle()
                    self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.check : CheckButtonImage.circle,
                                              for: .normal)
                    self.actionSubject.send(.tapCheckButton(self.isCheckButtonTapped))
                    
                case .createSet:
                    self.isCheckButtonTapped.toggle()
                    self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.smallFill : CheckButtonImage.circle,
                                              for: .normal)
                    self.actionSubject.send(.tapCheckButton(self.isCheckButtonTapped))
                    
                case .delete:
                    break
                }
                
            }
            .store(in: &cancellables)
        
        $mode
            .sink { mode in
                switch mode {
                case .delete:
                    self.showDeleteButton()
                
                case .complete:
                    self.showCheckButton()
                    
                case .createSet:
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
