//
//  PlayListElementButton.swift
//  MusicPlayer
//
//  Created by XCode on 24/12/23.
//

import SwiftUI

struct PlayListElementButton: View {
    var playList: PlayList?
    var viewModel: PlayerViewModel?
    var onCLick: () -> Void
    var body: some View {
        Button(
            action: {
                viewModel?.addTrackToPlayList(
                    playListId: playList?.playListId ?? 0,
                    track: viewModel?.playerState.currentAudioFile.track ?? 0
                )
                onCLick()
            }
        ){
            ZStack{
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.secondary.opacity(0.1))
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: 40
                    )
                    .padding(.horizontal, 10)
                VStack{
                    Divider()
                        .padding(.horizontal, 15)
                    HStack{
                        Text(playList?.name ?? "Test Play List")
                            .padding(.horizontal, 20)
                            .foregroundColor(.primary)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                        Spacer()
                        Text(String(playList?.tracks.count ?? 0))
                            .padding(.horizontal, 20)
                            .foregroundColor(.primary)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .trailing
                            )
                    }
                    Divider()
                        .padding(.horizontal, 15)
                }
            }
            .padding(.horizontal, 5)
        }
    }
}

struct PlayListElementButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayListElementButton(){}
    }
}
