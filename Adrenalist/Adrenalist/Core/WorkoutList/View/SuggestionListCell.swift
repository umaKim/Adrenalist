//
//  SuggestionListCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/30.
//

import Combine
import UIKit.UICollectionViewCell

protocol SuggestionListCellDelegate: AnyObject {
    func suggestionDidTapEdit(id: UUID)
    func suggestionDidTapDelete(id: UUID)
}

final class SuggestionListCell: UICollectionViewCell, Shakeable {
    static let identifier = "SuggestionListCell"
    
    lazy var caLayer: CALayer = self.layer
    
    private lazy var editButton     = AdrenalistImageButton(image: UIImage(systemName: Constant.ButtonImage.pencilCircle))
    private lazy var deleteButton   = AdrenalistImageButton(image: UIImage(systemName: Constant.ButtonImage.xmarkCircle))
    private lazy var titleLabel     = AdrenalistLabel(text: "")
    private lazy var repsLabel      = AdrenalistLabel(text: "")
    private lazy var weightLabel    = AdrenalistLabel(text: "")
    
    private var cancellables: Set<AnyCancellable>
    
    weak var delegate: SuggestionListCellDelegate?
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .green
        
        layer.cornerRadius = 12
        
        [editButton, deleteButton, titleLabel, repsLabel, weightLabel].forEach { uv in
            self.contentView.addSubview(uv)
            uv.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            editButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 5),
            
            repsLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 16),
            repsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            weightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private var uuid: UUID?
    
    private func bind() {
        deleteButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let id = self?.uuid else {return }
                self?.delegate?.suggestionDidTapDelete(id: id)
            }
            .store(in: &cancellables)
        
        editButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let id = self?.uuid else {return }
                self?.delegate?.suggestionDidTapEdit(id: id)
            }
            .store(in: &cancellables)
    }
    
    func configure(with workout: Item, mode: UpdateMode?) {
        titleLabel.text = workout.title
    
        uuid = workout.uuid
        
        if let reps = workout.reps {
            repsLabel.text = "\(reps)"
        }
        
        if let weight = workout.weight {
            weightLabel.text = "\(weight) kg"
        }
        
        switch mode {
        case .delete:
            deleteButton.isHidden = false
            editButton.isHidden = true
//            circleButton.isHidden = true
            shakeIcons()
            
        case .edit:
            deleteButton.isHidden = true
            editButton.isHidden = false
//            circleButton.isHidden = true
            shakeIcons()
            
        case .none:
            deleteButton.isHidden = true
            editButton.isHidden = true
//            circleButton.isHidden = false
            stopShakingIcons(completion: {
                self.deleteButton.isHidden = true
            })
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
