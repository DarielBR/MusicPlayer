//
//  AudioFile.swift
//  MusicPlayer
//
//  Created by XCode on 21/12/23.
//

import Foundation
import UIKit

struct AudioFile: Identifiable{//Codable
    var id = UUID()
    var track: Int = 0
    var path: String = ""
    var name: String = ""
    var author: String = ""
    var album: String = ""
    var albumImage: UIImage?
}
