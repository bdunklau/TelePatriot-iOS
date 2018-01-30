//
//  BackTracker.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/12/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation

class BackTracker {
    static let sharedInstance = BackTracker()
    
    var history = [UIViewController]()
    var current : UIViewController?
    var navigationItem : UINavigationItem?
    var backHandler : BackHandler?
    private var visible = false
    
    func setNavigationItem(nav: UINavigationItem, backHandler: BackHandler) {
        navigationItem = nav
        self.backHandler = backHandler
    }
    
    func show() {
        visible = true
        navigationItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
    }
    
    func hide() {
        visible = false
        navigationItem?.leftBarButtonItem = nil
    }
    
    @objc func goBack() {
        guard let vc = onBack() else {
            navigationItem?.leftBarButtonItem = nil
            return
        }
        backHandler?.goBack(vc: vc, track: false)
    }
    
    func onChoose(vc: UIViewController) {
        
        if let curr = current {
            history.append(curr)
        }
        current = vc
        
        if !history.isEmpty { show() }
    }
    
    func onBack() -> UIViewController? {
        if history.count > 0 {
            let last = history.remove(at: history.count-1)
            current = last
            if history.isEmpty { hide() }
            return last
        } else {
            hide()
            return nil
        }
    }
    
    func last() -> UIViewController? {
        if history.count > 0 {
            let lst = history[history.count-1]
            return lst
        }
        return nil
    }
}

protocol BackHandler {
    func goBack(vc: UIViewController, track: Bool)
}
