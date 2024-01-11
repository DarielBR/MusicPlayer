//
//  AudioRepository.swift
//  MusicPlayer
//
//  Created by XCode on 21/12/23.
//

import Foundation
import AVFoundation

class AudioRepository{
    static let sharedInstance = AudioRepository()
    
    var avPlayer: AVAudioPlayer?
    var timer: Timer?
    
    init() {}
    
    init(avPlayer: AVAudioPlayer? = nil) {
        self.avPlayer = avPlayer
        self.configureAudioSession()
    }
    
    func configureAudioSession() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Error setting up audio session: \(error.localizedDescription)")
            }
        }
    
    func prepareAudioFile(_ path: String) -> TimeInterval?{
        let url = URL(fileURLWithPath: path)
        do {
            avPlayer = try AVAudioPlayer(contentsOf: url)
            avPlayer?.prepareToPlay()
            
        } catch {
            print("error: \(error.localizedDescription)")
        }
        guard let avPlayer = avPlayer else {
            return nil
        }
        return avPlayer.duration
    }
    
    func getCurrentTime() -> TimeInterval?{
        guard let avPlayer = self.avPlayer else { return nil }
        
        return avPlayer.currentTime
    }
    
    func resumePlayback(at time: TimeInterval? = nil) {
        if let time = time {
            avPlayer?.currentTime = time
        }
        avPlayer?.play()
    }
    
    func pausePlayback() -> TimeInterval? {
        guard let avPlayer = avPlayer, avPlayer.isPlaying else {
            return nil
        }
        avPlayer.pause()
        return avPlayer.currentTime
    }
}
