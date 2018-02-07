//
//  AllActivityVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/12/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import FirebaseDatabase

// modeled after MissionSummaryTVC in iOS and AllActivityFragment in Android
class AllActivityVC: BaseViewController, UITableViewDataSource {

    var events = [MissionItemEvent]()
    
    let cellId = "cellId"
    
    var activityTableView: UITableView?
    
    var ref : DatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // the "guard" will unwrap the team name.  Otherwise, you'll get nodes written to the
        // database like this...  Optional("The Cavalry")
        guard let team = TPUser.sharedInstance.getCurrentTeam()?.team_name else {
            return
        }
        ref = Database.database().reference().child("teams/\(team)/activity/all")
        
        activityTableView = UITableView(frame: self.view.bounds, style: .plain) // <--- this turned out to be key
        activityTableView?.dataSource = self
        activityTableView?.register(ActivityTableViewCell.self, forCellReuseIdentifier: "cellId")
        activityTableView?.rowHeight = 175
        view.addSubview(activityTableView!)
        
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchData() {
        self.events.removeAll()
        
        ref?.observe(.childAdded, with: {(snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any] else {
                return
            }
            
            guard let event_type = dictionary["event_type"] as? String,
                let volunteer_uid = dictionary["volunteer_uid"] as? String,
                let volunteer_name = dictionary["volunteer_name"] as? String,
                let mission_name = dictionary["mission_name"] as? String,
                let phone = dictionary["phone"] as? String,
                let volunteer_phone = dictionary["volunteer_phone"] as? String,
                let supporter_name = dictionary["supporter_name"] as? String,
                let event_date = dictionary["event_date"] as? String else {
                    return
            }
            
            let evt = MissionItemEvent(event_type: event_type, volunteer_uid: volunteer_uid, volunteer_name: volunteer_name,
                                       mission_name: mission_name, phone: phone, volunteer_phone: volunteer_phone,
                                       supporter_name: supporter_name, event_date: event_date)
            
            self.events.insert(evt, at: 0) // this is what makes the most recent activities show up at the top
            DispatchQueue.main.async {
                self.activityTableView?.reloadData()
            }
            
            
        }, withCancel: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = activityTableView?.dequeueReusableCell(withIdentifier: "cellId",
                                                                for: indexPath as IndexPath) as! ActivityTableViewCell
        
        
        let event = events[indexPath.row]
        cell.commonInit(missionItemEvent: event, ref: ref!)
        
        return cell
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
