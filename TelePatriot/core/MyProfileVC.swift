//
//  MyLegislatorsVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/22/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MyProfileVC: BaseViewController, CLLocationManagerDelegate {
    
    
    //var ref : DatabaseReference?
    var locationManager:CLLocationManager!
    var latitude : Double?
    var longitude : Double?
    var locationTuples: [(textField: UITextField?, mapItem: MKMapItem?)]!
    
    // not your residential address, just wherever you are at the moment
    var currentStreetAddress : String?
    var currentCity : String?
    var currentState : String?
    var currentZip : String?
    var houseDistrict : String? // usually a number but at least one states uses numbers+letters
    var senateDistrict : String? // usually a number but at least one states uses numbers+letters
    
    var useGPS : Bool?
    var alreadyPopulatedUsingGPS = false
    
    var addressUpdater : AddressUpdater? // defined at bottom of MyLegislatorsVC
    
    var addressNeededView : AddressNeededView?
    
    var scrollView : UIScrollView?
    
    
    let myAddressHeading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "My Address"
        l.font = l.font.withSize(24)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    
    let myAddressExplanation : UITextView = {
        let textView = UITextView()
        textView.text = "Not your residential address?  Use the fields below to update, or touch Capture Location next time you're home."
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        //textView.font = UIFont.boldSystemFont(ofSize: textView.font.pointSize) // just example
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        //var frame = textView.frame
        //frame.size.height = 200
        //textView.frame = frame
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    
    let addressLine1Field : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "Address line 1"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let addressLine2Field : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "Address line 2"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let cityField : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "City"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let stateField : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = ""
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let zipField : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "ZIP"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let houseDistrictLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "House District"
        //l.font = l.font.withSize(24)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    
    let houseDistrictValueLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        //l.font = l.font.withSize(24)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    
    let senateDistrictLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Senate District"
        //l.font = l.font.withSize(24)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    
    let senateDistrictValueLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        //l.font = l.font.withSize(24)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    
    let latitudeLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Latitude"
        //l.font = l.font.withSize(24)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    
    let latitudeValueLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        //l.font = l.font.withSize(24)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    
    let longitudeLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Longitude"
        //l.font = l.font.withSize(24)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    
    let longitudeValueLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        //l.font = l.font.withSize(24)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    
    //var myLegislatorView : MyLegislators?
    
    /*************
    let locationButton : BaseButton = {
        let button = BaseButton(text: "I'm Home Now")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(captureLocation(_:)), for: .touchUpInside)
        return button
    }()
    *************/
    
    static let save = "Save"
    
    let saveButton : BaseButton = {
        let button = BaseButton(text: MyProfileVC.save)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveResidentialAddress(_:)), for: .touchUpInside)
        return button
    }()
    
    let currentLocationButton : BaseButton = {
        let button = BaseButton(text: "Use My Current Location")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(useCurrentLocation(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userWantsToEnterAddress = useGPS != nil
        let userHasStoredAddressAlready = TPUser.sharedInstance.hasStoredLocation()
        let shouldShowAddressForm = userHasStoredAddressAlready || userWantsToEnterAddress
        
        if scrollView != nil {
            scrollView?.removeFromSuperview()
        }
        if addressNeededView != nil {
            addressNeededView?.removeFromSuperview()
        }
        
        if shouldShowAddressForm {
            showAddressForm()
        }
        else {
            showAddressNeededForm()
        }
    }
    
    private func showAddressNeededForm() {
        
        addressNeededView = AddressNeededView(frame: self.view.frame)
        addressNeededView?.addressUpdater = self
        view.addSubview(addressNeededView!)
    }
    
    private func showAddressForm() {
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scrollView?.contentSize = CGSize(width: self.view.frame.width, height: 1450)
        
        //scrollView.removeFromSuperview()
        view.addSubview(scrollView!)
        
        
        scrollView?.addSubview(myAddressHeading)
        myAddressHeading.topAnchor.constraint(equalTo: (scrollView?.topAnchor)!, constant: 8).isActive = true
        myAddressHeading.leadingAnchor.constraint(equalTo: (scrollView?.leadingAnchor)!, constant: 8).isActive = true
        //myAddressHeading.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
        //myAddressHeading.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        scrollView?.addSubview(myAddressExplanation)
        myAddressExplanation.topAnchor.constraint(equalTo: myAddressHeading.bottomAnchor, constant: 8).isActive = true
        myAddressExplanation.leadingAnchor.constraint(equalTo: (scrollView?.leadingAnchor)!, constant: 8).isActive = true
        myAddressExplanation.widthAnchor.constraint(equalTo: (scrollView?.widthAnchor)!, multiplier: 0.95).isActive = true
        
        scrollView?.addSubview(addressLine1Field)
        addressLine1Field.topAnchor.constraint(equalTo: myAddressExplanation.bottomAnchor, constant: 16).isActive = true
        addressLine1Field.centerXAnchor.constraint(equalTo: (scrollView?.centerXAnchor)!).isActive = true
        addressLine1Field.widthAnchor.constraint(equalTo: (scrollView?.widthAnchor)!, multiplier: 0.95).isActive = true
        addressLine1Field.heightAnchor.constraint(equalTo: (scrollView?.heightAnchor)!, multiplier: 0.05).isActive = true
        
        scrollView?.addSubview(addressLine2Field)
        addressLine2Field.topAnchor.constraint(equalTo: addressLine1Field.bottomAnchor, constant: 8).isActive = true
        addressLine2Field.centerXAnchor.constraint(equalTo: (scrollView?.centerXAnchor)!).isActive = true
        addressLine2Field.widthAnchor.constraint(equalTo: (scrollView?.widthAnchor)!, multiplier: 0.95).isActive = true
        addressLine2Field.heightAnchor.constraint(equalTo: (scrollView?.heightAnchor)!, multiplier: 0.05).isActive = true
        
        scrollView?.addSubview(cityField)
        cityField.topAnchor.constraint(equalTo: addressLine2Field.bottomAnchor, constant: 8).isActive = true
        cityField.leadingAnchor.constraint(equalTo: addressLine2Field.leadingAnchor, constant: 0).isActive = true
        cityField.widthAnchor.constraint(equalTo: (scrollView?.widthAnchor)!, multiplier: 0.5).isActive = true
        cityField.heightAnchor.constraint(equalTo: (scrollView?.heightAnchor)!, multiplier: 0.05).isActive = true
        
        scrollView?.addSubview(stateField)
        stateField.topAnchor.constraint(equalTo: addressLine2Field.bottomAnchor, constant: 8).isActive = true
        stateField.leadingAnchor.constraint(equalTo: cityField.trailingAnchor, constant: 8).isActive = true
        stateField.widthAnchor.constraint(equalTo: (scrollView?.widthAnchor)!, multiplier: 0.1).isActive = true
        stateField.heightAnchor.constraint(equalTo: (scrollView?.heightAnchor)!, multiplier: 0.05).isActive = true
        
        scrollView?.addSubview(zipField)
        zipField.topAnchor.constraint(equalTo: addressLine2Field.bottomAnchor, constant: 8).isActive = true
        zipField.trailingAnchor.constraint(equalTo: addressLine2Field.trailingAnchor, constant: 0).isActive = true
        zipField.widthAnchor.constraint(equalTo: (scrollView?.widthAnchor)!, multiplier: 0.25).isActive = true
        zipField.heightAnchor.constraint(equalTo: (scrollView?.heightAnchor)!, multiplier: 0.05).isActive = true
        
        scrollView?.addSubview(houseDistrictLabel)
        houseDistrictLabel.topAnchor.constraint(equalTo: cityField.bottomAnchor, constant: 8).isActive = true
        houseDistrictLabel.leadingAnchor.constraint(equalTo: cityField.leadingAnchor, constant: 0).isActive = true
        //houseDistrictLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5).isActive = true
        //houseDistrictLabel.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.05).isActive = true
        
        scrollView?.addSubview(houseDistrictValueLabel)
        houseDistrictValueLabel.topAnchor.constraint(equalTo: houseDistrictLabel.topAnchor, constant: 0).isActive = true
        houseDistrictValueLabel.leadingAnchor.constraint(equalTo: houseDistrictLabel.trailingAnchor, constant: 4).isActive = true
        
        scrollView?.addSubview(senateDistrictLabel)
        senateDistrictLabel.topAnchor.constraint(equalTo: houseDistrictLabel.bottomAnchor, constant: 8).isActive = true
        senateDistrictLabel.leadingAnchor.constraint(equalTo: houseDistrictLabel.leadingAnchor, constant: 0).isActive = true
        //senateDistrictLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5).isActive = true
        //senateDistrictLabel.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.05).isActive = true
        
        scrollView?.addSubview(senateDistrictValueLabel)
        senateDistrictValueLabel.topAnchor.constraint(equalTo: senateDistrictLabel.topAnchor, constant: 0).isActive = true
        senateDistrictValueLabel.leadingAnchor.constraint(equalTo: senateDistrictLabel.trailingAnchor, constant: 4).isActive = true
        
        /***************
        scrollView.addSubview(locationButton)
        locationButton.topAnchor.constraint(equalTo: longitudeLabel.bottomAnchor, constant: 8).isActive = true
        locationButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        ***************/
        
        scrollView?.addSubview(currentLocationButton)
        currentLocationButton.topAnchor.constraint(equalTo: cityField.bottomAnchor, constant: 72).isActive = true
        currentLocationButton.centerXAnchor.constraint(equalTo: (scrollView?.centerXAnchor)!).isActive = true
        
        scrollView?.addSubview(saveButton)
        saveButton.topAnchor.constraint(equalTo: currentLocationButton.bottomAnchor, constant: 24).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: (scrollView?.centerXAnchor)!).isActive = true
        
        
        scrollView?.addSubview(latitudeLabel)
        latitudeLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 8).isActive = true
        latitudeLabel.leadingAnchor.constraint(equalTo: senateDistrictLabel.leadingAnchor, constant: 0).isActive = true
        
        
        scrollView?.addSubview(latitudeValueLabel)
        latitudeValueLabel.topAnchor.constraint(equalTo: latitudeLabel.topAnchor, constant: 0).isActive = true
        latitudeValueLabel.leadingAnchor.constraint(equalTo: latitudeLabel.trailingAnchor, constant: 12).isActive = true
        
        
        scrollView?.addSubview(longitudeLabel)
        longitudeLabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 8).isActive = true
        longitudeLabel.leadingAnchor.constraint(equalTo: latitudeLabel.leadingAnchor, constant: 0).isActive = true
        
        
        scrollView?.addSubview(longitudeValueLabel)
        longitudeValueLabel.topAnchor.constraint(equalTo: longitudeLabel.topAnchor, constant: 0).isActive = true
        longitudeValueLabel.leadingAnchor.constraint(equalTo: longitudeLabel.trailingAnchor, constant: 4).isActive = true
        
        
        //locationTuples = [(sourceField, nil), (destinationField1, nil), (destinationField2, nil)]
        
        
        if let gps = useGPS, gps == true {
            useCurrentLocation(currentLocationButton)
        }
        else {
            if let rad1 = TPUser.sharedInstance.residential_address_line1 {
                addressLine1Field.text = rad1
            } else {
                addressLine1Field.text = ""
            }
            if let rad2 = TPUser.sharedInstance.residential_address_line2 {
                addressLine2Field.text = rad2
            } else {
                addressLine2Field.text = ""
            }
            if let rac = TPUser.sharedInstance.residential_address_city {
                cityField.text = rac
            } else {
                cityField.text = ""
            }
            if let ras = TPUser.sharedInstance.residential_address_state_abbrev {
                stateField.text = ras
            } else {
                stateField.text = ""
            }
            if let raz = TPUser.sharedInstance.residential_address_zip {
                zipField.text = raz
            } else {
                zipField.text = ""
            }
            if let hd = TPUser.sharedInstance.legislative_house_district {
                houseDistrictValueLabel.text = hd
            } else {
                houseDistrictValueLabel.text = ""
            }
            if let sd = TPUser.sharedInstance.legislative_senate_district {
                senateDistrictValueLabel.text = sd
            } else {
                senateDistrictValueLabel.text = ""
            }
            if let lat = TPUser.sharedInstance.current_latitude {
                latitudeValueLabel.text = "\(lat)"
            } else {
                latitudeValueLabel.text = ""
            }
            if let lng = TPUser.sharedInstance.current_longitude {
                longitudeValueLabel.text = "\(lng)"
            } else {
                longitudeValueLabel.text = ""
            }
         }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func callback(error: NSError?) {
        //var error : NSError?
        //error = NSError(domain:"", code:400, userInfo: ["message": "Uh Oh! You got an error.  Try again and if this problem persists, talk to Michelle or Brent"])
        var message = "Account info updated"
        var title = "Success"
        let buttonText = "OK"
        if error == nil {
            addressLine1Field.text = TPUser.sharedInstance.residential_address_line1
            addressLine2Field.text = TPUser.sharedInstance.residential_address_line2
            cityField.text = TPUser.sharedInstance.residential_address_city
            stateField.text = TPUser.sharedInstance.residential_address_state_abbrev
            zipField.text = TPUser.sharedInstance.residential_address_zip
            houseDistrictValueLabel.text = TPUser.sharedInstance.legislative_house_district
            senateDistrictValueLabel.text = TPUser.sharedInstance.legislative_senate_district
            if let lat = TPUser.sharedInstance.current_latitude {
                latitudeValueLabel.text = "\(lat)"
            } else { latitudeValueLabel.text = "" }
            
            if let lng = TPUser.sharedInstance.current_longitude {
                longitudeValueLabel.text = "\(lng)"
            } else { longitudeValueLabel.text = "" }
            
        }
        else {
            message = "Hmmm - didn't expect this...\nYou should probably talk to Michelle or Brent"
            title = "Error"
            // need to display alert box to user on error or success
            if let msg = error!.userInfo["message"] as? String {
                message = msg
            }
        }
        
        let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: { action in
            switch action.style {
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func handleLocationLookup(location: CLLocation) {
        setLatitude(latitude: location.coordinate.latitude)
        setLongitude(longitude: location.coordinate.longitude)
        
        lookupStateRepsUsing(location: location)
    }
    
    private func setLatitude(latitude: Double) {
        TPUser.sharedInstance.current_latitude = latitude
        latitudeValueLabel.text = "\(latitude)"
    }
    
    private func setLongitude(longitude: Double) {
        TPUser.sharedInstance.current_longitude = longitude
        longitudeValueLabel.text = "\(longitude)"
    }
    
    private func lookupStateRepsUsing(latitude: Double, longitude: Double, callback: @escaping ()->Void) {
        
        guard let url = URL(string: "https://openstates.org/api/v1/legislators/geo/?lat=\(latitude)&long=\(longitude)&apikey=aad44b39-c9f2-4cc5-a90a-e0503e5bdc3c") else { return }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, responseError) in
            
            let str = String(describing: type(of: data))
            print( "data is: \(str)"  )
            
            let decoder = JSONDecoder()
            let legislators = try? decoder.decode([Legislator].self, from: data!)
            
            // get house and senate district numbers here so we can put them in the TPUser object
            
            if let legs = legislators {
                DispatchQueue.main.async {
                    for legislator in legs {
                        if legislator.chamber == "lower" {
                            self.houseDistrict = legislator.district                // redundant?
                            self.houseDistrictValueLabel.text = legislator.district   // redundant?
                            TPUser.sharedInstance.legislative_house_district = self.houseDistrict
                        }
                        else {
                            self.senateDistrict = legislator.district                // redundant?
                            self.senateDistrictValueLabel.text = legislator.district   // redundant?
                            TPUser.sharedInstance.legislative_senate_district = self.senateDistrict
                        }
                    }
                    //TPUser.sharedInstance.update(callback: self.callback)
                    callback()
                }
            }
            
        }
        
        task.resume()
    }
    
    private func lookupStateRepsUsing(location: CLLocation) {
        lookupStateRepsUsing(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, callback: updateUser)
        
    }
    
    @objc private func saveResidentialAddress(_ sender: UIButton) {
        
        /*************
         look up lat/long using address
         The user could have chosen to use GPS.  If so, no big deal
         We'll look up the lat/long even though we didn't need to.
         
         And from the lat/long, we'll look up the state reps
        ****************/
        
        // Use your location
        TPUser.sharedInstance.residential_address_line1 = addressLine1Field.text
        TPUser.sharedInstance.residential_address_line2 = addressLine2Field.text
        TPUser.sharedInstance.residential_address_city = cityField.text
        TPUser.sharedInstance.residential_address_state_abbrev = stateField.text
        TPUser.sharedInstance.residential_address_zip = zipField.text
        
        guard let address1 = addressLine1Field.text,
            let city = cityField.text,
            let state = stateField.text,
            let zip = zipField.text else {
                return
        }
        
        lookupLatLongByAddress(address1: address1,
                               address2: addressLine2Field.text,
                               city: city,
                               state_abbrev: state,
                               zip: zip,
                               callback: handleLocationLookup)
        
    }
    
    
    // not sure about this   ...what will call this method, and pass in the callback?
    private func lookupLatLongByAddress(address1: String,
                                        address2: String?,
                                        city: String,
                                        state_abbrev: String,
                                        zip: String,
                                        callback: @escaping (CLLocation) -> Void) {
        
        
        var addressString = "\(address1), "
        if let addr2 = addressLine2Field.text, addr2 != "" {
            addressString += "\(addr2), "
        }
        
        addressString += "\(city), \(state_abbrev) \(zip)"
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addressString) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            callback(location)
        }
        
    }
    
    
    // get the location as lat/long.  Then use that lat/long to look up address and house and senate districts
    // This function also saves all this stuff to the user's record
    @objc private func useCurrentLocation(_ sender: UIButton) {
        
        // so we have lat/long from   func locationManager()
        doCaptureLocation()
    }
    
    
    
    private func doCaptureLocation() {
        
        //guard user != nil else {return}
        
        guard let lati = latitude,
            let longi = longitude else {
                return }
        
        //myAddressExplanation.text = "If this is your residential address, touch \"\(MyProfileVC.save)\". If not, use these fields to correct and then touch \"\(MyProfileVC.save)\""
        
        // we're getting these values every second down in func locationManager()
        TPUser.sharedInstance.residential_address_line1 = currentStreetAddress
        addressLine1Field.text = TPUser.sharedInstance.residential_address_line1
        
        TPUser.sharedInstance.residential_address_city = currentCity
        cityField.text = TPUser.sharedInstance.residential_address_city
        
        TPUser.sharedInstance.residential_address_state_abbrev = currentState
        stateField.text = TPUser.sharedInstance.residential_address_state_abbrev
        
        TPUser.sharedInstance.residential_address_zip = currentZip
        zipField.text =  TPUser.sharedInstance.residential_address_zip
        
        TPUser.sharedInstance.current_latitude = lati
        latitudeValueLabel.text = "\(lati)"
        
        TPUser.sharedInstance.current_longitude = longi
        longitudeValueLabel.text = "\(longi)"
        
        
        lookupStateRepsUsing(latitude: lati, longitude: longi, callback: updateUser)
    }
    
    private func updateUser() {
        TPUser.sharedInstance.update(callback: self.callback)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyCurrentLocation()
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        //print("user latitude = \(userLocation.coordinate.latitude)")
        //print("user longitude = \(userLocation.coordinate.longitude)")
        
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        
        CLGeocoder().reverseGeocodeLocation(locations.last!, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            //print(placeMark.addressDictionary ?? "address n/a", terminator: "")
            
            guard let plc = placeMark,
                let addrDict = placeMark.addressDictionary else {
                    return
            }
            
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                self.currentStreetAddress = locationName as String
            }
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                //print(street, terminator: "")
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                self.currentCity = city as String
            }
            
            // state
            if let state = placeMark.addressDictionary!["State"] as? NSString {
                self.currentState = state as String
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                self.currentZip = zip as String
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                //print(country, terminator: "")
            }
            
            //self.address.text = self.address.text! + "\(placeMark.addressDictionary)"
            
            // Will cause the app to get the location from GPS one time, not be continuously updated
            if let useGps = self.useGPS {
                if useGps && !self.alreadyPopulatedUsingGPS {
                    self.alreadyPopulatedUsingGPS = true
                    self.doCaptureLocation()
                }
            }
            
        })
        
    }
    
    /******************
    func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as!
            [String]).joined(separator: ", ")
    }
    ******************/
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    /**********
     
     *********/
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension MyProfileVC : AddressUpdater {
    func beginUpdatingAddressManually() {
        addressUpdater?.beginUpdatingAddressManually()
    }
    func beginUpdatingAddressUsingGPS() {
        addressUpdater?.beginUpdatingAddressUsingGPS()
    }
}



