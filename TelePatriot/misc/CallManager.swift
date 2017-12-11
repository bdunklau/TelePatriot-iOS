//
//  CallManager.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/25/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import Foundation
import CallKit

// source:  https://www.raywenderlich.com/150015/callkit-tutorial-ios
class CallManager {
    
    var callsChangedHandler: (() -> Void)?
    
    private(set) var calls = [Call]()
    
    func startCall(handle: String, videoEnabled: Bool) {
        // 1
        let handle = CXHandle(type: .phoneNumber, value: handle)
        // 2
        let startCallAction = CXStartCallAction(call: UUID(), handle: handle)
        // 3
        startCallAction.isVideo = videoEnabled
        let transaction = CXTransaction(action: startCallAction)
        
        //requestTransaction(transaction)
    }
    
    func callWithUUID(uuid: UUID) -> Call? {
        guard let index = calls.index(where: { $0.uuid == uuid }) else {
            return nil
        }
        return calls[index]
    }
    
    func add(call: Call) {
        calls.append(call)
        call.stateChanged = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.callsChangedHandler?()
        }
        callsChangedHandler?()
    }
    
    func remove(call: Call) {
        guard let index = calls.index(where: { $0 === call }) else { return }
        calls.remove(at: index)
        callsChangedHandler?()
    }
    
    func removeAllCalls() {
        calls.removeAll()
        callsChangedHandler?()
    }
}

