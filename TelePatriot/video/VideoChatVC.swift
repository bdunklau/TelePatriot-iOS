//
//  VideoChatVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 3/27/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class VideoChatVC: BaseViewController, VCConnectorIConnect, VCConnectorIRegisterRemoteCameraEventListener,
VCConnectorIRegisterLocalCameraEventListener, VCConnectorIRegisterLocalSpeakerEventListener, VCConnectorIRegisterLocalMicrophoneEventListener, VCConnectorIRegisterParticipantEventListener
{

    var databaseRef : DatabaseReference?
    
    // Vidyo code ref:   https://vidyo.io/blog/how-to/vidyo-io-using-swift-build-ios-video-chat-app/
    private var connector:VCConnector?
    var selfView : UIView?
    
    
    var remoteViews: UIView!
    //var selfView = UIView()
    var micButton: UIButton!
    var callButton: UIButton!
    var cameraButton: UIButton!
    private var remoteViewsMap:[String:UIView] = [:]
    private var numberOfRemoteViews = 0   
    var resourceID          = ""
    var displayName         = ""
    var micMuted            = false
    var cameraMuted         = false
    //var expandedSelfView    = true //false
    var connected = false
    
    
    
    let descriptionLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Description"
        return l
    }()
    
    
    let video_mission_description : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        
        // this setting, plus the widthAnchor constraint below is how we achieve word wrapping inside the scrollview
        l.numberOfLines = 0
        l.text = "This is where we describe what kind of video we're shooting.  Is it a Video Petition or something else?  The people shooting the video are going to be reading this to find out."
        return l
    }()
    
    
    let edit_video_mission_description_button : BaseButton = {
        let button = BaseButton(text: "Edit")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editVideoMissionDescription(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let legislatorLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Legislator"
        return l
    }()
    
    
    let legislator : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Rep Noncommittal Fence Sitter"
        return l
    }()
    
    
    let state : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "XX"
        return l
    }()
    
    
    let chamber : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "HD"
        return l
    }()
    
    
    let district : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "200"
        return l
    }()
    
    
    let fbLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "FB:"
        return l
    }()
    
    
    let fbHandle : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "@RepHaventMadeUpMyMind"
        return l
    }()
    
    
    let twLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "TW:"
        return l
    }()
    
    
    let twHandle : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "@RepFenceSitter"
        return l
    }()
    
    
    let youtubeVideoDescriptionLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "YouTube Video Description"
        return l
    }()
    
    
    let youtubeVideoDescriptionSubtitle : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        
        // this setting, plus the widthAnchor constraint below is how we achieve word wrapping inside the scrollview
        l.numberOfLines = 0
        l.text = "(This is what people will see in the video description field on YouTube)"
        return l
    }()
    
    
    let youtubeVideoDescription : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        
        // this setting, plus the widthAnchor constraint below is how we achieve word wrapping inside the scrollview
        l.numberOfLines = 0
        l.text = "A conversation with Xxxxx Xxxxx, a constituent of Rep Fence Sitter, asking the Rep Fence Sitter to support the Convention of States resolution.\n\nSign the petition here: https://www.conventionofstates.com and become part of the solution that's as big as the problem"
        return l
    }()
    
    /*******************
     not ready for primetime - this might even go on another screen, maybe a popup/popover dialog
    var statePicker: UIPickerView = {
        let p = UIPickerView()
        //p.translatesAutoresizingMaskIntoConstraints = false // <-- ALWAYS DO THIS - EXCEPT IN THIS CASE
        return p
    }()
    ****************/
    
    
    // this is for connecting AND disconnecting
    let connectionButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Connect", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(connectionClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    /***************
    let connectButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Connect", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(connectClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    let disconnectButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Disconnect", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(disconnectClicked(_:)), for: .touchUpInside)
        return button
    }()
    *****************/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: self.view.bounds.height / 3 + 96, width: self.view.frame.width, height: self.view.frame.height))
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1450)
        
        selfView = UIView(frame: CGRect(x: 0, y: 60, width: self.view.bounds.width / 2, height: self.view.bounds.height / 3))
        remoteViews = UIView(frame: CGRect(x: self.view.bounds.width / 2, y: 60, width: self.view.bounds.width / 2, height: self.view.bounds.height / 3))
        
        
        // Vidyo code ref:   https://vidyo.io/blog/how-to/vidyo-io-using-swift-build-ios-video-chat-app/
        VCConnectorPkg.vcInitialize()
        connector = VCConnector(nil, // For custom handling of views, set this to nil.  See:  https://github.com/Vidyo/customview-swift-ios/blob/master/CustomLayoutSample/CustomViewController.swift
                                viewStyle: .default,
                                remoteParticipants: 4,
                                logFileFilter: UnsafePointer("warning"),
                                logFileName: UnsafePointer(""),
                                userData: 0)
    
        
        
        // Oh Yeah! This is how you listen for camera events!!!
        if connector != nil {
            // When For custom view we need to register to all the device events
            connector?.registerLocalCameraEventListener(self)
            connector?.registerRemoteCameraEventListener(self)
            connector?.registerLocalSpeakerEventListener(self)
            connector?.registerLocalMicrophoneEventListener(self)
            connector?.registerParticipantEventListener(self)
        }
        
        /***************
        if let w = selfView?.frame.size.width, let h = selfView?.frame.size.height {
            connector?.showView(at: &selfView,
                                x: 0,
                                y: 0,
                                width: UInt32(w / 2),
                                height: UInt32(h))
        }
        ************/
        
        
        selfView?.backgroundColor = UIColor.red
        view.addSubview(selfView!) // placement is dictated by the dimensions of the CGRect in the UIView's constructor
        
        remoteViews?.backgroundColor = UIColor.blue
        view.addSubview(remoteViews!) // placement is dictated by the dimensions of the CGRect in the UIView's constructor
        
        view.addSubview(connectionButton)
        connectionButton.topAnchor.constraint(equalTo: view.topAnchor, constant: self.view.bounds.height / 3 + 60).isActive = true
        connectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(video_mission_description)
        video_mission_description.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        video_mission_description.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        // this constraint plus this attribute setting above: l.numberOfLines = 0
        // is how we achieve word wrapping inside the scrollview
        video_mission_description.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0.95).isActive = true
        
        scrollView.addSubview(legislatorLabel)
        legislatorLabel.topAnchor.constraint(equalTo: video_mission_description.bottomAnchor, constant: 16).isActive = true
        legislatorLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(legislator)
        legislator.topAnchor.constraint(equalTo: legislatorLabel.bottomAnchor, constant: 8).isActive = true
        legislator.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(state)
        state.bottomAnchor.constraint(equalTo: legislator.bottomAnchor, constant: 0).isActive = true
        state.leadingAnchor.constraint(equalTo: legislator.trailingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(chamber)
        chamber.bottomAnchor.constraint(equalTo: legislator.bottomAnchor, constant: 0).isActive = true
        chamber.leadingAnchor.constraint(equalTo: state.trailingAnchor, constant: 4).isActive = true
        
        scrollView.addSubview(district)
        district.bottomAnchor.constraint(equalTo: legislator.bottomAnchor, constant: 0).isActive = true
        district.leadingAnchor.constraint(equalTo: chamber.trailingAnchor, constant: 4).isActive = true
        
        scrollView.addSubview(fbLabel)
        fbLabel.topAnchor.constraint(equalTo: legislator.bottomAnchor, constant: 8).isActive = true
        fbLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(fbHandle)
        fbHandle.bottomAnchor.constraint(equalTo: fbLabel.bottomAnchor, constant: 0).isActive = true
        fbHandle.leadingAnchor.constraint(equalTo: fbLabel.trailingAnchor, constant: 4).isActive = true
        
        scrollView.addSubview(twLabel)
        twLabel.topAnchor.constraint(equalTo: fbLabel.bottomAnchor, constant: 8).isActive = true
        twLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(twHandle)
        twHandle.bottomAnchor.constraint(equalTo: twLabel.bottomAnchor, constant: 0).isActive = true
        twHandle.leadingAnchor.constraint(equalTo: twLabel.trailingAnchor, constant: 4).isActive = true
        
        scrollView.addSubview(youtubeVideoDescriptionLabel)
        youtubeVideoDescriptionLabel.topAnchor.constraint(equalTo: twHandle.bottomAnchor, constant: 16).isActive = true
        youtubeVideoDescriptionLabel.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(youtubeVideoDescriptionSubtitle)
        youtubeVideoDescriptionSubtitle.topAnchor.constraint(equalTo: youtubeVideoDescriptionLabel.bottomAnchor, constant: 8).isActive = true
        youtubeVideoDescriptionSubtitle.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 8).isActive = true
        // this constraint plus this attribute setting above: l.numberOfLines = 0
        // is how we achieve word wrapping inside the scrollview
        youtubeVideoDescriptionSubtitle.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0.95).isActive = true
        
        scrollView.addSubview(youtubeVideoDescription)
        youtubeVideoDescription.topAnchor.constraint(equalTo: youtubeVideoDescriptionSubtitle.bottomAnchor, constant: 8).isActive = true
        youtubeVideoDescription.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 8).isActive = true
        // this constraint plus this attribute setting above: l.numberOfLines = 0
        // is how we achieve word wrapping inside the scrollview
        youtubeVideoDescription.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0.95).isActive = true
        
        view.addSubview(scrollView)
        //scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        //scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        /*************************
         not ready for primetime
        statePicker.frame = CGRect(x: 0, y: self.view.bounds.height/3 + 20, width: self.view.bounds.width, height: 200.0)
        statePicker.delegate = self
        statePicker.dataSource = self
        //statePicker.selectRow(-1, inComponent: 0, animated: false)
        
        scrollView.addSubview(statePicker)
         ******************/
        
        if let vn = createVideoNode() {
            video_mission_description.text = vn.video_mission_description
        }
    }
    
    private func createVideoNode() -> VideoNode? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // hardcode for now...
        let theType = "Video Petition"
        // appDelegate.videoTypes is created in AppDelegate: func application(_ application: UIApplication, didFinishLaunchingWithOptions...)
        let videoType = appDelegate.videoTypes.filter{ $0.type == theType }.first
        if let vt = videoType {
            let videoNode = VideoNode(creator: TPUser.sharedInstance, type: vt)
            videoNode.save()
            return videoNode
        }
        else { return nil }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func connectionClicked(_ sender: Any) {
        if connected {
            connector?.disconnect()
            connectionButton.setTitle("Connect", for: .normal)
            connected = false
        }
        else {
            connectClicked(sender)
            connected = true
        }
    }
    
    
    // TROUBLESHOOTING...
    // https://support.vidyocloud.com/hc/en-us/sections/115000596414-Testing-and-Troubleshooting
    // https://support.vidyocloud.com/hc/en-us/articles/218309687-I-see-no-video-just-a-black-window-or-receive-a-DirectX-error
    @objc func connectClicked(_ sender: Any) {
        connectionButton.setTitle("Connecting...", for: .normal)
        let room = "demoRoom" // TODO make this dynamic based on who the participants are
        let name = "Brent" //TPUser.sharedInstance.getName()
        guard let escapedString = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return }
        let urlString = "https://us-central1-telepatriot-bd737.cloudfunctions.net/generateVidyoToken?userName=\(escapedString)"
        guard let url = URL(string: urlString) else {
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, responseError) in
            
            let str = String(describing: type(of: data))
            print( "data is: \(str)"  )
            
            let decoder = JSONDecoder()
            guard let tokenResponse = try? decoder.decode([String:String].self, from: data!) else {
                return }
            
            DispatchQueue.main.async {
                guard let token = tokenResponse["token"] else { return }
                
                self.connector?.connect("prod.vidyo.io",
                                        token: token,
                                        displayName: name,
                                        resourceId: room,
                                        connectorIConnect: self)
                
                self.connectionButton.setTitle("Disconnect", for: .normal)
            }
        }
        
        task.resume()
    }
    
    /***********
    @objc func disconnectClicked(_ sender: Any) {
        connector?.disconnect()
        connectButton.setTitle("Connect", for: .normal)
    }
    ************/
    
    // MARK: - VCIConnect delegate methods
    
    func onSuccess() {
        print("Connection Successful")
    }
    
    func onFailure(_ reason: VCConnectorFailReason) {
        print("Connection failed \(reason)")
    }
    
    func onDisconnected(_ reason: VCConnectorDisconnectReason) {
        print("Call Disconnected")
    }
    
    
    func refreshUI() {
        DispatchQueue.main.async {
            
            // Updating local (self) view
            /*************
            if self.expandedSelfView {
                self.selfView?.frame.size.width  = UIScreen.main.bounds.size.width / 2
                self.selfView?.frame.size.height = UIScreen.main.bounds.size.height / 2
            } else {
                self.selfView?.frame.size.width  = UIScreen.main.bounds.size.width / 4
                self.selfView?.frame.size.height = UIScreen.main.bounds.size.height / 4
            }
            self.selfView?.frame.origin.x = UIScreen.main.bounds.size.width - (self.selfView?.frame.size.width)! - 10
            self.selfView?.frame.origin.y = UIScreen.main.bounds.size.height - (self.selfView?.frame.size.height)! - 0
            
             ***********/
            
            guard let w = self.selfView?.frame.size.width,
                let h = self.selfView?.frame.size.height else {
                    return
            }
            
            /***********
            if let x = self.selfView?.frame.size.width {
                self.connector?.showView(at: UnsafeMutableRawPointer(&self.remoteViews),
                                         x: Int32(x) / 2,
                                         y: 0,
                                         width: UInt32(w),
                                         height: UInt32(h))
            }
            ***********/
            
            
            // Updating remote views
            let refFrames   = RemoteViewLayout.getTileFrames(numberOfTiles: self.numberOfRemoteViews)
            var index       = 0
            /****************/
            for var remoteView in self.remoteViewsMap.values {
                let refFrame        = refFrames[index] as! CGRect
                remoteView.frame    = refFrame
                self.connector?.showView(at: UnsafeMutableRawPointer(&remoteView),
                                         x: 0,
                                         y: 0,
                                         width: UInt32(w), // change this
                                         height: UInt32(h))
                
                // updating label location
                for subview in remoteView.subviews
                {
                    if let item = subview as? UILabel
                    {
                        item.frame = CGRect(x: 0,
                                            y: 10,
                                            width: remoteView.frame.width,
                                            height: 20)
                    }
                }
                index += 1
                if index >= 4 {
                    // Showing max 4 remote participants
                    break
                }
            }
            /*************/
        }
    }
    
    
    // MARK: - IRegisterRemoteCameraEventListener delegate methods
    
    func onRemoteCameraAdded(_ remoteCamera: VCRemoteCamera!, participant: VCParticipant!) {
        
        numberOfRemoteViews += 1
        DispatchQueue.main.async {
            var newRemoteView = UIView()
            newRemoteView.layer.borderColor = UIColor.black.cgColor
            newRemoteView.layer.borderWidth = 1.0
            self.remoteViews.addSubview(newRemoteView)
            self.remoteViewsMap[participant.getId()] = newRemoteView
            self.connector?.assignView(toRemoteCamera: UnsafeMutableRawPointer(&newRemoteView),
                                       remoteCamera: remoteCamera,
                                       displayCropped: true,
                                       allowZoom: /*true*/false)
            self.connector?.showViewLabel(UnsafeMutableRawPointer(&newRemoteView),
                                          showLabel: false)
            
            // Adding custom UILabel to show the participant name
            let newParticipantNameLabel = UILabel()
            newParticipantNameLabel.text = participant.getName()
            newParticipantNameLabel.textColor = UIColor.white
            newParticipantNameLabel.textAlignment = .center
            newParticipantNameLabel.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            newParticipantNameLabel.shadowOffset = CGSize(width: 1, height: 1)
            newParticipantNameLabel.font = newParticipantNameLabel.font.withSize(14)
            newRemoteView.addSubview(newParticipantNameLabel)
            
            self.refreshUI()
        }
    }
    
    func onRemoteCameraRemoved(_ remoteCamera: VCRemoteCamera!, participant: VCParticipant!) {
        numberOfRemoteViews -= 1
        DispatchQueue.main.async {
            let remoteView = self.remoteViewsMap.removeValue(forKey: participant.getId())
            for view in (remoteView?.subviews)!{
                view.removeFromSuperview()
            }
            remoteView?.removeFromSuperview()
            
            self.refreshUI()
        }
    }
    
    func onRemoteCameraStateUpdated(_ remoteCamera: VCRemoteCamera!, participant: VCParticipant!, state: VCDeviceState) {
        
    }
    
    
    // MARK: - IRegisterLocalCameraEventListener delegate methods
    
    func onLocalCameraRemoved(_ localCamera: VCLocalCamera!) {
        self.selfView?.isHidden = true
    }
    
    func onLocalCameraAdded(_ localCamera: VCLocalCamera!) {
        if ((localCamera) != nil) {
            self.selfView?.isHidden = false
            DispatchQueue.main.async {
                
                if let w = self.selfView?.frame.size.width, let h = self.selfView?.frame.size.height {
                    self.connector?.assignView(toLocalCamera: UnsafeMutableRawPointer(&self.selfView),
                                               localCamera: localCamera,
                                               displayCropped: true,
                                               allowZoom: false)
                    self.connector?.showViewLabel(UnsafeMutableRawPointer(&self.selfView),
                                                  showLabel: false)
                    self.connector?.showView(at: UnsafeMutableRawPointer(&self.selfView),
                                             x: 0,
                                             y: 0,
                                             width: UInt32(w),
                                             height: UInt32(h))
                }
                
            }
        }
    }
    
    func onLocalCameraSelected(_ localCamera: VCLocalCamera!) {
        
    }
    
    func onLocalCameraStateUpdated(_ localCamera: VCLocalCamera!, state: VCDeviceState) {
        
    }
    
    // MARK: - IRegisterParticipantEventListener delegate methods
    
    func onParticipantLeft(_ participant: VCParticipant!) {
        
    }
    
    func onParticipantJoined(_ participant: VCParticipant!) {
        
    }
    
    func onLoudestParticipantChanged(_ participant: VCParticipant!, audioOnly: Bool) {
        
    }
    
    func onDynamicParticipantChanged(_ participants: NSMutableArray!, remoteCameras: NSMutableArray!) {
        
    }
    
    // MARK: - IRegisterLocalSpeakerEventListener delegate methods
    
    func onLocalSpeakerAdded(_ localSpeaker: VCLocalSpeaker!) {
        
    }
    
    func onLocalSpeakerRemoved(_ localSpeaker: VCLocalSpeaker!) {
        
    }
    
    func onLocalSpeakerSelected(_ localSpeaker: VCLocalSpeaker!) {
        
    }
    
    func onLocalSpeakerStateUpdated(_ localSpeaker: VCLocalSpeaker!, state: VCDeviceState) {
        
    }
    
    // MARK: - IRegisterLocalMicrophoneEventListener delegate methods
    
    func onLocalMicrophoneAdded(_ localMicrophone: VCLocalMicrophone!) {
        
    }
    
    func onLocalMicrophoneRemoved(_ localMicrophone: VCLocalMicrophone!) {
        
    }
    
    func onLocalMicrophoneSelected(_ localMicrophone: VCLocalMicrophone!) {
        
    }
    
    func onLocalMicrophoneStateUpdated(_ localMicrophone: VCLocalMicrophone!, state: VCDeviceState) {
        
    }
    
    // MARK: - IRegisterRemoteMicrophoneEventListener delegate methods
    
    func onRemoteMicrophoneAdded(_ remoteMicrophone: VCRemoteMicrophone!, participant: VCParticipant!) {
        
    }
    
    func onRemoteMicrophoneRemoved(_ remoteMicrophone: VCRemoteMicrophone!, participant: VCParticipant!) {
        
    }
    
    func onRemoteMicrophoneStateUpdated(_ remoteMicrophone: VCRemoteMicrophone!, participant: VCParticipant!, state: VCDeviceState) {
        
    }

    
    @objc private func editVideoMissionDescription(_ sender: UIButton) {
        // pop up a dialog with a text field showing the video mission description
        // and save, cancel buttons
    }

}
