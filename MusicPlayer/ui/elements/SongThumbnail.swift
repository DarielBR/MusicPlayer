//
//  SongThumbnails.swift
//  MusicPlayer
//
//  Created by XCode on 22/12/23.
//

import SwiftUI

struct TrackThumbnail: View {
    var albumImage: UIImage?
    var size: CGFloat
    
    init(albumImage: UIImage? = nil, size: CGFloat = .infinity) {
        self.albumImage = albumImage
        self.size = size
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                if let image = albumImage.map(Image.init(uiImage:)) {
                    image
                        .resizable()
                        .scaledToFit()
                        //.padding(5)
                        //.frame(
                        //    width: size - 5,//geometry.size.width - 5,
                        //    height: size - 5//geometry.size.height - 5
                        //)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                } else {
                    ZStack{
                        Image(systemName: "music.quarternote.3")
                            .resizable()
                            .scaledToFit()
                            .padding(5)
                            //.frame(
                            //    width: size - 15, //geometry.size.width - 15,
                            //    height: size - 15//geometry.size.height - 15
                            //)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .foregroundColor(.gray)
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.secondary.opacity(0.2))
                    }
                }
            }
        }
        .shadow(radius: 2,x: 2, y: 2)
        .padding(5)
        .aspectRatio(1, contentMode: .fit)
        .frame(
            maxWidth: size
        )
    }
}

struct SongThumbnails_Previews: PreviewProvider {
    static var previews: some View {
        
            TrackThumbnail()
        
    }
}
