//
//  FavoriteFooterCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/06/23.
//
import Combine
import UIKit

protocol FavoriteFooterCellDelegate: AnyObject {
    func favoriteFooterCellDidSelect()
}

final class FavoriteFooterCell: UICollectionReusableView {
    static let identifier = "FavoriteFooterCell"
    static let preferredHeight: CGFloat = 22
    
    private lazy var backgroundView: UIImageView = {
       let uv = UIImageView()
        uv.layer.borderWidth = 1
        uv.layer.borderColor = UIColor.brightGrey.cgColor
        uv.layer.cornerRadius = Self.preferredHeight / 2
        return uv
    }()
    
    weak var delegate: FavoriteFooterCellDelegate?
    
    private lazy var imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(gesture)
    }
    
    @objc
    private func didTap() {
        self.delegate?.favoriteFooterCellDidSelect()
    }

    private func setupUI() {

        imageView.tintColor = .brightGrey

        [backgroundView, imageView]
            .forEach { uv in
                uv.translatesAutoresizingMaskIntoConstraints = false
                addSubview(uv)
            }

        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            backgroundView.widthAnchor.constraint(equalToConstant: 22),
            backgroundView.heightAnchor.constraint(equalToConstant: 22),
            
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
