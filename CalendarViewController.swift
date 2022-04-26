//
//  CalendarViewController.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/05/03.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    let formatter = DateFormatter()
    
    //var selectedDateWorkouts: WorkOutInADay?
    
    var selectedDateWorkouts: [WorkOutWithTime]?
    
    //var selectedDateWorkouts: [String: [WorkOutWithTime]]?

    var selectedDate: Date?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.scrollDirection = .horizontal
        
        calendar.dataSource = self
        calendar.delegate = self
        
        tableView.dataSource = self
        
        formatter.dateFormat = "yyyy-MM-dd"
        deleteButton.isHidden = true
        
  
        selectedDate = Date()
        
    }
    //
    override func viewWillAppear(_ animated: Bool) {
        guard let selectedDate = selectedDate else { return }
        //selectedDateWorkouts = CalendarManager.shared.workOutInADayArray[formatter.string(from: selectedDate)]
        
        //print(selectedDate)
        selectedDateWorkouts = CalendarManager.shared.workOutWithDate.selectedDateWorkOutWithTime[formatter.string(from: selectedDate)]
//        print(CalendarManager.shared.workOutWithDate)
//        print(CalendarManager.shared.workOutWithDate.selectedDateWorkOutWithTime[formatter.string(from: selectedDate)])
//        print(selectedDateWorkouts)
        calendar.reloadData()
        tableView.reloadData()
    }
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButtonDidTapped(_ sender: Any) {
        if selectedDate != nil {
            
            guard let selectedDate = selectedDate else {return}
            let alertController = UIAlertController(title: "Delete All?", message: "Are you sure you want to delete all of your workout list?", preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: UIAlertAction.Style.default,
                                             handler: {
                                                (action : UIAlertAction!) -> Void in })
            
            let deleteAllAction = UIAlertAction(title: "Delete All", style: UIAlertAction.Style.default, handler: { [weak self] alert -> Void in
                
//                CalendarManager.shared.workOutInADayArray.removeAll {
//                    return $0.date == selectedDate
//                }
                guard let date = self?.formatter.string(from: selectedDate) else { return }
                
                //CalendarManager.shared.workOutInADayArray[date]?.removeAll()
                CalendarManager.shared.workOutWithDate.selectedDateWorkOutWithTime[date]?.removeAll()
                self?.selectedDateWorkouts = nil
                
                Storage.store(CalendarManager.shared.workOutWithDate, to: .documents, as: "workOutCalendar.json")
                
                self?.calendar.reloadData()
                self?.tableView.reloadData()
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAllAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func editButtonDIdTapped(_ sender: Any) {
        if selectedDateWorkouts?.count != 0 {
            tableView.isEditing = !tableView.isEditing
            deleteButton.isHidden = !deleteButton.isHidden
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let selectedDate = selectedDate else {return }
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            selectedDateWorkouts?[indexPath.section].workOut.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        Storage.store(CalendarManager.shared.workOutWithDate, to: .documents, as: "workOutCalendar.json")
        
        tableView.endUpdates()
        
        calendar.reloadData()
        
        
        //  해당 section에 모든 내용이 없고 empty array라면, 해당 empty array도 지워준다.
        if (selectedDateWorkouts?[indexPath.section].workOut.isEmpty)!{
            selectedDateWorkouts?.remove(at: indexPath.section)
        }
        
        //            CalendarManager의 내용을 업데이트
        //CalendarManager.shared.workOutInADayArray[formatter.string(from: selectedDate)] = selectedDateWorkouts
        CalendarManager.shared.workOutWithDate.selectedDateWorkOutWithTime[formatter.string(from: selectedDate)] = selectedDateWorkouts
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return selectedDateWorkouts?[section].time
    }
}

extension CalendarViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        return CalendarManager.shared.workOutInADayArray[formatter.string(from: date)]?.count ?? 0
        return CalendarManager.shared.workOutWithDate.selectedDateWorkOutWithTime[formatter.string(from: date)]?.count ?? 0
    }
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        selectedDate = date
        guard let selectedDate = selectedDate else { return }
        
        //selectedDateWorkouts = CalendarManager.shared.workOutInADayArray[formatter.string(from: selectedDate)]
        selectedDateWorkouts = CalendarManager.shared.workOutWithDate.selectedDateWorkOutWithTime[formatter.string(from: selectedDate)]
//        selectedDateWorkouts2 = CalendarManager.shared.workOutInADayArray.filter({
//            $0.key == formatter.string(from: date)
//        })
        
        self.tableView.reloadData()
        
        let cells = tableView.visibleCells
        
        for cell in cells {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, +500, 10, 0)
            cell.layer.transform = rotationTransform
            cell.alpha = 0.5
            
            UIView.animate(withDuration: 0.3) {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
            }
        }
    }
}

extension CalendarViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedDateWorkouts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDateWorkouts?[section].workOut.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? WorkOutListCell,
              let workout = selectedDateWorkouts?[indexPath.section].workOut[indexPath.row] else {return UITableViewCell()}
        
        cell.updateUI(for: workout)
        
        return cell
    }
}
