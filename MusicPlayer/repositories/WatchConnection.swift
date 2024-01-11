//
//  WatchConnection.swift
//  MusicPlayer
//
//  Created by XCode on 5/1/24.
//

import Foundation
import WatchConnectivity

class WatchConnection: NSObject, WCSessionDelegate {
    static let sharedInstance = WatchConnection()
    
    typealias MessageRecivedHandler = ([String : Any]) -> Void
    var onMessageReceived: MessageRecivedHandler?
    
    private let session: WCSession
        
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
    }
        
    func send(message: [String:Any]) -> Void {
        session.sendMessage(message, replyHandler: nil) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any]
    ){
        DispatchQueue.main.async {
            self.onMessageReceived?(message)
        }
    }
        
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // code
    }
        
    func sessionDidBecomeInactive(_ session: WCSession) {
        // code
    }
        
    func sessionDidDeactivate(_ session: WCSession) {
        // code
    }
    
    func connect() {
        guard WCSession.isSupported() else {
            print("WCSession is not supported")
            return
        }
        session.activate()
    }
}
