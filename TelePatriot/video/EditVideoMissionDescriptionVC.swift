//
//  EditVideoMissionDescriptionVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 4/6/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class EditVideoMissionDescriptionVC: BaseViewController {

    var videoNode : VideoNode?
    var database_attribute = "youtube_video_description" // just a default value - real value is passed in by VideoChatVC
    var data : [String:Any]?
    
    let descriptionLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Description"
        return l
    }()
    
    
    let big_text_field : UITextView = {
        let textView = UITextView()
        textView.text = "(video mission description)"
        //textView.font = UIFont(name: "fontname", size: 18)
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        //textView.font = UIFont.boldSystemFont(ofSize: (textView.font?.pointSize)!) // just example
        textView.translatesAutoresizingMaskIntoConstraints = false
        //var frame = textView.frame
        //frame.size.height = 200
        //textView.frame = frame
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5.0
        textView.backgroundColor = UIColor.white
        textView.textAlignment = .left
        textView.isEditable = true
        textView.isScrollEnabled = true
        return textView
    }()
    
    
    let save_button : BaseButton = {
        let button = BaseButton(text: "Save")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveVerbiage(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let cancel_button : BaseButton = {
        let button = BaseButton(text: "Cancel")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelVerbiage(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(cancel_button)
        cancel_button.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        cancel_button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
        view.addSubview(save_button)
        save_button.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        save_button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: cancel_button.bottomAnchor, constant: 16).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
        view.addSubview(big_text_field)
        big_text_field.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        big_text_field.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        big_text_field.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        big_text_field.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
        //big_text_field.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 100).isActive = true
        let ht = view.frame.height - descriptionLabel.frame.origin.y - descriptionLabel.frame.height - 150
        big_text_field.heightAnchor.constraint(equalToConstant: ht).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /**********
         if let videoNode = videoNode {
         video_mission_description.text = videoNode.video_mission_description
         }
         ***********/
        descriptionLabel.text = ""
        big_text_field.text = ""
        
        /************************************************
         VideoChatVC contains two Edit links that each open this screen.  We are making this screen do
         double duty because both the Video Mission Description section and the YouTube Video Description
         have the same basic need: a screen with a text area and a save button
         ************************************************/
        if let data = data, let vn = data["videoNode"] as? VideoNode {
            videoNode = vn
            if let heading = data["heading"] as? String {
                descriptionLabel.text = heading
            } else {
                descriptionLabel.text = "Description"
            }
            
            if let dba = data["database_attribute"] as? String {
                database_attribute = dba
            }
            
            if let video_mission_description = data["video_mission_description"] as? String {
                big_text_field.text = video_mission_description
            } else if let youtube_video_description = data["youtube_video_description"] as? String {
                big_text_field.text = vn.youtube_video_description
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc private func saveVerbiage(_ sender: UIButton) {
        if let vn = videoNode {
            // example of multi-path update even thought we're only updating one path
            let updatedData = ["video/list/\(vn.getKey())/\(database_attribute)": big_text_field.text]
            
            Database.database().reference().updateChildValues(updatedData, withCompletionBlock: { (error, ref) -> Void in
                // don't really need to do anything on successful save except dismiss this view
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    
    @objc private func cancelVerbiage(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
