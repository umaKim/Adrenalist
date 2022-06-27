//
//  Constant.swift
//  Adrenalist
//
//  Created by 김윤석 on 2022/04/30.
//

import UIKit.UIColor

enum Constant {
    
    enum ButtonImage {
        static let editting     = "slider.horizontal.3"
        static let pencilCircle = "pencil.circle.fill"
        static let xmarkCircle  = "xmark.circle.fill"
        static let addWorkout   = "plus.square"
        static let calendar     = "calendar.circle"
        static let setting      = "gearshape"
        static let back         = "chevron.left"
        static let xmark        = "xmark"
        static let upArrow      = "chevron.up"
    }
}

extension UIColor {
    static let pinkishRed = UIColor(red: 223/255, green: 46/255, blue: 111/255, alpha: 1)
    static let purpleBlue = UIColor(red: 86/255, green: 98/255, blue: 255/255, alpha: 1)
    static let vaguePurpleBlue = UIColor(red: 86/255, green: 98/255, blue: 255/255, alpha: 0.15)
    static let darkNavy = UIColor(red: 23/255, green: 23/255, blue: 28/255, alpha: 1)
    static let navyGray = UIColor(red: 44/255, green: 45/255, blue: 53/255, alpha: 1)
    static let lightDarkNavy = UIColor(red: 27/255, green: 27/255, blue: 31/255, alpha: 1)
    static let lightGray = UIColor(red: 187/256, green: 193/256, blue: 195/256, alpha: 0.2)
    static let grey2 = UIColor(red: 44/255, green: 45/255, blue: 53/255, alpha: 1)
    static let brightGrey = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.7)
}
