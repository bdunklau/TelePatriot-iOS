//
//  AdminViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/5/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

// THIS IS NOT THE CLASS TO USE
// THIS CLASS IS A HOLDOVER FROM WHEN WE WERE USING STORYBOARDS
// FIND REFERENCES TO THIS CLASS THEN DELETE THIS CLASS
class AdminViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let l = UILabel()
        l.text = "Admins"
        view.addSubview(l)
        
        
        l.translatesAutoresizingMaskIntoConstraints = false
        l.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        l.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        l.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        l.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
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
