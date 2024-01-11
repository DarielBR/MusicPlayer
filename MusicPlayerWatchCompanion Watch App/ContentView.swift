//
//  ContentView.swift
//  MusicPlayerWatchCompanion Watch App
//
//  Created by XCode on 5/1/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var watchViewModel = WatchPlayerViewModel()
    var body: some View {
        WatchPlayerView(viewModel: watchViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
