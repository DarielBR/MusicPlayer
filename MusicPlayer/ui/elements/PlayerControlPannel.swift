//
//  PlayerControlPannel.swift
//  MusicPlayer
//
//  Created by XCode on 23/12/23.
//

import SwiftUI

struct PlayerControlPannel: View {
    var viewModel: PlayerViewModel?
    var size: CGFloat = .infinity
    
    @Environment(\.colorScheme) var colorScheme
    @State private var isCardVisible = false
    
    var body: some View {
        //VStack{
            //Spacer()
            ZStack{
                Rectangle()
                    .fill(colorScheme == .dark ? .gray.opacity(0.1) : .white)
                    .shadow(radius: 2, y: -2)
                VStack{
                    TimeSlider(viewModel: viewModel)
                    HStack{
                        Button(//Play List functionality
                            action: {
                                isCardVisible = true
                            }
                        ){
                            Image(systemName: "text.badge.plus")
                                .imageScale(.large)
                                .padding(.trailing, 15)
                        }
                        .foregroundColor(.primary)
                        .shadow(color: .secondary.opacity(0.4), radius: 5, y: 1)
                        .sheet(isPresented: $isCardVisible){
                            PlayListCard(viewModel: viewModel){ isCardVisible = false }
                        }
                        PrevButton(){
                            viewModel?.setPlayingState(newValue: false)
                            viewModel?.prevTrack()
                            viewModel?.prepareAudio()
                            viewModel?.setCurrentAudioFile()
                            viewModel?.resumePlayback(at: 0)
                            viewModel?.setPlayingState(newValue: true)
                        }
                        PlayButton(viewModel: viewModel)
                        NextButton(){
                            viewModel?.setPlayingState(newValue: false)
                            viewModel?.nextTrack()
                            viewModel?.prepareAudio()
                            viewModel?.setCurrentAudioFile()
                            viewModel?.resumePlayback(at: 0)
                            viewModel?.setPlayingState(newValue: true)
                        }
                        ContinousPlayBackToogler(viewModel: viewModel)
                        
                    }
                }
            }
            .aspectRatio(1.90, contentMode: .fit)
            .frame(
                maxWidth: size
            )
        //}
    }
}

struct PlayerControlPannel_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlPannel()
    }
}
