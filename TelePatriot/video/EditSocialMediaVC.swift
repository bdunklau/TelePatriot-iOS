//
//  EditSocialMediaVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 5/16/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class EditSocialMediaVC: BaseViewController, EditSocialMediaDelegate {
    
    var socialMediaDelegate : EditSocialMediaDelegate?
    var legislator : Legislator?
    var handle : String?
    var handleType : String?

    
    let editSocialMediaHeading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.text = "Edit Social Media"
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    let socialMediaField : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "Social Media Handle"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let cancel_button : BaseButton = {
        let button = BaseButton(text: "Cancel")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelSocialMedia(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let save_button : BaseButton = {
        let button = BaseButton(text: "Save")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveSocialMedia(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(cancel_button)
        cancel_button.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        cancel_button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
        view.addSubview(save_button)
        save_button.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        save_button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        view.addSubview(editSocialMediaHeading)
        editSocialMediaHeading.topAnchor.constraint(equalTo: cancel_button.bottomAnchor, constant: 32).isActive = true
        editSocialMediaHeading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
        view.addSubview(socialMediaField)
        socialMediaField.topAnchor.constraint(equalTo: editSocialMediaHeading.topAnchor, constant: 24).isActive = true
        socialMediaField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        socialMediaField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        socialMediaField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        if let handleType = handleType {
            editSocialMediaHeading.text = "Edit \(handleType) Handle"
            socialMediaField.placeholder = "\(handleType) handle"
        }
        if let handle = handle {
            socialMediaField.text = handle
        }
    }
    
    
    @objc func cancelSocialMedia(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc private func saveSocialMedia(_ sender: UIButton) {
        if let handleType = handleType,
            let textFieldValue = socialMediaField.text,
            let legislator = legislator
            {
            let id = stripAtSign(string: textFieldValue)
            let data : [String:Any] = [
                "type": handleType,
                "id": id,
                "legislator": legislator
            ]
            socialMediaDelegate?.socialMediaSaved(data: data)
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func stripAtSign(string: String) -> String {
        if string.prefix(1) == "@" {
            return String(string.suffix(1))
        }
        else { return string }
    }
    
    
    // per EditSocialMediaDelegate
    // very similar to socialMediaSaved() in VideoChatVC
    func socialMediaSaved(data: [String : Any]) {
        guard let type = data["type"] as? String,
            let id = data["id"] as? String,
            let legislator = data["legislator"] as? Legislator
            else { return }
        
        
        //Here's what VideoChatVC does...
        
        // This method is where we know most things.  The only things we don't know
        // come from EditSocialMediaVC:  type/handleType (i.e. Facebook) and id/handle (i.e. FB username, not FB ID)
        
        Database.database().reference().child(("states/legislators/\(legislator.leg_id)/channels"))
            .observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                
                let channel : [String:Any] = [
                    "type": type,
                    "id": id,
                    "source": "user"
                ]
                
                // find out if a facebook or twitter handle already exists...
                var xxxx : Any?
                let children = snapshot.children
                while let snap = children.nextObject() as? DataSnapshot {
                    //print("looking for type: \(type)")
                    if let channelStuff = snap.value as? [String:Any],
                        let channelType = channelStuff["type"] as? String {
                        //print("channelType: \(channelType)")
                        if (xxxx == nil && channelType.lowercased() == type.lowercased()) {
                            xxxx = snap.key
                        }
                    }
                }
                
                if xxxx == nil {
                    xxxx = snapshot.childrenCount
                }
                
                var updates : [String:Any] = [:]
                if let xxxxx = xxxx {
                    updates["states/legislators/\(legislator.leg_id)/channels/\(xxxxx)"] = channel
                }
                
                // what is the video node key?
                // Ans:  TPUser.sharedInstance.currentVideoNodeKey
                if let videoNodeKey = TPUser.sharedInstance.currentVideoNodeKey {
                    if type.lowercased() == "facebook" {
                        updates["video/list/\(videoNodeKey)/legislator_facebook"] = id
                    }
                    else if type.lowercased() == "twitter" {
                        updates["video/list/\(videoNodeKey)/legislator_twitter"] = id
                    }
                }
                
                let userUpdate : [String:Any] = [
                    "leg_id": legislator.leg_id,
                    "type": type,
                    "id": id, // This is the @handle, not some numeric Facebook ID
                    "legislator_full_name": legislator.full_name,
                    "state_abbrev": legislator.state,
                    "state_chamber": "\(legislator.state)-\(legislator.chamber)",
                    "state_chamber_district": "\(legislator.state)-\(legislator.chamber)-\(legislator.district)",
                    "updating_user_id": TPUser.sharedInstance.getUid(),
                    "updating_user_name": TPUser.sharedInstance.getName(),
                    "updating_user_emali": TPUser.sharedInstance.getEmail(),
                    "updated_date": Util.getDate_MMM_d_yyyy_hmm_am_z(),
                    "updated_date_ms": Util.getDate_as_millis()
                ]
                snapshot.ref.root.child("social_media/user_updates").childByAutoId().setValue(userUpdate)
                
                snapshot.ref.root.updateChildValues(updates, withCompletionBlock: { (error:Error?, ref:DatabaseReference) in
                    // not sure how to handle the NSError yet
                    // just handle success for now
                    // do something here if you want like update the UI or dismiss a view controller
                }) //as! (Error?, DatabaseReference) -> Void)
                
            })
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

protocol EditSocialMediaDelegate {
    func socialMediaSaved(data: [String:Any])
}
