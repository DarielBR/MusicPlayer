//
//  PlayerViewModel.swift
//  MusicPlayer
//
//  Created by XCode on 21/12/23.
//

import Foundation
import AVFoundation

class PlayerViewModel: ObservableObject {
    //Repositories
    private let audioRepository: AudioRepository
    private let fileRepository: FileRepository
    private let watchConnection: WatchConnection
    //App State
    @Published var playerState = PlayerState()
    //Timer: needed for track time slider
    var timer: Timer?
    
    init(
        audioPlayer: AudioRepository = AudioRepository.sharedInstance,
        watchConnection: WatchConnection = WatchConnection.sharedInstance
    ) {
        
        self.audioRepository = audioPlayer
        self.fileRepository = FileRepository()
        self.watchConnection = watchConnection
        self.watchConnection.connect()
        self.watchConnection.onMessageReceived = {[weak self] message in
            self?.handleReceiveMessage(message)
        }
        
        self.loadAudioFiles()
        self.loadPlaylists()
        self.purgePlaylists()
        self.setNoPlaylist()
        self.sendMessage()
    }
    // creates an AudioFile instance given a valid path, a (app internal) track number
    private func createAudioFile(from path: String, with track: Int) -> AudioFile? {
        if let metadata = fileRepository.extractID3TagData(path) {
            let audioFile = AudioFile(
                track: track,
                path: path,
                name: metadata.name,
                author: metadata.author,
                album: metadata.album,
                albumImage: metadata.albumImage
            )
            return audioFile
        }else{ return nil }
    }
    
    // MARK: - State functionality
    // Loads into app state al AudioFiles intances available in the documents file
    func loadAudioFiles() {
        guard let paths = fileRepository.findAllAudioFilePaths(), !paths.isEmpty else {
            return
        }
        
        var i = 1
        for path in paths {
            if let audioFile = createAudioFile(from: path, with: i) {
                self.playerState.files.append(audioFile)
                i += 1
            }
        }
        
        //self.setCurrentTrack(1)
        //self.prepareAudio()
    }
    //Sets into the state the index of the current track in the current playlist. Also updates the state of the current Audio File.
    func setCurrentTrackIndex(_ newValue: Int) {
        playerState.currentTrack = newValue
        self.setCurrentAudioFile()
        self.prepareAudio()
    }
    //Sets into the state the index of the current track in the current playlist. also updates the state of current Audio File
    func setCurrentTrackIndex(_ audioFile: AudioFile){
        guard let currentTrackIndex = playerState.currentPlaylist.firstIndex(where: { $0 == audioFile.track }) else { return }
        playerState.currentTrack = currentTrackIndex
        self.setCurrentAudioFile()
        self.prepareAudio()
    }
    //Moves the current track to next index into the current playlist.
    func nextTrack(){
        let nextTrack = playerState.currentTrack + 1
        if nextTrack >= playerState.currentPlaylist.count { self.setCurrentTrackIndex(0) }
        else { self.setCurrentTrackIndex(nextTrack) }
    }
    //Moves the current track to the previous index into the current playlist
    func prevTrack(){
        let prevTrack = playerState.currentTrack - 1
        if prevTrack < 0 { self.setCurrentTrackIndex(playerState.currentPlaylist.count - 1) }
        else { self.setCurrentTrackIndex(prevTrack) }
    }
    //deprecated
    func retrieveCurrentTrack() -> String? {
        guard let index = playerState.files.firstIndex(where: { $0.track == playerState.currentTrack }) else {
            return nil
        }
        
        return playerState.files[index].path
    }
    //Sets into the satate the playback state
    func setPlayingState(newValue: Bool){
        playerState.isPlaying = newValue
    }
    //Toogles the coutinouse playback state
    func toogleContinousPlayState(){
        playerState.isContinousPlay.toggle()
    }
    //Set into the app state the current audio file attending to the current track index
    func setCurrentAudioFile(){
        let currentTrakIndex = playerState.currentTrack
        guard let audioFile = playerState.files.first(where: { $0.track == playerState.currentPlaylist[currentTrakIndex] }) else {
            playerState.currentAudioFile = AudioFile()
            return
        }
        playerState.currentAudioFile = audioFile
    }
    //deprecated
    func getCurrentAudioFile() -> AudioFile? {
        let audioFile = playerState.files.first(where: { $0.track == playerState.currentTrack })
        return audioFile
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.1,
            repeats: true
        ){_ in
            if self.playerState.timerUpdateStaus {
                self.saveCurrentTime(time: self.audioRepository.getCurrentTime() ?? 0)
                if (Double(self.playerState.currentTime) >= Double(self.playerState.currentDuration) - 0.5){
                    self.audioPlayerDidFinishPlaying()
                }
            }
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    func toogleTimerUpdateStaus(){
        playerState.timerUpdateStaus.toggle()
    }
    
    func clearNewPlayListName(){
        playerState.newPlayListName = ""
    }
    
    func setCurrentPlaylist(newValue: [Int]){
        playerState.currentPlaylist = newValue
        self.setCurrentTrackIndex(0)
    }
    //Setup the current playlist to all songs. Calls to prepareAudio
    func setNoPlaylist(){
        var allSongs: [Int] = []
        for song in playerState.files{
            allSongs.append(song.track)
        }
        self.setCurrentPlaylist(newValue: allSongs)
        self.prepareAudio()
    }
    //Retrieves am AudioFile() given a track number
    func getAudioFile(by track: Int) -> AudioFile?{
        guard let audioFile = playerState.files.first(where: { $0.track == track }) else { return nil }
        return audioFile
    }
    // MARK: - Playback functionality
    //Setups the audio file to be played
    func prepareAudio() {
        let currentDuration = audioRepository.prepareAudioFile(playerState.currentAudioFile.path)
        self.saveCurrentTime(time: 0)
        self.setCurrentDuration(time: currentDuration ?? 0)
        self.startTimer()
    }
    
    func pausePlayback() {
        self.saveCurrentTime(time: audioRepository.pausePlayback() ?? 0)
        self.stopTimer()
        self.setPlayingState(newValue: false)
        self.sendMessage()
    }
    
    func setCurrentDuration(time: TimeInterval){
        playerState.currentDuration = time
    }
    
    func saveCurrentTime(time: TimeInterval) {
        playerState.currentTime = time
    }
    
    func resumePlayback(at time: TimeInterval) {
        audioRepository.resumePlayback(at: time)
        self.setPlayingState(newValue: true)
        self.sendMessage()
    }
    
    func audioPlayerDidFinishPlaying(){
        self.stopTimer()
        self.setPlayingState(newValue: false)
        self.nextTrack()
        //self.prepareAudio()
        //self.setCurrentAudioFile()
        if self.playerState.isContinousPlay {
            resumePlayback(at: playerState.currentTime)//should be 0
            setPlayingState(newValue: true)
        }
    }
    
    // MARK: - Play list functionality
    func createPlaylist(name: String){
        var playListId = 0
        if playerState.playLits.isEmpty{ playListId = 1 }
        else {
            let orderedPlaylist = playerState.playLits.sorted(by: { $0.playListId < $1.playListId } )
            playListId = (orderedPlaylist.last?.playListId ?? 0) + 1
        }
        let playList = PlayList(
            playListId: playListId,
            name: name
        )
        playerState.playLits.append(playList)
    }
    
    func createPlaylist(name: String, track: Int){
        var playListId = 0
        if playerState.playLits.isEmpty{ playListId = 1 }
        else {
            let orderedPlaysist = playerState.playLits.sorted(by: { $0.playListId < $1.playListId } )
            playListId = (orderedPlaysist.last?.playListId ?? 0) + 1
        }
        var playList = PlayList(
            playListId: playListId,
            name: name
        )
        playList.tracks.append(track)
        playerState.playLits.append(playList)
    }
    
    func addTrackToPlayList(playListId: Int, track: Int){
        guard let index = playerState.playLits.firstIndex(where: {$0.playListId == playListId}) else { return }
        playerState.playLits[index].tracks.append(track)
    }
    
    func deleteTrackFromPlayList(playListId: Int, track: Int){
        guard let index = playerState.playLits.firstIndex(where: { $0.playListId == playListId }) else { return }
        guard let trackIndex = playerState.playLits[index].tracks.firstIndex(where: { $0 == track }) else { return }
        playerState.playLits[index].tracks.remove(at: trackIndex)
    }
    
    func deletePlayList(playListId: Int){
        guard let index = playerState.playLits.firstIndex(where: { $0.playListId == playListId }) else { return }
        playerState.playLits.remove(at: index)
        self.setNoPlaylist()
    }
    
    func purgePlaylists(){
        for playlistIndex in playerState.playLits.indices {
            var updatedPlaylist = playerState.playLits[playlistIndex]
            updatedPlaylist.tracks = updatedPlaylist.tracks.filter { trackIndex in
                let trackExists = playerState.files.contains { audioFile in
                    audioFile.track == trackIndex
                }
                return trackExists
            }
            if updatedPlaylist.tracks.isEmpty {
                playerState.playLits.remove(at: playlistIndex)
            } else {
                playerState.playLits[playlistIndex] = updatedPlaylist
            }
        }
    }
    
    func savePlayLists() {
        do {
            let data = try JSONEncoder().encode(playerState.playLits)
            UserDefaults.standard.set(data, forKey: "playlists")
        } catch {
            print("Error encoding playlists: \(error.localizedDescription)")
        }
    }
    
    private func loadPlaylists() {
        if let data = UserDefaults.standard.data(forKey: "playlists") {
            do {
                playerState.playLits = try JSONDecoder().decode([PlayList].self, from: data)
            } catch {
                print("Error decoding playlists: \(error.localizedDescription)")
            }
        }else{
            return
        }
    }
// MARK: - WatchConnection Functionality
    func sendMessage() -> Void {
        let title = playerState.currentAudioFile.name
        let author = playerState.currentAudioFile.author
        let isPlaying = playerState.isPlaying
        let message = [
            "title":title,
            "author":author,
            "is_playing":isPlaying
        ] as [String : Any]
        self.watchConnection.send(message: message)
    }
    
    private func handleReceiveMessage(_ message: [String : Any]){
        if let command = message["command"] as? String{
            switch(command){
            case "play":
                self.resumePlayback(at: self.playerState.currentTime)
                self.sendMessage()
                return
            case "pause":
                self.pausePlayback()
                self.sendMessage()
                return
            case "next":
                self.nextTrack()
                self.sendMessage()
                return
            case "prev":
                self.prepareAudio()
                self.sendMessage()
                return
            default:
                return
            }
        }
    }
}
