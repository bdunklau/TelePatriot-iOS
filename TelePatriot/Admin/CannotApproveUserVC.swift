//
//  CannotApproveUserVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/12/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit

class CannotApproveUserVC: BaseViewController {
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize+4)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let instructionsLabel : UITextView = {
        let textView = UITextView()
        textView.text = "    " // set by subclasses
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        //textView.font = UIFont.boldSystemFont(ofSize: textView.font.pointSize) // just example
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clear
        //var frame = textView.frame
        //frame.size.height = 16
        //textView.frame = frame
        
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    // consolidate these two soon
    //var user : [String:Any]?
    var user : TPUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        guard let usr = user else {
            return
        }
        
        guard let name = user?.getName() ,
            let email = user?.getEmail() else {
                return }
        
        nameLabel.text = name
        emailLabel.text = email
        
        
        view.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        view.addSubview(emailLabel)
        emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 115).isActive = true
        emailLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        //emailLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        view.addSubview(instructionsLabel)
        instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        instructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8).isActive = true
        instructionsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        instructionsLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        //instructionsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
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
