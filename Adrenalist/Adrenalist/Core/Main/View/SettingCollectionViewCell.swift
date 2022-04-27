//
//  SettingCollectionViewCell.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/27.
//

import Foundation

import UIKit.UICollectionViewCell

final class SettingCollectionViewCell: UICollectionViewCell {
    static let identifier = "SettingCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
