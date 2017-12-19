//
//  NoMissionVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/19/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

class NoMissionVC: BaseViewController {
    
    let noMissionExplanation : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "There are no missions currently available in this team."
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(noMissionExplanation)
        noMissionExplanation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        noMissionExplanation.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        noMissionExplanation.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
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
