//
//  Buttons.swift
//  MusicPlayer
//
//  Created by XCode on 21/12/23.
//

import SwiftUI

struct PlayButton: View {
    var viewModel: PlayerViewModel
    var size: CGFloat
    @State private var isPlaying: Bool
    @Environment(\.colorScheme) var colorScheme
    
    init(viewModel: PlayerViewModel? = nil, size: CGFloat = 25){
        self.viewModel = viewModel ?? PlayerViewModel()
        self.size = size
        _isPlaying = State(initialValue: viewModel?.playerState.isPlaying ?? true)
    }
    
    var body: some View {
        Button(
            action: {
                if viewModel.playerState.isPlaying {
                    viewModel.pausePlayback()
                }
                else {
                    viewModel.resumePlayback(at: viewModel.playerState.currentTime)
                }
                isPlaying.toggle()
            }
        ){
            if isPlaying { Image(systemName: "pause.fill").padding(size) }
            else { Image(systemName: "play.fill").padding(size) }
        }
        .foregroundColor(.primary)
        .background(colorScheme == .dark ? .gray.opacity(0.4) : .white)
        .cornerRadius(.infinity)
        .shadow(color: .secondary.opacity(0.4), radius: 5, y: 1)
    }
}

struct NextButton: View {
    var size: CGFloat = 15
    var onClick: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: { onClick() }){
            Image(systemName: "forward.end.fill")
                .padding(size)
                .imageScale(.small)
        }
        .foregroundColor(.primary)
        .background(colorScheme == .dark ? .gray.opacity(0.4) : .white)
        .cornerRadius(.infinity)
        .shadow(color: .secondary.opacity(0.4), radius: 5, y: 1)
    }
}

struct PrevButton: View {
    var size: CGFloat = 15
    var onClick: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: { onClick() }){
            Image(systemName: "backward.end.fill")
                .padding(size)
                .imageScale(.small)
        }
        .foregroundColor(.primary)
        .background(colorScheme == .dark ? .gray.opacity(0.4) : .white)
        .cornerRadius(.infinity)
        .shadow(color: .secondary.opacity(0.4), radius: 5, y: 1)
    }
}

struct ContinousPlayBackToogler: View {
    var viewModel: PlayerViewModel
    @State var isContinousPlayback: Bool
    
    init(viewModel: PlayerViewModel? = nil){
        self.viewModel = viewModel ?? PlayerViewModel()
        self.isContinousPlayback = viewModel?.playerState.isContinousPlay ?? true
    }

    var body: some View{
        Button(
            action: {
                viewModel.toogleContinousPlayState()
                self.isContinousPlayback.toggle()
            }
        ){
            Image(systemName: "infinity")
                .imageScale(.large)
                .padding(.leading, 15)
        }
        .foregroundColor(isContinousPlayback ? .primary : .primary.opacity(0.4))
        .shadow(color: .secondary.opacity(0.4), radius: 5, y: 1)
    }
}

struct AddToPlayListButton: View{
    var onClick: () -> Void
    
    var body: some View{
        Button(
            action: {
                
            }
        ){
            Image(systemName: "text.badge.plus")
                .imageScale(.large)
                .padding(.trailing, 15)
        }
        .foregroundColor(.primary)
        .shadow(color: .secondary.opacity(0.4), radius: 5, y: 1)
    }
}

struct PlayPLaylist: View{
    var onClick: () -> Void
    
    var body: some View{
        Button(
            action: onClick
        ){
            VStack{
                Label("play this list", systemImage: "rectangle.stack.badge.play")
            }
        }
        .foregroundColor(.primary)
        .shadow(color: .secondary.opacity(0.4), radius: 5, y: 1)
    }
}

struct DeletePLaylist: View{
    var onClick: () -> Void
    
    var body: some View{
        Button(
            action: onClick
        ){
            VStack{
                Label("delete this list", systemImage: "trash")
            }
        }
        .foregroundColor(.primary)
        .shadow(color: .secondary.opacity(0.4), radius: 5, y: 1)
    }
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            HStack{
                AddToPlayListButton(){}
                PrevButton(onClick: {})
                PlayButton()
                NextButton(onClick: {})
                ContinousPlayBackToogler()
            }
            HStack{
                PlayPLaylist(onClick: {})
                DeletePLaylist(onClick: {})
            }
        }
        
    }
}
