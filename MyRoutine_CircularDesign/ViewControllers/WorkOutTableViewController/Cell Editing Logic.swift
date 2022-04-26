//
//  CellEditingLogic.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/06.
//

import UIKit

//Cell Editing(Moving) Logic
extension WorkOutTableViewController {
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveCell = WorkOutToDoManager.shared.workOutToDos[sourceIndexPath.row]
        WorkOutToDoManager.shared.workOutToDos.remove(at: sourceIndexPath.row)
        WorkOutToDoManager.shared.workOutToDos.insert(moveCell, at: destinationIndexPath.row)
        Storage.store(WorkOutToDoManager.shared.workOutToDos, to: .documents, as: "todos.json")
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
