//
//  WatchPlayerView.swift
//  MusicPlayerWatchCompanion Watch App
//
//  Created by XCode on 5/1/24.
//

import SwiftUI
import WatchKit

struct WatchPlayerView: View {
    @ObservedObject var viewModel: WatchPlayerViewModel // Define this ViewModel
    
    init(viewModel: WatchPlayerViewModel? = nil) {
        self.viewModel = viewModel ?? WatchPlayerViewModel()
    }
    
    var body: some View {
        VStack {
            Text(viewModel.watchState.title + " - " + viewModel.watchState.author)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            HStack {
                Button(action: {
                    viewModel.sendMessage(command: "prev")
                    viewModel.sendMessage(command: "play")
                }) {
                    Image(systemName: "backward.fill")
                }

                Button(action: {
                    if viewModel.watchState.isPlaying{ viewModel.sendMessage(command: "pause") }
                    else {viewModel.sendMessage(command: "play")}
                }) {
                    Image(systemName: viewModel.watchState.isPlaying ? "pause.fill" : "play.fill")
                }

                Button(action: {
                    viewModel.sendMessage(command: "next")
                    viewModel.sendMessage(command: "play")
                }) {
                    Image(systemName: "forward.fill")
                }
            }
        }
    }
}

struct WatchPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        WatchPlayerView()
    }
}
