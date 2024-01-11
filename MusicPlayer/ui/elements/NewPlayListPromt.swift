//
//  NewPlayListPromt.swift
//  MusicPlayer
//
//  Created by XCode on 24/12/23.
//

import SwiftUI

struct NewPlayListPromt: View {
    @ObservedObject var viewModel: PlayerViewModel
    var onClick: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    init(viewModel: PlayerViewModel? = nil, onClick: @escaping () -> Void) {
        self.viewModel = viewModel ?? PlayerViewModel()
        self.onClick = onClick
    }
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(colorScheme == .dark ? .primary.opacity(0.5) : .white)
                .padding(.horizontal, 10)
            HStack{
                Button(//Close button
                    action: { onClick() }
                ){
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .padding(.leading, 15)
                }
                Spacer()
                TextField(
                    "...",
                    text: $viewModel.playerState.newPlayListName
                )
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 5)
                .frame(maxWidth: .infinity)
                Spacer()
                Button(//Accept Button
                    action: {
                        viewModel.createPlaylist(
                            name: viewModel.playerState.newPlayListName,
                            track: viewModel.playerState.currentAudioFile.track
                        )
                        viewModel.clearNewPlayListName()
                        viewModel.savePlayLists()
                        onClick()
                    }
                ){
                    Image(systemName: "checkmark")
                        .padding(.trailing, 15)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 10)
        }
        .padding(.horizontal, 50)
        .frame(
            maxWidth: .infinity,
            maxHeight: 60
        )
    }
}

struct NewPlayListPromt_Previews: PreviewProvider {
    static var previews: some View {
        NewPlayListPromt(){}
    }
}
