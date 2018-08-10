//
//  VideoInvitationsVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 6/12/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

// In Android, see VideoInvitationsFragment
// This class was modeled after MissionSummaryTVC
class VideoInvitationsVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    
    // your firebase reference as a property
    //var rootRef: DatabaseReference!
    //var ref: DatabaseReference!
    // your data source, you can replace this with your own model if you wish
    //var items = [DataSnapshot]()
    var invitations = [VideoInvitation]()
    
    var invitationDelegate : VideoInvitationDelegate? // defined at bottom
    
    let cellId = "cellId"
    
    var invitationTable: UITableView?
    
    var query : DatabaseQuery?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //query =
        Database.database().reference().child("video/invitations").queryOrdered(byChild: "guest_id").queryEqual(toValue: TPUser.sharedInstance.getUid())
            .observe(.value, with: {(snapshot) in
                guard let dictionary = snapshot.value as? [String : Any] else {
                    self.invitations = [VideoInvitation]()
                    DispatchQueue.main.async { self.invitationTable?.reloadData() }
                    return
                }
                // dictionary is a collection of key value pairs.  The keys are the really long video invitation key
                // The value mapped to each key is the itself a collection of key/value pairs - they are the attribute names
                // and values of each invitation
                self.invitations = VideoInvitation.createInvitations(snapshot: snapshot)
                
                DispatchQueue.main.async {
                    self.invitationTable?.reloadData()
                }
                
            }, withCancel: nil)
        
        invitationTable = UITableView(frame: self.view.bounds, style: .plain) // <--- this turned out to be key
        invitationTable?.dataSource = self
        invitationTable?.delegate = self
        invitationTable?.register(VideoInvitationCell.self, forCellReuseIdentifier: "cellId")
        invitationTable?.rowHeight = 120
        view.addSubview(invitationTable!)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = invitationTable?.dequeueReusableCell(withIdentifier: "cellId",
                                                                for: indexPath as IndexPath) as! VideoInvitationCell
        
        let invitation = invitations[indexPath.row]
        cell.commonInit(invitation: invitation)
        cell.accept_invitation_button.tag = indexPath.row
        cell.accept_invitation_button.addTarget(self, action: #selector(acceptInvitation(_:)), for: .touchUpInside)
        cell.decline_invitation_button.tag = indexPath.row
        cell.decline_invitation_button.addTarget(self, action: #selector(declineInvitation(_:)), for: .touchUpInside)
        
        //button.addTarget(self, action: #selector(acceptInvitation(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // per UITableViewDelegate - This is what gets called when you click one of the users in the search results
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let invitation = invitations[indexPath.row]
        invitationDelegate?.videoInvitationSelected(invitation: invitation)
    }
    
    @objc func declineInvitation(_ sender:UIButton) {
        invitations[sender.tag].delete()
    }
    
    @objc func acceptInvitation(_ sender:UIButton) {
        invitations[sender.tag].accept()
        invitationDelegate?.videoInvitationSelected(invitation: invitations[sender.tag])
    }
    
}

protocol VideoInvitationDelegate {
    func videoInvitationSelected(invitation: VideoInvitation)
}
