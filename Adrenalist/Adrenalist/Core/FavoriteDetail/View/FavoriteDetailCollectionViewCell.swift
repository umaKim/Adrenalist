//
//  FavoriteDetailCollectionViewCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/07/07.
//

import UIKit

class FavoriteDetailCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavoriteDetailCollectionViewCell"
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with response: WorkoutResponse) {
        titleLabel.text = response.name
    }
    
    private func setupUI() {
        layer.cornerRadius = 20
        
        backgroundColor = .navyGray
        
        [titleLabel].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
