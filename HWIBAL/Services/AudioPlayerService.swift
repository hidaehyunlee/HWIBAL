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
        guard let audioURL = URL(string: filePath) else {
            print("Error: URL로 변환 실패")
            return
        }

        do {
            audioPlayer?.stop() // Stop any currently playing audio before starting a new one
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.prepareToPlay()
            // audioPlayer?.delegate = self // Add this line to set the delegate
            audioPlayer?.play()
        } catch {
            print("플레이어 생성 Error: \(error)")
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
