//
//  ChooseSpreadsheetTypeVCViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/10/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

class ChooseSpreadsheetTypeVC: BaseViewController {
    
    var delegate: ChooseSpreadsheetTypeDelegate?
    
    let chooseSpreadsheetTypeHeading : UILabel = {
        let l = UILabel()
        l.text = "Choose Spreadsheet Type"
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    
    let explanationTextView : UITextView = {
        let textView = UITextView()
        textView.text = "Does your spreadsheet contains names and phone numbers? \n\nOr does your spreadsheet link to *other* spreadsheets that contain names and phone numbers?"
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)! // increase font size a little bit
        //textView.font = UIFont.boldSystemFont(ofSize: textView.font.pointSize) // just example
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    
    let button1 : BaseButton = {
        let button = BaseButton(text: "Contains Names and Numbers")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    let button2 : BaseButton = {
        let button = BaseButton(text: "Links to Other Spreadsheets")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        view.addSubview(chooseSpreadsheetTypeHeading)
        view.addSubview(explanationTextView)
        view.addSubview(button1)
        view.addSubview(button2)
        
        chooseSpreadsheetTypeHeading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        chooseSpreadsheetTypeHeading.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90).isActive = true
        //chooseSpreadsheetTypeHeading.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        //chooseSpreadsheetTypeHeading.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
        
        explanationTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        explanationTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16).isActive = true
        explanationTextView.topAnchor.constraint(equalTo: chooseSpreadsheetTypeHeading.bottomAnchor, constant: 24).isActive = true
        explanationTextView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
        //explanationLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.06).isActive = true
        
        button1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        button1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16).isActive = true
        button1.topAnchor.constraint(equalTo: explanationTextView.bottomAnchor, constant: 16).isActive = true
        button1.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
        button1.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.06).isActive = true
        
        button2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        button2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16).isActive = true
        button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 32).isActive = true
        button2.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
        button2.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.06).isActive = true
        
        /*****************
         Need a title/heading: Choose Spreadsheet Type
         Need text label:  Does your spreadsheet contains names and phone numbers?
         Need text label:  Or does your spreadsheet link to *other* spreadsheets that contain names and phone numbers?
         Need button: Contains Names and Numbers
         Need button: Links to Other Spreadsheets
 
         These buttons need to pass certain values to NewPhoneCampaignVC:
         "contains names and numbers"
         "links to other spreadsheets"
         ***************/
    }
    
    
    @objc func buttonPressed(_ sender: Any) {
        let button = sender as! BaseButton
        var text = button.titleLabel?.text
        
        guard let thetype = text, let button2Text = button2.titleLabel?.text else { return }
        var missionNode = "missions"
        if text == button2Text { missionNode = "master_missions" }
        
        // delegate is CenterViewController
        delegate?.spreadsheetTypeChosen(missionNode: missionNode)
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


protocol ChooseSpreadsheetTypeDelegate {
    func spreadsheetTypeChosen(missionNode: String) 
}



