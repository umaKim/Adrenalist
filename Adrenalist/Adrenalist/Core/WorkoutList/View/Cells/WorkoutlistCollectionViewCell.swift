//
//  WorkoutlistCollectionViewCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/15.
//
import Combine
import UIKit

final class WorkoutlistCollectionViewCell: UICollectionViewCell {
    static let identifier = "WorkoutlistCollectionViewCell"
    
    private lazy var checkCircleButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(systemName: "circle"), for: .normal)
        bt.widthAnchor.constraint(equalToConstant: 24).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 24).isActive = true
        bt.isHidden = true
        return bt
    }()
    
    private lazy var moveableMarkView: UIImageView = {
       let uv = UIImageView(image: UIImage(systemName: "line.3.horizontal"))
        uv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        uv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        uv.isHidden = true
        return uv
    }()
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .white
        lb.font = .boldSystemFont(ofSize: 17)
        return lb
    }()
    
    private lazy var repsLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = .boldSystemFont(ofSize: 16)
        return lb
    }()
    
    private lazy var weightLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = .boldSystemFont(ofSize: 16)
        return lb
    }()
    
    private lazy var timerLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = .boldSystemFont(ofSize: 16)
        return lb
    }()
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
//        setupUI()
        backgroundColor = .navyGray
    }
    
    private var isChecked: Bool?
    
    private var cancellables: Set<AnyCancellable>
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        switch model?.mode {
//        case .normal:
//            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
//                self.checkCircleButton.isHidden = true
//                self.moveableMarkView.isHidden = true
//            } completion: { _ in }
//
//        case .reorder:
//            UIView.animate(withDuration: 1, delay: 0, options: .showHideTransitionViews) {
//                self.checkCircleButton.isHidden = true
//                self.moveableMarkView.isHidden = false
//            } completion: { _ in }
//            
//        case .psotpone:
//            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
//                self.checkCircleButton.isHidden = false
//                self.moveableMarkView.isHidden = true
//            } completion: { _ in }
//            
//        case .delete:
//            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
//                self.checkCircleButton.isHidden = false
//                self.moveableMarkView.isHidden = true
//            } completion: { _ in }
//        case .none:
//            break
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var model: WorkoutModel?
    
    func configure(with model: WorkoutModel) {
        self.model = model
        
        self.isChecked = model.isSelected
        
//        switch model.mode {
//        case .normal:
//            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
//                self.checkCircleButton.isHidden = true
//                self.moveableMarkView.isHidden = true
//            } completion: { _ in }
//
//        case .reorder:
//            UIView.animate(withDuration: 1, delay: 0, options: .showHideTransitionViews) {
//                self.checkCircleButton.isHidden = true
//                self.moveableMarkView.isHidden = false
//            } completion: { _ in }
//
//        case .psotpone:
//            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
//                self.checkCircleButton.isHidden = false
//                self.moveableMarkView.isHidden = true
//            } completion: { _ in }
//
//        case .delete:
//            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
//                self.checkCircleButton.isHidden = false
//                self.moveableMarkView.isHidden = true
//            } completion: { _ in }
//        }
        
        self.titleLabel.text = model.title
        
        if let reps = model.reps{
            self.repsLabel.text = "\(reps) x "
        }
        
        if let weight = model.weight {
            self.weightLabel.text = "\(weight) Kg"
        }
        
        if let timer = model.timer {
            self.timerLabel.text = "\(timer) sec"
        }
        
        checkCircleButton
            .tapPublisher
//            .compactMap({self.isChecked})
            .sink { _ in
                self.isChecked?.toggle()
                let image = self.isChecked ?? false ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
                self.checkCircleButton.setImage(image, for: .normal)
            }
            .store(in: &cancellables)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        repsLabel.text = nil
        weightLabel.text = nil
        timerLabel.text = nil
    }
    
//    private func anime() {
//        let labelStackView = UIStackView(arrangedSubviews: [moveableMarkView, checkCircleButton, titleLabel])
//        labelStackView.distribution = .fill
//        labelStackView.alignment = .fill
//        labelStackView.spacing = 6
//        labelStackView.axis = .horizontal
//        labelStackView.frame = .init(x: 16,
//                                     y: 0,
//                                     width: frame.width/2.2,
//                                     height: frame.height)
//
//        contentView.addSubview(labelStackView)
//    }
//
//    private func setupFrame() {
//        layer.cornerRadius = 20
//
//        backgroundColor = .navyGray
//
//        let labelHStack = UIStackView(arrangedSubviews: [repsLabel, weightLabel])
//        labelHStack.axis = .horizontal
//        labelHStack.distribution = .fill
//        labelHStack.alignment = .fill
//
//        let labelVStack = UIStackView(arrangedSubviews: [labelHStack, timerLabel])
//        labelVStack.axis = .vertical
//        labelVStack.distribution = .fill
//        labelVStack.alignment = .fill
//
//        [
//            checkCircleButton,
//            moveableMarkView,
//            titleLabel,
//            labelVStack
//        ].forEach { uv in
//            contentView.addSubview(uv)
//        }
//        let cellFrameOrigin = frame.origin
//
//        labelHStack.frame = .init(x: 16,
//                                  y: 20,
//                                  width: frame.width / 2,
//                                  height: frame.height)
//        print(cellFrameOrigin)
//        print(frame)
//        print(frame.height)
//    }
    
    private func setupUI() {
        layer.cornerRadius = 20
        
        backgroundColor = .navyGray
        
        let titleHStack = UIStackView(arrangedSubviews: [moveableMarkView, checkCircleButton, titleLabel])
        titleHStack.axis = .horizontal
        titleHStack.distribution = .fill
        titleHStack.alignment = .fill
        titleHStack.spacing = 16
//        titleHStack.backgroundColor = .red
        
        let labelHStack = UIStackView(arrangedSubviews: [repsLabel, weightLabel])
        labelHStack.axis = .horizontal
        labelHStack.distribution = .fill
        labelHStack.alignment = .fill
        
        let labelVStack = UIStackView(arrangedSubviews: [labelHStack, timerLabel])
        labelVStack.axis = .vertical
        labelVStack.distribution = .fill
        labelVStack.alignment = .fill
        
        [
            titleHStack,
            labelVStack
        ].forEach { uv in
            contentView.addSubview(uv)
            uv.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleHStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleHStack.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            labelVStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
}
