//
//  InviteSomeoneVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 10/10/19.
//  Copyright © 2019 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase


// Android equiv:  InviteSomeoneDlg
class InviteSomeoneVC: BaseViewController {
    
    var userInvitedDelegate: UserInvitedDelegate?
    var videoChatVC: VideoChatVC? // See vc.videoChatVC = self in VideoChatVC
    
    let headingLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Invite Someone to a Video Call"
        l.font = l.font.withSize(24)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    let by_name_button : BaseButton = {
        let button = BaseButton(text: "By Name")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(inviteByName(_:)), for: .touchUpInside)
        return button
    }()
    
    let by_text_message_button : BaseButton = {
        let button = BaseButton(text: "By Text Message")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(inviteByTextMessage(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let cancel_button : BaseButton = {
        let button = BaseButton(text: "Cancel")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headingLabel)
        headingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        
        view.addSubview(by_name_button)
        by_name_button.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 24).isActive = true
        by_name_button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        view.addSubview(by_text_message_button)
        by_text_message_button.topAnchor.constraint(equalTo: by_name_button.bottomAnchor, constant: 24).isActive = true
        by_text_message_button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        view.addSubview(cancel_button)
        cancel_button.topAnchor.constraint(equalTo: by_text_message_button.bottomAnchor, constant: 24).isActive = true
        cancel_button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
    }
    
    
    @objc private func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc private func inviteByName(_ sender: UIButton) {
        if let vc = getAppDelegate().searchUsersVC {
            dismiss(animated: true, completion: nil)
            vc.modalPresentationStyle = .popover
            vc.searchUsersDelegate = self
            videoChatVC?.present(vc, animated: true, completion:nil)
        }
    }
    
    
    @objc private func inviteByTextMessage(_ sender: UIButton) {
        if let vc = getAppDelegate().inviteByTextMessageVC {
            dismiss(animated: true, completion: nil)
            vc.modalPresentationStyle = .popover
            vc.inviteByTextMessageDelegate = self
            videoChatVC?.present(vc, animated: true, completion:nil)
        }
    }
}


extension InviteSomeoneVC : InviteByTextMessageDelegate {
    
    func userInvitedByTextMessage(someone: [String:String])  {
        // userInvitedDelegate = VideoChatVC  see: VideoChatVC.inviteSomeone()
        userInvitedDelegate?.userInvited(someone: someone)
    }
}


extension InviteSomeoneVC : SearchUsersDelegate {
    
    func userSelected(user: TPUser) {
//        dismiss(animated: true, completion: nil)
        userInvitedDelegate?.userInvited(someone: user) // userInvitedDelegate = VideoChatVC  see: VideoChatVC.inviteSomeone()
        
//        if let vc = getAppDelegate().searchUsersVC {
//            vc.dismiss(animated: false, completion: nil)
//        }
//
//        // We want to write this user and the current user to /video/invitations
//        if let vid = TPUser.sharedInstance.current_video_node_key {
//            let videoInvitation = VideoInvitation(creator: TPUser.sharedInstance, guest: user, video_node_key: vid)
//            let video_invitation_key = videoInvitation.save()
//            currentVideoNode?.video_invitation_key = video_invitation_key
//
//            // now write the video_invitation_key to the video node so that we can revoke the invitation later if we want to
//            let data = ["video/list/\(vid)/video_invitation_key" : video_invitation_key,
//                        "video/list/\(vid)/video_invitation_extended_to" : user.getName(),
//                        "users/\(user.getUid())/video_invitation_from" : TPUser.sharedInstance.getUid(),
//                        "users/\(user.getUid())/video_invitation_from_name" : TPUser.sharedInstance.getName(),
//                        "users/\(user.getUid())/current_video_node_key" : TPUser.sharedInstance.current_video_node_key]
//            Database.database().reference().updateChildValues(data)
//        }
    }
}

protocol UserInvitedDelegate {
    
    // user is Any because we could invite someone by text message, in which case they
    // won't actually have a user account
    func userInvited(someone: Any)
}

