//
//  MissionSummaryTVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/5/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class MissionSummaryTVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // your firebase reference as a property
    //var rootRef: DatabaseReference!
    //var ref: DatabaseReference!
    // your data source, you can replace this with your own model if you wish
    //var items = [DataSnapshot]()
    var missions = [MissionSummary]()
    
    var missionListDelegate : MissionListDelegate? // defined at bottom
    
    let cellId = "cellId"
    
    var missionSummaryTableView: UITableView?
    
    var ref : DatabaseReference?
    
    var team : TeamIF?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tm = TPUser.sharedInstance.getCurrentTeam() else {
            return
        }
        
        team = tm
        guard let team_name = team?.getName() else { return }
        
        // need to get handle to MissionSummaryTVC
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        
        if(TPUser.sharedInstance.accountStatusEventListeners.count == 0
            || !TPUser.sharedInstance.accountStatusEventListeners.contains(where: { String(describing: type(of: $0)) == "MissionSummaryTVC" })) {
            TPUser.sharedInstance.accountStatusEventListeners.append((appDelegate?.missionSummaryTVC!)!)
        }
        else { print("MissionSummaryTVC: NOT adding appDelegate?.missionSummaryTVC! to list of accountStatusEventListeners") }
        
        
        ref = Database.database().reference().child("teams/\(team_name)/missions")
        
        missionSummaryTableView = UITableView(frame: self.view.bounds, style: .plain) // <--- this turned out to be key
        missionSummaryTableView?.dataSource = self
        missionSummaryTableView?.delegate = self
        missionSummaryTableView?.register(MissionSummaryCellTableViewCell.self, forCellReuseIdentifier: "cellId")
        missionSummaryTableView?.rowHeight = 300
        view.addSubview(missionSummaryTableView!)
        
        fetchMissions() 
    }
    
    
    /******************
     Not a typical fetch...
     It's complicated...
     Mission data isn't all available as soon as you click OK.  All the stuff that's actually IN the spreadsheet
     is read into the database after the mission record is first inserted.  So the description and the script for example,
     aren't in the mission object when .childAdded is fired.  That's why both .childAdded and .childChanged are fired
     when a new mission is added
     ******************/
    func fetchMissions() {
        
        print("fetchMissions: =======================")
        missions.removeAll() // start "fresh" each time - not every view controller does this - case by case basis - whatever works, ultimately
        
        // On this event, get the data out of the snapshot and update the corresponding MissionSummary
        // item in the 'missions' list
        ref?.observe(.childChanged, with: {(snapshot) in
            
            guard let missionFromSnapshot = self.getMissionSummaryFromSnapshot(snapshot: snapshot) else {
                return
            }
            
            guard let missionFromList = self.getMissionFromList(missions: self.missions, mission: missionFromSnapshot) else {
                return
            }
            
            missionFromList.updateWith(mission: missionFromSnapshot)
            
            DispatchQueue.main.async{
                self.missionSummaryTableView?.reloadData()
            }
            
        }, withCancel: nil)
        
        
        
        ref?.observe(.childAdded, with: {(snapshot) in
         
            print("fetchMissions: childAdded")
            
            guard let missionFromSnapshot = self.getMissionSummaryFromSnapshot(snapshot: snapshot) else {
                //print("fetchMissions: childAdded: could not get mission from snapshot, so returning early")
                return
            }
            
            self.missions.insert(missionFromSnapshot, at: 0)  // this is what makes the most recent missions show up at the top
            DispatchQueue.main.async{
                self.missionSummaryTableView?.reloadData()
            }
            
        }, withCancel: nil)
        
        
        
        ref?.observe(.childRemoved, with: {(snapshot) in
            
            guard let missionFromSnapshot = self.getMissionSummaryFromSnapshot(snapshot: snapshot),
                let idx = self.getMissionIndex(missions: self.missions, mission: missionFromSnapshot) else {
                    return
            }
            
            self.missions.remove(at: idx)
            DispatchQueue.main.async{
                self.missionSummaryTableView?.reloadData()
            }
            
        }, withCancel: nil)
    }
    
    
    // description and script are not going to be present on newly loaded spreadsheets,
    // so we shouldn't expect them to be present here.
    private func getMissionSummaryFromSnapshot(snapshot: DataSnapshot) -> MissionSummary? {
        
        let mission = MissionSummary()
        
        guard let mission_id = snapshot.key as? String else {
            //print("getMissionSummaryFromSnapshot: could not get mission_id, return nil early")
            return nil
        }
        
        mission.mission_id = mission_id
        
        guard let dictionary = snapshot.value as? [String : Any] else {
            //print("getMissionSummaryFromSnapshot: could not get dictionary from snapshot.value, return nil early")
            return nil
        }
        
        // description and script are not going to be present on newly loaded spreadsheets,
        // so we shouldn't expect them to be present here.
        if let description = dictionary["description"] as? String {
            mission.descrip = description
        }
        
        if let script = dictionary["script"] as? String {
            mission.script = script
        }
        
        if let active = dictionary["active"] as? Bool {
            mission.active = active
        }
        
        if let mission_create_date = dictionary["mission_create_date"] as? String {
            mission.mission_create_date = mission_create_date // why isn't this immediately available ?
        }
        
        if let mission_name = dictionary["mission_name"] as? String {
            mission.mission_name = mission_name
        }
        
        if let mission_type = dictionary["mission_type"] as? String {
            mission.mission_type = mission_type
        }
        
        if let name = dictionary["name"] as? String {
            mission.name = name
        }
        
        if let uid = dictionary["uid"] as? String {
            mission.uid = uid
        }
        
        if let uid_and_active = dictionary["uid_and_active"] as? String {
            mission.uid_and_active = uid_and_active
        }
        
        if let url = dictionary["url"] as? String {
            mission.url = url
        }
        
        if let total_rows_in_spreadsheet = dictionary["total_rows_in_spreadsheet"] as? Int {
            mission.total_rows_in_spreadsheet = total_rows_in_spreadsheet
        }
        
        if let total_rows_in_spreadsheet_with_phone = dictionary["total_rows_in_spreadsheet_with_phone"] as? Int {
            mission.total_rows_in_spreadsheet_with_phone = total_rows_in_spreadsheet_with_phone
        }
        
        if let total_rows_activated = dictionary["total_rows_activated"] as? Int {
            mission.total_rows_activated = total_rows_activated
        }
        
        if let total_rows_deactivated = dictionary["total_rows_deactivated"] as? Int {
            mission.total_rows_deactivated = total_rows_deactivated
        }
        
        if let total_rows_completed = dictionary["total_rows_completed"] as? Int {
            mission.total_rows_completed = total_rows_completed
        }
        
        if let percent_complete = dictionary["percent_complete"] as? Int {
            mission.percent_complete = percent_complete
        }
        
        
        //print("getMissionSummaryFromSnapshot: return this mission: \(mission)")
        return mission
    }
    
    private func getMissionFromList(missions: [MissionSummary], mission: MissionSummary) -> MissionSummary? {
        for m in missions {
            if let thisId = m.mission_id {
                if let thatId = mission.mission_id {
                    if thisId == thatId {
                        //print("getMissionFromList: FOUND mission from list: "+thisId)
                        return m
                    }
                }
            }
        }
        //print("getMissionFromList: return nil because missions did not contain mission_id: \(mission.mission_id)")
        return nil
    }
    
    private func getMissionIndex(missions: [MissionSummary], mission: MissionSummary) -> Int? {
        var idx = 0
        for m in missions {
            if m.mission_id == mission.mission_id {
                return idx
            }
            idx = idx + 1
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = missionSummaryTableView?.dequeueReusableCell(withIdentifier: "cellId",
                                                 for: indexPath as IndexPath) as! MissionSummaryCellTableViewCell
        
        
        let mission = missions[indexPath.row]
        cell.commonInit(missionSummary: mission, ref: ref!)
        
        return cell
    }
    
    // per UITableViewDelegate - This is what gets called when you click one of the users in the search results
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mission = missions[indexPath.row]
        
        if let team = team {
            missionListDelegate?.missionSelected(mission: mission, team: team)
        }
        
    }
    
}

protocol MissionListDelegate {
    func missionSelected(mission: MissionSummary, team: TeamIF)
}

// all this just for the teamSelected() method ?  not the greatest
extension MissionSummaryTVC : AccountStatusEventListener {
    
    func changed(name: String) {
        // do nothing?  really?  if so, code smell
    }
    
    func changed(email: String) {
        // do nothing?  really?  if so, code smell
    }
    
    // required by AccountStatusEventListener
    func allowed() {
        // do nothing?  really?  if so, code smell
    }
    
    // required by AccountStatusEventListener
    func notAllowed() {
        // do nothing?  really?  if so, code smell
    }
    
    // required by AccountStatusEventListener
    func accountEnabled() {
        // do nothing?  really?  if so, code smell
    }
    
    // required by AccountStatusEventListener
    func accountDisabled() {
        // do nothing?  really?  if so, code smell
    }
    
    // required by AccountStatusEventListener
    func roleAssigned(role: String) {
        // do nothing?  really?  if so, code smell
    }
    
    // required by AccountStatusEventListener
    func roleRemoved(role: String) {
        // do nothing?  really?  if so, code smell
    }
    
    // required by AccountStatusEventListener
    func teamSelected(team: TeamIF, whileLoggingIn: Bool) {
        missions.removeAll()
    }
    
    // required by AccountStatusEventListener
    func userSignedOut() {
        // do nothing
    }
    
    func videoInvitationExtended(vi: VideoInvitation) {
        // do nothing?  really?  if so, code smell
    }
    
    func videoInvitationRevoked() {
        // do nothing?  really?  if so, code smell
    }
}
