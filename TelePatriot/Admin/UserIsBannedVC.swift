//
//  UserIsBannedVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/12/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit

class UserIsBannedVC: CannotApproveUserVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionsLabel.text = "This person is banned"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
