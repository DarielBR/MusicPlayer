//
//  ContentView.swift
//  MusicPlayer
//
//  Created by XCode on 21/12/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PlayerViewModel()
    
    var body: some View {
        MainScreen(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
