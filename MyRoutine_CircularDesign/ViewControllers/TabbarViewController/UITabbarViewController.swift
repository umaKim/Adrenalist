//
//  UITabbarViewController.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/05/12.
//

import UIKit

class UITabbarViewController: UITabBarController {

    override open var shouldAutorotate: Bool {
            return false
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
