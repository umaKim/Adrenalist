//
//  Slide cell to delete.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/06.
//

import UIKit

//Slide cell to delete
extension WorkOutTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing == true {
            return .none
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            WorkOutToDoManager.shared.workOutToDos.remove(at: indexPath.row)
            Storage.store(WorkOutToDoManager.shared.workOutToDos, to: .documents, as: "todos.json")
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var workOutTodos = WorkOutToDoManager.shared.workOutToDos[indexPath.row]
        
        let editOrDeleteAction = UIContextualAction(style: .normal, title:  "Edit", handler: { [weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let alertController = UIAlertController(title: "Edit your work out", message: "", preferredStyle: UIAlertController.Style.alert)

            alertController.addTextField { (textField : UITextField!) -> Void in
                if workOutTodos.workOutName == "" {
                    textField.placeholder = "Work Out"
                } else {
                    textField.text = workOutTodos.workOutName
                }
            }
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                if workOutTodos.reps == 0 {
                    textField.placeholder = "Reps"
                } else {
                    textField.text = "\(WorkOutToDoManager.shared.workOutToDos[indexPath.row].reps)"
                }
                textField.keyboardType = .numberPad
            }
            
            alertController.addTextField { (textField: UITextField!) -> Void in
                if workOutTodos.weights == 0 {
                    textField.placeholder = "Weights"
                } else {
                    textField.text = "\(workOutTodos.weights)"
                }
                textField.keyboardType = .decimalPad
            }
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: UIAlertAction.Style.default,
                                             handler: {
                                                (action : UIAlertAction!) -> Void in })
            
            let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
                
                workOutTodos.workOutName = alertController.textFields?[0].text ?? ""
                workOutTodos.reps = Int(alertController.textFields?[1].text ?? "") ?? 0
                workOutTodos.weights = Double(alertController.textFields?[2].text ?? "") ?? 0.0
                
                WorkOutToDoManager.shared.workOutToDos[indexPath.row] = workOutTodos
                Storage.store(WorkOutToDoManager.shared.workOutToDos, to: .documents, as: "todos.json")
                tableView.reloadData()
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            
            self?.present(alertController, animated: true, completion: nil)
            success(true)
        })
        
        return UISwipeActionsConfiguration(actions:[editOrDeleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOutListCell") as? WorkOutListCell else { return }
        
        let bounds = cell.bounds
        
        UIView.animate(withDuration: 1, delay: 0, options: .repeat) {
            cell.bounds = CGRect(x: bounds.origin.x - 10, y: bounds.origin.y, width: bounds.size.width + 30, height: bounds.size.height)
        } completion: { (sucess: Bool) in
            if sucess {
                UIView.animate(withDuration: 1) {
                    cell.bounds = bounds
                }
            }
        }
    }
}
