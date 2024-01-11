//
//  WatchPlayerViewModel.swift
//  MusicPlayerWatchCompanion Watch App
//
//  Created by XCode on 5/1/24.
//

import WatchConnectivity

class WatchPlayerViewModel: ObservableObject {
    private let watchConnection: WatchConnection
    
    @Published var watchState = WatchPlayerState()
    
    init(watchConnection: WatchConnection = WatchConnection.sharedInstance) {
        self.watchConnection = watchConnection
        self.watchConnection.connect()
        self.watchConnection.onMessageReceived = {[weak self] message in
            self?.handleReceiveMessage(message)
        }
    }
    
    func sendMessage(command: String) -> Void {
        let message = [
            "command":command
        ] as [String : Any]
        self.watchConnection.send(message: message)
    }
    
    private func handleReceiveMessage(_ message: [String : Any]){
        if let title = message["title"] as? String,
           let author = message["author"] as? String,
           let isPlaying = message["is_playing"] as? Bool {
            self.watchState.title = title
            self.watchState.author = author
            self.watchState.isPlaying = isPlaying
        }
    }
}
