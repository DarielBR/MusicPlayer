//
//  PlayListTag.swift
//  MusicPlayer
//
//  Created by XCode on 26/12/23.
//

import SwiftUI

struct PlayListTag: View {
    var playlist: PlayList
    var onClick: (PlayList) -> Void
    
    init(
        playlist: PlayList? = nil,
        onClick: @escaping (PlayList) -> Void
    ) {
        self.playlist = playlist ?? PlayList()
        self.onClick = onClick
    }

    var body: some View {
        Button(
            action: { onClick(self.playlist) }
        ){
            GeometryReader { geometry in
                ZStack{
                    VStack{
                        Image(systemName: "music.note.list")
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .foregroundColor(.gray)
                        Spacer()
                        VStack{
                            Text(playlist.name)
                                .font(.title3)
                                .shadow(radius: 2, x: 2, y: 2)
                            Spacer()
                            Text("tracks: \(playlist.tracks.count)")
                        }
                        .padding()
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                    }
                    RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.secondary.opacity(0.2))
                }
            }
            .shadow(radius: 2,x: 2, y: 2)
            .padding(5)
            .aspectRatio(1, contentMode: .fit)
            .frame(
                maxWidth: 200
            )
        }
    }
}

struct PlayListTag_Previews: PreviewProvider {
    static var previews: some View {
        PlayListTag(){_ in}
    }
}
