//
//  MainScreen.swift
//  MusicPlayer
//
//  Created by XCode on 21/12/23.
//

import SwiftUI

struct MainScreen: View {
    @ObservedObject var viewModel: PlayerViewModel
    
    @State private var selectedTab: Int = 0
    @State private var isPlayerScreenOnShow: Bool = false
    
    init(viewModel: PlayerViewModel? = nil){
        self.viewModel = viewModel ?? PlayerViewModel()
    }
    
    var body: some View {
        VStack{
            Picker(
                "",
                selection: $selectedTab
            ){
                Label("All songs", systemImage: "music.note").tag(0)
                Label("Playlists", systemImage: "music.note.list").tag(1)
                    
            }
            .pickerStyle(.segmented)
            
            switch(selectedTab){
                case 0: Tab1(viewModel: viewModel)
                case 1: Tab2(viewModel: viewModel)
                default: Tab1(viewModel: viewModel)
            }
            
            ZStack{
                NowPlayingStripe(
                    audioFile: viewModel.playerState.currentAudioFile,
                    viewModel: viewModel
                ){
                    isPlayerScreenOnShow = true
                }
                .fullScreenCover(isPresented: $isPlayerScreenOnShow){
                    // Set the app to modify current province
                    PlayerScreen(
                        viewModel: viewModel
                    ){ isPlayerScreenOnShow = false }
                }
            }
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

struct Tab1: View {
    var viewModel: PlayerViewModel?
    @State private var isPlayerScreenOnShow: Bool = false
    
    var body: some View{
        ScrollView{
            LazyVStack{
                ForEach(viewModel?.playerState.files ?? []){audioFile in
                    TrackStripe(
                        audioFile: audioFile,
                        viewModel: viewModel
                    ){
                        isPlayerScreenOnShow = true
                    }
                    .fullScreenCover(isPresented: $isPlayerScreenOnShow){
                        // Set the app to modify current province
                        PlayerScreen(
                            viewModel: viewModel
                        ){ isPlayerScreenOnShow = false }
                    }
                }
            }
        }
    }
}

struct Tab2: View{
    var viewModel: PlayerViewModel?
    @State private var selectedPlaylist = PlayList()
    @State private var buttonsActivated: Bool = false
    var body: some View{
        VStack{
            ScrollView(.horizontal){
                LazyHStack(spacing: 5){
                    ForEach(viewModel?.playerState.playLits ?? []){playlist in
                        PlayListTag(
                            playlist: playlist
                        ){ returnedPlaylist in
                            selectedPlaylist = returnedPlaylist
                            buttonsActivated = true
                        }
                    }
                }
            }
            .frame(
                maxHeight: 300
            )
            if buttonsActivated{
                HStack{
                    PlayPLaylist(){
                        viewModel?.setCurrentPlaylist(newValue: selectedPlaylist.tracks)
                        viewModel?.resumePlayback(at: 0)
                    }
                    Spacer()
                    DeletePLaylist(){
                        viewModel?.deletePlayList(playListId: selectedPlaylist.playListId)
                        viewModel?.savePlayLists()
                        buttonsActivated = false
                    }
                }
                .padding(.horizontal, 30)
                PlaylistView(
                    playList: $selectedPlaylist,
                    viewModel: viewModel
                )
            }
            Spacer()
        }
    }
}

struct PlaylistView: View{
    @Binding var playList: PlayList
    var viewModel: PlayerViewModel?
    
    var body: some View{
        ScrollView{
            LazyVStack{
                ForEach(playList.tracks, id: \.self) { trackID in
                    if let audioFile = viewModel?.getAudioFile(by: trackID) {
                        ThinTrackStripe(audioFile: audioFile) {}
                    }
                }
            }
        }
        
    }
}


