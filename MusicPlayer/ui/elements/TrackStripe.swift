//
//  TrackStripe.swift
//  MusicPlayer
//
//  Created by XCode on 22/12/23.
//

import SwiftUI

struct TrackStripe: View {
    var audioFile: AudioFile?
    var viewModel: PlayerViewModel?
    var onClick: () -> Void
    
    var body: some View {
        Button(
            action: {
                viewModel?.setNoPlaylist()
                viewModel?.setCurrentTrackIndex(audioFile ?? AudioFile())
                viewModel?.resumePlayback(at: viewModel?.playerState.currentTime ?? 0)
                onClick()
            },
            label:{
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.secondary.opacity(0.1))
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: 85
                        )
                        .padding(.horizontal, 10)
                    HStack{
                        TrackThumbnail(
                            albumImage: audioFile?.albumImage,
                            size: 80
                        )
                        VStack{
                            Text( audioFile?.name ?? "TRACK 1" )
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                            Spacer()
                            Text( audioFile?.author ?? "Anonymous" )
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                            //Spacer()
                            Text( audioFile?.album ?? "UNKNOWN" )
                                .fontWeight(.light)
                                .italic(true)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                            
                        }
                        .padding(.vertical, 5)
                        .padding(.trailing, 15)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: 75,
                            alignment: .leading
                        )
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                }
            }
        )
    }
}

struct ThinTrackStripe: View{
    var audioFile: AudioFile?
    var viewModel: PlayerViewModel?
    var onClick: () -> Void
    
    var body: some View {
        Button(
            action: {
                //viewModel?.setNoPlaylist()
                //viewModel?.setCurrentTrackIndex(audioFile ?? AudioFile())
                //viewModel?.resumePlayback(at: viewModel?.playerState.currentTime ?? 0)
                onClick()
            },
            label:{
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.secondary.opacity(0.1))
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: 45
                        )
                        .padding(.horizontal, 10)
                    HStack{
                        VStack{
                            Text( audioFile?.name ?? "TRACK 1" )
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                            //Spacer()
                            HStack{
                                Text( audioFile?.author ?? "Anonymous" )
                                    .padding(.trailing, 5)
                                //Spacer()
                                Text( audioFile?.album ?? "UNKNOWN" )
                                    .fontWeight(.light)
                                    .italic(true)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                            }
                            
                        }
                        .padding(.vertical, 5)
                        .padding(.trailing, 15)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: 40,
                            alignment: .leading
                        )
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 15)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                }
            }
        )
    }
}

struct TrackStripe_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            TrackStripe(){}
            ThinTrackStripe(){}
        }
    }
}
