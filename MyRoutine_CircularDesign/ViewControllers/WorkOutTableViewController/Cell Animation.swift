//
//  CellAnimation.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/06.
//

import Foundation
import UIKit

// Cell Animation
extension WorkOutTableViewController {
    func manyCellsCommingUpAnimation() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 0.9,
                           delay: Double(delayCounter) * 0.05,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: { cell.transform = CGAffineTransform.identity },
                           completion: nil)
            delayCounter += 1
        }
    }
    
    func oneCellCommingUpAnimation() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height
        
        cells.last?.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        
        var delayCounter = 0
        UIView.animate(withDuration: 0.3,
                       delay: Double(delayCounter) * 0.01,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: { cells.last?.transform = CGAffineTransform.identity },
                       completion: nil)
        delayCounter += 1
    }
}
