//
//  MissionSummaryTVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/5/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class MissionSummaryTVC: BaseViewController, UITableViewDataSource {
    // your firebase reference as a property
    //var rootRef: DatabaseReference!
    //var ref: DatabaseReference!
    // your data source, you can replace this with your own model if you wish
    //var items = [DataSnapshot]()
    var missions = [MissionSummary]()
    
    let cellId = "cellId"
    
    var missionSummaryTableView: UITableView?
    
    var ref : DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let team = TPUser.sharedInstance.getCurrentTeam()?.team_name else {
            return
        }
        ref = Database.database().reference().child("teams/\(team)/missions")
        
        missionSummaryTableView = UITableView(frame: self.view.bounds, style: .plain) // <--- this turned out to be key
        missionSummaryTableView?.dataSource = self
        missionSummaryTableView?.register(MissionSummaryCellTableViewCell.self, forCellReuseIdentifier: "cellId")
        missionSummaryTableView?.rowHeight = 150
        view.addSubview(missionSummaryTableView!)
        
        fetchMissions() 
    }
    
    func fetchMissions() {
        
        // TODO code duplication - how do I put the guts of each of these into a separate function?
        ref?.observe(.childChanged, with: {(snapshot) in
            
            guard let mission = self.getMissionSummaryFromSnapshot(snapshot: snapshot) else {
                return
            }
            
            if self.getMissionFromList(missions: self.missions, mission: mission) == nil {
                /*********
                missionFromList.active = mission.active
                missionFromList.descrip = mission.descrip
                missionFromList.mission_create_date = mission.mission_create_date
                missionFromList.mission_name = mission.mission_name
                missionFromList.mission_type = mission.mission_type
                missionFromList.name = mission.name
                missionFromList.script = mission.script
                missionFromList.uid = mission.uid
                missionFromList.uid_and_active = mission.uid_and_active
                missionFromList.url = mission.url
                 *********/
                
                self.missions.insert(mission, at: 0)
                DispatchQueue.main.async{
                    self.missionSummaryTableView?.reloadData()
                }
            }
            
            
            // Why don't we do something like this?...
            //self.missions.insert(mission, at: 0)
            
            
        }, withCancel: nil)
        
        
        ref?.observe(.childAdded, with: {(snapshot) in
            
            guard let mission = self.getMissionSummaryFromSnapshot(snapshot: snapshot) else {
                return
            }
            
            // TODO This isn't working the way it should.
            // On newly created missions, we should not be able to get the newly created mission
            // from the list of missions.  We don't add it to the list of missions until just after
            // this guard statement
            let missionFromList =  self.getMissionFromList(missions: self.missions, mission: mission)
            guard missionFromList == nil else {
                return
            }
            
            self.missions.insert(mission, at: 0)  // this is what makes the most recent missions show up at the top
            DispatchQueue.main.async{
                self.missionSummaryTableView?.reloadData()
            }
            
        }, withCancel: nil)
        
        
        ref?.observe(.childRemoved, with: {(snapshot) in
            
            guard let mission = self.getMissionSummaryFromSnapshot(snapshot: snapshot),
                let idx = self.getMissionIndex(missions: self.missions, mission: mission) else {
                    return
            }
            
            self.missions.remove(at: idx)
            DispatchQueue.main.async{
                self.missionSummaryTableView?.reloadData()
            }
            
        }, withCancel: nil)
    }
    
    private func getMissionSummaryFromSnapshot(snapshot: DataSnapshot) -> MissionSummary? {
        guard let dictionary = snapshot.value as? [String : Any],
            let mission_id = snapshot.key as? String,
            let active = dictionary["active"] as? Bool,
            let descrip = dictionary["description"] as? String, // <-- fails here on new spreadsheets
            let mission_create_date = dictionary["mission_create_date"] as? String,
            let mission_name = dictionary["mission_name"] as? String,
            let mission_type = dictionary["mission_type"] as? String,
            let name = dictionary["name"] as? String,
            let script = dictionary["script"] as? String,
            let uid = dictionary["uid"] as? String,
            let uid_and_active = dictionary["uid_and_active"] as? String,
            let url = dictionary["url"] as? String else {
                return nil
        }
        
        let mission = MissionSummary()
        mission.mission_id = mission_id
        mission.active = active
        mission.descrip = descrip
        mission.mission_create_date = mission_create_date
        mission.mission_name = mission_name
        mission.mission_type = mission_type
        mission.name = name
        mission.script = script
        mission.uid = uid
        mission.uid_and_active = uid_and_active
        mission.url = url
        return mission
    }
    
    private func getMissionFromList(missions: [MissionSummary], mission: MissionSummary) -> MissionSummary? {
        for m in missions {
            if let thisId = m.mission_id {
                if let thatId = mission.mission_id {
                    if thisId == thatId {
                        return m
                    }
                }
            }
        }
        print("return nil because missions did not contain mission_id: \(mission.mission_id)")
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
    
    /********
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
     *********/
    
}

/********************* think this can be deleted
class MissionSummaryCell : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
**********************/
