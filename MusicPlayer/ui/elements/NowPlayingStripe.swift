//
//  NowPlayingStripe.swift
//  MusicPlayer
//
//  Created by XCode on 28/12/23.
//

import SwiftUI

struct NowPlayingStripe: View {
    var audioFile: AudioFile?
    var viewModel: PlayerViewModel?
    var onClick: () -> Void
    
    var body: some View {
        Button(
            action: {
                onClick()
            },
            label:{
                ZStack{
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.secondary.opacity(0.1))
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: 85
                        )
                        //.padding(.horizontal, 10)
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
                    HStack{
                        PlayButton(
                            viewModel: viewModel,
                            size: 15
                        )
                    }
                    .padding(.trailing, 25)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .trailing
                    )
                }
            }
        )
    }
}

struct NowPlayingStripe_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingStripe(){}
    }
}
