//
//  PlayList.swift
//  MusicPlayer
//
//  Created by XCode on 24/12/23.
//

import Foundation

struct PlayList: Identifiable, Codable{
    var id = UUID()
    var playListId: Int = 0
    var name: String = ""
    var tracks: [Int] = []
}
