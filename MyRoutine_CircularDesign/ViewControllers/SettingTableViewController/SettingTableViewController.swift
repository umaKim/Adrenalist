//
//  SettingTableTableViewController.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/04.
//

import UIKit

protocol SettingTableViewControllerDelegate {
    func settingTableViewControllerIsClosed(_ settingTableViewController: SettingTableViewController)
}

class SettingTableViewController: UITableViewController {
    
    var delegate: CurrentStatusViewController?
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBAction func didChangeWeightStandard(_ sender: UISegmentedControl) {
        HapticManager.shared.vibrateForSelection()
        
        if sender.selectedSegmentIndex == 0 {
            WorkOutToDoManager.shared.weightStandard = "Kg"
        }
        else if sender.selectedSegmentIndex == 1 {
            WorkOutToDoManager.shared.weightStandard = "lbs"
        }
    }
    @IBAction func closeButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        view.backgroundColor = .black
        
        if WorkOutToDoManager.shared.weightStandard == "Kg"{
            segmentController.selectedSegmentIndex = 0
        }
        else {
            segmentController.selectedSegmentIndex = 1
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.settingTableViewControllerIsClosed(self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticManager.shared.vibrateForSelection()
        if indexPath.row == 0 {
            
            if let setTimerViewController = storyboard?.instantiateViewController(identifier: "SetTimerViewController") as? SetTimerViewController {
                //let setTimerViewController = SetTimerViewController()
                navigationController?.pushViewController(setTimerViewController, animated: true)
                present(setTimerViewController, animated: true, completion: nil)
            }
        }
        else if indexPath.row == 2 {
            
            guard let aboutViewController = storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as? AboutViewController else { return }
            //let aboutViewController = AboutViewController()
            navigationController?.pushViewController(aboutViewController, animated: true)
            present(aboutViewController, animated: true)
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20.0
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
