//
//  File.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/19.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var meterUpdateTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 기타 초기화 코드...
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
            
            meterUpdateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSoundWave), userInfo: nil, repeats: true)
            
        } catch {
            // 녹음 시작 실패 처리...
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        meterUpdateTimer?.invalidate()
        meterUpdateTimer = nil
    }

    @objc func updateSoundWave() {
        audioRecorder.updateMeters()
        let decibel = audioRecorder.averagePower(forChannel: 0)
        
        // decibel 값에 따라 UI를 업데이트하여 사운드 웨이브를 그립니다.
        // 예: soundWaveView.update(with: decibel)
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    // ... 기타 메서드 및 코드 ...
}

