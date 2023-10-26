//
//  RecordingViewController.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/26.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder?
    var startStopButton: UIButton!
    var statusLabel: UILabel!
    var timerLabel: UILabel!
    var waveformView: UIView!
    var recordingTimer: Timer?
    var currentRecordingTime: TimeInterval = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupUI()
    }
//        let recordingViewController = RecordingViewController()
//        recordingViewController.modalPresentationStyle = .custom
//        recordingViewController.transitioningDelegate = recordingViewController
//        self.present(recordingViewController, animated: true, completion: nil)
        //모달 크기 절반(아이폰음성메모처럼..)
 
    
    
    func setupUI() {
        startStopButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        startStopButton.center = view.center
        startStopButton.backgroundColor = .systemGray
        startStopButton.layer.cornerRadius = 50
        startStopButton.setTitle("⚫️", for: .normal)
        startStopButton.addTarget(self, action: #selector(startOrStopRecording), for: .touchUpInside)
        
        view.addSubview(startStopButton)
        
        statusLabel = UILabel(frame: CGRect(x: 0, y: startStopButton.frame.origin.y - 50, width: view.frame.width, height: 40))
        statusLabel.text = "녹음 준비"
        statusLabel.textAlignment = .center
        view.addSubview(statusLabel)
        
        timerLabel = UILabel(frame: CGRect(x: 0, y: 10, width: view.frame.width, height: 40))
        timerLabel.text = "00:00"
        timerLabel.textAlignment = .center
        view.addSubview(timerLabel)
        
        waveformView = UIView(frame: CGRect(x: 10, y: timerLabel.frame.origin.y + timerLabel.frame.height + 10, width: view.frame.width - 20, height: 100))
        waveformView.backgroundColor = .lightGray
        view.addSubview(waveformView)
    }
    
    @objc func startOrStopRecording() {
        if audioRecorder == nil {
            startRecording()
        } else {
            stopRecording()
        }
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
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            startStopButton.setTitle("■", for: .normal)
            statusLabel.text = "녹음 중"
            
            startTimer()
        } catch {
            audioRecorder = nil
            print("Recording Failed")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        startStopButton.setTitle("⚫️", for: .normal)
        statusLabel.text = "녹음 멈춤"
        
        stopTimer()
    }
    
    func startTimer() {
        currentRecordingTime = 0.0
        timerLabel.text = timeString(time: currentRecordingTime)
        recordingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        currentRecordingTime += 1
        timerLabel.text = timeString(time: currentRecordingTime)
    }
    
    func stopTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
extension RecordingViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}



