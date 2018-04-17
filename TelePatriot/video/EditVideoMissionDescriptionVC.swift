//
//  EditVideoMissionDescriptionVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 4/6/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit

class EditVideoMissionDescriptionVC: /*Base*/UIViewController {

    
    let descriptionLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Description"
        return l
    }()
    
    
    let video_mission_description : UITextView = {
        let textView = UITextView()
        textView.text = "(video mission description)"
        //textView.font = UIFont(name: "fontname", size: 18)
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        //textView.font = UIFont.boldSystemFont(ofSize: (textView.font?.pointSize)!) // just example
        textView.translatesAutoresizingMaskIntoConstraints = false
        //var frame = textView.frame
        //frame.size.height = 200
        //textView.frame = frame
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    
    let save_button : BaseButton = {
        let button = BaseButton(text: "Save")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveVideoMissionDescription(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let cancel_button : BaseButton = {
        let button = BaseButton(text: "Cancel")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelVideoMissionDescription(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.preferredContentSize = CGSize(width:240, height:185)
        // REST ARE COSMETIC CHANGES
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = true
        self.view.layer.masksToBounds = false
        self.view.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.view.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:1).cgColor
        self.view.layer.shadowOpacity = 0.5
        self.view.layer.shadowRadius = 20
        
        /*******
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "usflag")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        ********/
        

        // Do any additional setup after loading the view.
        
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
        view.addSubview(video_mission_description)
        video_mission_description.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        video_mission_description.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
        view.addSubview(save_button)
        save_button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        save_button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
        view.addSubview(cancel_button)
        cancel_button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        cancel_button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc private func saveVideoMissionDescription(_ sender: UIButton) {
    }
    
    
    @objc private func cancelVideoMissionDescription(_ sender: UIButton) {
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
