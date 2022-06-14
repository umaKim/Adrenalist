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
    
//    rgba(23, 23, 28, 1)
    static let darkNavy = UIColor(red: 23/255, green: 23/255, blue: 28/255, alpha: 1)
}
