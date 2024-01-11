//
//  PlayerScreen.swift
//  MusicPlayer
//
//  Created by XCode on 23/12/23.
//

import SwiftUI

struct PlayerScreen: View {
    @ObservedObject var viewModel: PlayerViewModel
    var onClick: () -> Void
    
    init(viewModel: PlayerViewModel? = nil, onClick: @escaping () -> Void) {
        self.viewModel = viewModel ?? PlayerViewModel()
        self.onClick = onClick
    }
    
    var body: some View {
        VStack{
            Button(action: onClick){ // Button Back
                HStack{
                    Image(systemName: "chevron.backward")
                    Text("Back")
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 20)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            TrackThumbnail(
                albumImage: viewModel.playerState.currentAudioFile.albumImage,
                size: .infinity
            )
            .shadow(radius: 2, y: 2)
            VStack{
                Text( viewModel.playerState.currentAudioFile.name)
                    .fontWeight(.semibold)
                    .font(.title)
                    .foregroundColor(.primary)
                    .shadow(radius: 3, x: 2, y: 2)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                Spacer()
                Text( viewModel.playerState.currentAudioFile.author)
                    .shadow(radius: 3, x: 2, y: 2)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                //Spacer()
                Text( viewModel.playerState.currentAudioFile.album)
                    .fontWeight(.light)
                    .italic(true)
                    .shadow(radius: 3, x: 2, y: 2)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
            .padding(.trailing, 15)
            .frame(
                maxWidth: .infinity,
                maxHeight: 75,
                alignment: .leading
            )
            Spacer()
            PlayerControlPannel(
                viewModel: viewModel
            )
        }
    }
}

struct PlayerScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlayerScreen(){}
    }
}
