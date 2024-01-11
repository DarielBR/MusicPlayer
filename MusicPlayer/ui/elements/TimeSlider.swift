//
//  TimeSlider.swift
//  MusicPlayer
//
//  Created by XCode on 23/12/23.
//

import SwiftUI

struct TimeSlider: View {
    @ObservedObject var viewModel: PlayerViewModel
    
    init(viewModel: PlayerViewModel? = nil){
        self.viewModel = viewModel ?? PlayerViewModel()
    }
    
    var body: some View {
        VStack{
            Slider(
                value: $viewModel.playerState.currentTime,
                in: 0.0...viewModel.playerState.currentDuration,
                step: 0.1,
                onEditingChanged: {editing in
                    if editing{
                        viewModel.toogleTimerUpdateStaus()
                        
                    }else{
                        viewModel.resumePlayback(at: viewModel.playerState.currentTime)
                        viewModel.toogleTimerUpdateStaus()
                    }
                }
            )
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 50)
        .frame(
            maxWidth: .infinity,
            alignment: .center
        )
    }
}

struct TimeSlider_Previews: PreviewProvider {
    static var previews: some View {
        TimeSlider()
    }
}
