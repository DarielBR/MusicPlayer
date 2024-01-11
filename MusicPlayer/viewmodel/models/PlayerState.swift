//
//  PlayerState.swift
//  MusicPlayer
//
//  Created by XCode on 21/12/23.
//

import Foundation

struct PlayerState{
    var files: [AudioFile] = []
    var currentTrack: Int = 0
    var currentAudioFile: AudioFile = AudioFile()
    var currentTime: TimeInterval = 0
    var currentDuration: TimeInterval = 0
    var currentPlaylist: [Int] = []
    var isPlaying: Bool = false
    var isContinousPlay: Bool = true
    var timerUpdateStaus: Bool = true
    var playLits: [PlayList] = []
    var newPlayListName: String = ""
}
