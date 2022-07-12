//
//  FavoriteLastCollectionViewCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/23.
//
import UIKit

final class FavoriteLastCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavoriteLastCollectionViewCell"
    static let preferredHeight: CGFloat = 22
    
    private lazy var imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.brightGrey.cgColor
        layer.cornerRadius = Self.preferredHeight / 2
        
        imageView.tintColor = .brightGrey
        
        [imageView]
            .forEach { uv in
                uv.translatesAutoresizingMaskIntoConstraints = false
                addSubview(uv)
            }
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
