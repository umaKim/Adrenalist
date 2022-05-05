//
//  SuggestionListCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/30.
//

import UIKit.UICollectionViewCell

final class SuggestionListCell: UICollectionViewCell {
    static let identifier = "SuggestionListCell"
    
    private let titleLabel: UILabel = {
       let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with workout: Item) {
        titleLabel.text = workout.title
        backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
