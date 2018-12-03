//
//  MissionDetailsVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 2/6/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

// In Android, the class is MissionDetailsFragment
class MissionDetailsVC: BaseViewController {

    var scrollView : UIScrollView?
    
    var missionDetailsDelegate : MissionDetailsDelegate? // defined at bottom
    
    let mission_name : UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mission_description_label : UILabel = {
        let label = UILabel()
        label.text = "Mission Description"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionAndScript : UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.font = .systemFont(ofSize: 14)
        //textView.font = UIFont.boldSystemFont(ofSize: textView.font.pointSize) // just example
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        var frame = textView.frame
        frame.size.height = 16
        textView.frame = frame
        
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let delete_button : BaseButton = {
        let button = BaseButton(text: "Delete Mission")
        button.titleLabel?.font = button.titleLabel?.font.withSize(16)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(deleteMissionPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    // passed in from extension CenterViewController : MissionListDelegate
    var mission : MissionSummary?
    var team : TeamIF?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Display:
        // name of the mission across the top
        // then, mission description
        // then, mission script
        // Android shows names and numbers underneath - not sure if we're going to do that here
        // But we ARE going to show a delete button, because we need to be able to delete missions
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        if let scrollView = scrollView, let mission = mission,
            let team = team,
            let description = mission.descrip,
            let script = mission.script {
            
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1450)
            
            view.addSubview(scrollView)
            
            scrollView.addSubview(mission_name)
            mission_name.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
            mission_name.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            
            scrollView.addSubview(mission_description_label)
            mission_description_label.topAnchor.constraint(equalTo: mission_name.bottomAnchor, constant: 16).isActive = true
            mission_description_label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(descriptionAndScript)
            descriptionAndScript.topAnchor.constraint(equalTo: mission_description_label.bottomAnchor, constant: 8).isActive = true
            descriptionAndScript.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            descriptionAndScript.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
            
            scrollView.addSubview(delete_button)
            delete_button.topAnchor.constraint(equalTo: descriptionAndScript.bottomAnchor, constant: 48).isActive = true
            delete_button.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            
            mission_name.text = mission.mission_name
            descriptionAndScript.text = description + "\n\n\nScript\n\n" + script
            
            //mission_description.text = mission.descrip
            //mission_script.text = mission.script
        }
        
    }
    
    @objc private func deleteMissionPressed(_ sender: UIButton) {
        // pop up an alert asking if you REALLY want to delete
        if let mission = mission {
            let title = "Delete Mission"
            let message = "Are you SURE you want to delete this Mission?\n\nBecause once it's gone - it's GONE"
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
            let dontDelete = UIAlertAction(title: "Don't Delete", style: .default, handler: { action in
                switch action.style {
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                }
            })
            
            let delete = UIAlertAction(title: "Yes, Delete", style: .destructive, handler: { action in
                switch action.style {
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    if let team = self.team {
                        self.deleteMission(mission: mission, team: team)
                    }
                }
            })
            
            alert.addAction(dontDelete)
            alert.addAction(delete)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func deleteMission(mission: MissionSummary, team: TeamIF) {
        if let team_name = team.getName() {
            Database.database().reference().child("teams").child(team_name).child("missions").child(mission.mission_id!).removeValue()
            missionDetailsDelegate?.missionDeleted(mission: mission)
        }
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

protocol MissionDetailsDelegate {
    func missionDeleted(mission: MissionSummary)
}
