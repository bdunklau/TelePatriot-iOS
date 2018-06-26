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
    // TODO CODE DUPLICATION HERE
    // IDENTICAL to socialMediaSaved() in VideoChatVC
    /******************************************************
     NEED TO RETHINK THIS...
     How to update legislators social media handles without letting incorrect data overwrite good data
     
     Step 1:  Write a record to social_media/user_updates:
             id (the facebook or twitter handle)
             leg_id  (the open states leg_id)
             legislator_full_name  (maybe)
             legislator_first_name
             legislator_last_name
             state_abbrev
             state_chamber
             state_chamber_district
             type  ("Facebook" or "Twitter")
             updated_date  (i.e.  Jun 25, 2018 9:05 AM CDT)
             updated_date_ms
             updating_user_email  (current user's email)
             updating_user_id
             updating_user_name  (i.e.  Brent Dunklau)
     
     Step 2:  Trigger that listens for writes to social_media/user_updates/{key}
        The trigger will write to 2 places - states/legislators/{leg_id}/channels/{idx} and video/list
        The trigger will query states/legislators/{leg_id} to see if there is a "channels" node and under that,
        a channel with the right "type" value (Facebook or Twitter).
        The trigger will update the channel node if it exists and create one if it doesn't.
        In either case, the trigger will also write a "user_update" node with value equal to the key value
        from social_media/user_updates/{key}
     
        The trigger will also update legislator_facebook or legislator_twitter for all nodes under
        video/list where leg_id = the legislator's leg_id.  So older videos will be kept up to date as social handles change.
        And one of those nodes will be the one you're currently looking at.
     
     Step 3:  Prevent overwriting good data with bad data.  Need a trigger to watch what gets written
        to states/legislators/{leg_id}/channels/{idx}.  If a value is written to
        states/legislators/{leg_id}/channels/{idx}, the "restore" trigger will check for the existence of this
        attribute: states/legislators/{leg_id}/channels/{idx}/user_update
     
        If this attribute exists, the "restore" trigger will query social_media/user_updates for a node with this key.
        The "id" value under this social_media/user_updates/{key} node will be compared to the "id" value under
        states/legislators/{leg_id}/channels/{idx}.  If the two id's are the same, no action.  But if they are different,
        we interpret that as bad data attempting to overwrite good data.  In that case, the trigger will update
        states/legislators/{leg_id}/channels/{idx}/id=social_media/user_updates/{key}/id
     
     And because all this is done with triggers, all we have to do in the mobile code is do one write to
     social_media/user_updates and the triggers do all the rest.  We can even test this just using the firebase database client
     ******************************************************/
    func socialMediaSaved(data: [String : Any]) {
        guard let type = data["type"] as? String,
            let id = data["id"] as? String,
            var legislator = data["legislator"] as? Legislator
            else { return }
        
        // See the triggers in legislators.js:
        // updateLegislatorSocialMedia, updateVideoNodeSocialMedia, overwriteBadWithGoodData
        
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
            "updating_user_email": TPUser.sharedInstance.getEmail(),
            "updated_date": Util.getDate_MMM_d_yyyy_hmm_am_z(),
            "updated_date_ms": Util.getDate_as_millis()
        ]
        
        Database.database().reference().child("social_media/user_updates").childByAutoId().setValue(userUpdate)
        
        // should this be in a callback/completion block of the setValue() call above?
        self.dismiss(animated: true, completion: nil)
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
