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
    var invitations = [[String:Any]]()
    
    var invitationDelegate : VideoInvitationDelegate? // defined at bottom
    
    let cellId = "cellId"
    
    var invitationTable: UITableView?
    
    var query : DatabaseQuery?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        query = Database.database().reference().child("video/invitations").queryOrdered(byChild: "guest_id").queryEqual(toValue: TPUser.sharedInstance.getUid())
        
        invitationTable = UITableView(frame: self.view.bounds, style: .plain) // <--- this turned out to be key
        invitationTable?.dataSource = self
        invitationTable?.delegate = self
        invitationTable?.register(VideoInvitationCell.self, forCellReuseIdentifier: "cellId")
        invitationTable?.rowHeight = 120
        view.addSubview(invitationTable!)
        
        fetchInvitations()
    }
    
    
    // I don't know if we really need to have 3 separate queries.  I bet we can do a single query listening
    // for .value
    func fetchInvitations() {
        
        print("fetchInvitations: =======================")
        invitations.removeAll() // start "fresh" each time - not every view controller does this - case by case basis - whatever works, ultimately
        
        // On this event, get the data out of the snapshot and update the corresponding Invitation
        // item in the 'missions' list
        query?.observe(.childChanged, with: {(snapshot) in
            /*********
            guard let missionFromSnapshot = self.getMissionSummaryFromSnapshot(snapshot: snapshot) else {
                return
            }
            
            guard let missionFromList = self.getMissionFromList(missions: self.missions, mission: missionFromSnapshot) else {
                return
            }
            
            missionFromList.updateWith(mission: missionFromSnapshot)
            **********/
            DispatchQueue.main.async{
                self.invitationTable?.reloadData()
            }
            
        }, withCancel: nil)
        
        
        
        query?.observe(.childAdded, with: {(snapshot) in
            
            print("fetchMissions: childAdded")
            
            guard let dictionary = snapshot.value as? [String : Any] else {
                //print("getMissionSummaryFromSnapshot: could not get dictionary from snapshot.value, return nil early")
                return
            }
            
            self.invitations.insert(dictionary, at: 0)  // this is what makes the most recent missions show up at the top
            DispatchQueue.main.async{
                self.invitationTable?.reloadData()
            }
            
        }, withCancel: nil)
        
        
        // if an invitation is revoked...
        query?.observe(.childRemoved, with: {(snapshot) in
            /*************
            guard let missionFromSnapshot = self.getMissionSummaryFromSnapshot(snapshot: snapshot),
                let idx = self.getMissionIndex(missions: self.missions, mission: missionFromSnapshot) else {
                    return
            }
            self.missions.remove(at: idx)
             **********/
            DispatchQueue.main.async{
                self.invitationTable?.reloadData()
            }
            
        }, withCancel: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = invitationTable?.dequeueReusableCell(withIdentifier: "cellId",
                                                                for: indexPath as IndexPath) as! VideoInvitationCell
        
        
        let invitation = invitations[indexPath.row]
        cell.commonInit(invitation: invitation)
        
        return cell
    }
    
    // per UITableViewDelegate - This is what gets called when you click one of the users in the search results
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let invitation = invitations[indexPath.row]
        invitationDelegate?.videoInvitationSelected(invitation: invitation)
    }
    
}

protocol VideoInvitationDelegate {
    func videoInvitationSelected(invitation: [String:Any])
}
