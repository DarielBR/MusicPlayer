//
//  FileRepository.swift
//  MusicPlayer
//
//  Created by XCode on 21/12/23.
//

import Foundation
import AVFoundation
import UIKit

class FileRepository{
    
    init(){}
    
    func findAllAudioFilePaths() -> [String]? {
        var audioFilePaths = [String]()

        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let contents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])

                for fileURL in contents {
                    if fileURL.pathExtension.lowercased() == "mp3" || fileURL.pathExtension.lowercased() == "m4a" {
                        audioFilePaths.append(fileURL.path)
                    }
                }

                return audioFilePaths
            } catch {
                print("Error while enumerating files: \(error.localizedDescription)")
                return nil
            }
        }

        return nil
    }
    
    func extractID3TagData(
        _ path: String
    ) -> (
        name: String,
        author: String,
        album: String,
        albumImage: UIImage?
    )? {
        let url = URL(fileURLWithPath: path)
        do {
            let asset = AVAsset(url: url)
            var name = ""
            var author = ""
            var album = ""
            var albumImage: UIImage?

            for format in asset.availableMetadataFormats {
                for metadataItem in asset.metadata(forFormat: format) {
                    guard let commonKey = metadataItem.commonKey else {
                        continue
                    }

                    switch commonKey.rawValue {
                    case AVMetadataKey.commonKeyTitle.rawValue:
                        name = metadataItem.stringValue ?? "TRACK"
                    case AVMetadataKey.commonKeyArtist.rawValue:
                        author = metadataItem.stringValue ?? "UNKNOWN"
                    case AVMetadataKey.commonKeyAlbumName.rawValue:
                        album = metadataItem.stringValue ?? "UNKNOWN"
                    case AVMetadataKey.commonKeyArtwork.rawValue:
                        if let data = metadataItem.dataValue {
                            albumImage = UIImage(data: data)
                        }
                    default:
                        break
                    }
                }
            }

            return (
                name: name,
                author: author,
                album: album,
                albumImage: albumImage
            )
        } catch {
            print("error while extracting ID3Tag data: \(error.localizedDescription)")
            return nil
        }
    }

}
