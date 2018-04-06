//
//  StatePicker.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 3/31/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit

class StatePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    
    var statePickerData = ["Tennessee", "Texas", "Utah", "Wisconsin"]
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    // source:  https://codewithchris.com/uipickerview-example/
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statePickerData.count
    }
    
    // source:  https://codewithchris.com/uipickerview-example/
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("titleForRow row = \(row)  -  pickerData[row] = \(statePickerData[row])")
        return statePickerData[row]
    }
    
    
    // source:  https://codewithchris.com/uipickerview-example/
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        print("didSelectRow row = \(row): \(statePickerData[row])")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
