//
//  SwitchTeamsVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/16/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class SwitchTeamsVC: BaseViewController, UITableViewDataSource {
    
    var teams = [Team]()
    
    let cellId = "cellId"
    
    var teamTableView: UITableView?
    
    var ref : DatabaseReference?
    
    var delegate : SwitchTeamsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var uid = TPUser.sharedInstance.getUid()
        ref = Database.database().reference().child("users/\(uid)/teams")
        
        
        teamTableView = UITableView(frame: self.view.bounds, style: .plain) // <--- this turned out to be key
        teamTableView?.dataSource = self
        teamTableView?.delegate = self
        teamTableView?.register(TeamTableViewCell.self, forCellReuseIdentifier: "cellId")
        
        // blank header view is the "Clayton Bink" fix.  For some reason, his phone wasn't showing the list of
        // teams properly under the gray nav bar.  So this header view is just for some padding.
        var headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        teamTableView?.tableHeaderView = headerView
        //teamTableView?.rowHeight = 150
        view.addSubview(teamTableView!)
        
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchData() {
        //teams.removeAll()
        
        ref?.observe(.childAdded, with: {(snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any] else {
                return
            }
            
            guard let team_name = dictionary["team_name"] as? String else {
                return
            }
            
            let team = Team(team_name: team_name)
            
            // you'll get duplicate/phantom team entries without this.  That's because we explicitly
            // call viewDidLoad() in CenterViewController.doView()
            guard self.findIndex(teams: self.teams, team: team) == nil else {
                return
            }
            
            self.teams.insert(team, at: 0)
            print(team)
            DispatchQueue.main.async {
                self.teamTableView?.reloadData()
            }
            
        }, withCancel: nil)
        
        
        ref?.observe(.childRemoved, with: {(snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any] else {
                return
            }
            
            guard let team_name = dictionary["team_name"] as? String else {
                return
            }
            
            let team = Team(team_name: team_name)
            
            // find the team in the array and remove it
            guard let index = self.findIndex(teams: self.teams, team: team) else {
                return
            }
            
            self.teams.remove(at: index)
            print(team)
            DispatchQueue.main.async {
                self.teamTableView?.reloadData()
            }
        })
    }
    
    func findIndex(teams: [Team], team: Team) -> Int? {
        var i = 0
        for t in self.teams {
            if t.team_name == team.team_name {
                return i
            }
            i = i + 1
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = teamTableView?.dequeueReusableCell(withIdentifier: "cellId",
                                                          for: indexPath as IndexPath) as! TeamTableViewCell
        
        
        let team = teams[indexPath.row]
        cell.commonInit(team: team, ref: ref!)
        
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

extension SwitchTeamsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get the team on this row
        let team = teams[indexPath.row]
        delegate?.teamSelected(team: team) // delegate set in ContainerViewController.viewDidLoad()
    }
}
