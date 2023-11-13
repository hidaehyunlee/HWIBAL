//
//  AudioPlayerService.swift
//  HWIBAL
//
//  Created by daelee on 11/10/23.
//

import AVFoundation

class AudioPlayerService {
    var audioPlayer: AVAudioPlayer?

    init(filePath: String) {
        let audioURL = URL(fileURLWithPath: filePath)

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("AVAudioSession configuration error: \(error)")
        }
    }

    func playAudio() {
        // Check if the audioPlayer is not nil
        guard let player = audioPlayer else {
            print("Audio player is not initialized")
            return
        }

        // Check if the player is currently playing
        if player.isPlaying {
            player.pause()
        } else {
            // If not playing, start playing the audio
            player.play()
        }
    }

    func stopAudio() {
        audioPlayer?.stop()
    }

    deinit {
        stopAudio()
    }
}
