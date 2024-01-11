//
//  PlayListCard.swift
//  MusicPlayer
//
//  Created by XCode on 24/12/23.
//

import SwiftUI

struct PlayListCard: View {
    var viewModel: PlayerViewModel?
    @State private var isCardVisible = false
    var onClick: () -> Void

    var body: some View {
        VStack{
            Button(//GoBack Button
                action: { onClick() }
            ){
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
                    .imageScale(.large)
            }
            .padding(.leading, 25)
            .padding(.vertical, 5)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            LazyVStack(spacing: 0){
                ForEach(viewModel?.playerState.playLits ?? mockPlayLists){playList in
                    PlayListElementButton(
                        playList: playList,
                        viewModel: viewModel
                    ){ onClick() }
                }
            }
            Button(
                action: {//New Play List Button
                    isCardVisible = true
                }
            ){
                Image(systemName: "plus")
                    .foregroundColor(.primary)
                    .imageScale(.large)
            }
            .padding(.leading, 25)
            .padding(.vertical, 5)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .sheet(isPresented: $isCardVisible){
                NewPlayListPromt(viewModel: viewModel){
                    isCardVisible = false
                    onClick()
                }
            }
        }
    }
}

struct PlayListCard_Previews: PreviewProvider {
    
    static var previews: some View {
        PlayListCard(){}
    }
}

let mockPlayLists: [PlayList] = [
    PlayList(
        playListId: 1,
        name: "Jazz time"
    ),
    PlayList(
        playListId: 2,
        name: "Good Oldies"
    )
]
