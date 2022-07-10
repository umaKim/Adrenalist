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
    
    private var isCheckButtonTapped = false
    
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
    
    convenience init(_ mode: WorkoutListCellMode) {
        self.init()
        self.mode = mode
    }
    
    func updateMode(_ mode: WorkoutListCellMode, of model: WorkoutModel) {
        self.mode = mode
        
        switch mode {
        case .complete:
            self.isCheckButtonTapped = model.isDone
            self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.check : CheckButtonImage.circle,
                                      for: .normal)
        case .delete:
            self.isCheckButtonTapped = model.isSelected
            self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.deleteFill : CheckButtonImage.delete,
                                      for: .normal)
        case .createSet:
            self.isCheckButtonTapped = model.isSelected
            self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.smallFill : CheckButtonImage.centerfill,
                                      for: .normal)
        case .none:
            self.checkButton.isHidden = true
            break
        }
    }
    
    private func bind() {
        checkButton
            .tapPublisher
            .sink { _ in
                self.isCheckButtonTapped.toggle()
                switch self.mode {
                case .complete:
                    self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.check : CheckButtonImage.circle,
                                              for: .normal)
                case .createSet:
                    self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.smallFill : CheckButtonImage.centerfill,
                                              for: .normal)
                case .delete:
                    self.checkButton.setImage(self.isCheckButtonTapped ? CheckButtonImage.deleteFill : CheckButtonImage.delete,
                                              for: .normal)
                case .none:
                    self.checkButton.isHidden = true
                }
                self.actionSubject.send(.tapCheckButton(self.isCheckButtonTapped))
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
                    
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func showDeleteButton() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
            self.checkButton.tintColor = .red
        } completion: { _ in }
    }
    
    private func showCheckButton() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
            self.checkButton.tintColor = .purpleBlue
        } completion: { _ in }
    }
    
    private func setupUI() {
        
        [checkButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
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
