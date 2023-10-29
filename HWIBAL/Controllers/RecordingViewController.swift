//
//  RecordingViewController.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/26.
//

import AVFoundation
import UIKit

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder?
    var startStopButton: UIButton!
    var statusLabel: UILabel!
    var timerLabel: UILabel!
    var waveformView: UIView!
    var recordingTimer: Timer?
    var currentRecordingTime: TimeInterval = 0.0
    var saveButton: UIButton!
    var cancelButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupUI()
    }
 
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
        
        timerLabel = UILabel(frame: CGRect(x: 0, y: 10 + 90, width: view.frame.width, height: 40))
        timerLabel.text = "00:00"
        timerLabel.textAlignment = .center
        view.addSubview(timerLabel)

        waveformView = UIView(frame: CGRect(x: 10, y: timerLabel.frame.origin.y + 70, width: view.frame.width - 20, height: 100))
        waveformView.backgroundColor = .lightGray
        view.addSubview(waveformView)

        
        cancelButton = UIButton(frame: CGRect(x: 10, y: 10, width: 80, height: 40))
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.blue, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        view.addSubview(cancelButton)

        saveButton = UIButton(frame: CGRect(x: view.frame.width - 90, y: 10, width: 80, height: 40))
        saveButton.setTitle("저장", for: .normal)
        saveButton.setTitleColor(.blue, for: .normal)
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        view.addSubview(saveButton)
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
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func cancelAction() {
        let audioURL = getRecordingURL()
        // 파일이 존재하는지 확인 후 삭제
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: audioURL.path) {
            do {
                try fileManager.removeItem(at: audioURL)
            } catch {
                print("Error deleting recording: \(error.localizedDescription)")
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    @objc func saveAction() {
        let savedAudioURL = getRecordingURL()
        print("Saved recording at: \(savedAudioURL.absoluteString)")
        
        self.dismiss(animated: true, completion: nil)
    }

    func getRecordingURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("recording.m4a")
    }
}

extension RecordingViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }
}

