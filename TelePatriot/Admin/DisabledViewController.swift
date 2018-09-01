//
//  DisabledViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 8/29/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit

// presented when the user's account is disabled - they can't do anything
class DisabledViewController: BaseViewController {

    let accountDisabled : UITextView = {
        let textView = UITextView()
        textView.text = "account disabled"
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        //textView.font = UIFont.boldSystemFont(ofSize: textView.font.pointSize) // just example
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        var frame = textView.frame
        frame.size.height = 24
        textView.frame = frame
        textView.backgroundColor = .clear
        
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(accountDisabled)
        accountDisabled.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        accountDisabled.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
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
