//
//  RecordingViewController.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/26.
//

import AVFoundation
import CoreData
import UIKit

protocol RecordingViewControllerDelegate: AnyObject {
    func didSaveRecording(with url: URL)
}

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder?
    var startStopButton: CircleButton!
    var statusLabel: UILabel!
    var timerLabel: UILabel!
    var recordingTimer: Timer?
    var currentRecordingTime: TimeInterval = 0.0
    var saveButton: UIButton!
    var cancelButton: UIButton!
    var completionHandler: ((Bool, URL?) -> Void)?
    weak var delegate: RecordingViewControllerDelegate?
    var currentUser: User?
    var savedAudioURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupUI()
        loadSignedInUser()
    }
 
    func loadSignedInUser() {
        if SignInService.shared.isSignedIn(),
           let userEmail = SignInService.shared.loadSignedInUserEmail()
        {
            currentUser = UserService.shared.getExistUser(userEmail)
        }
    }
    
    func setupUI() {
        startStopButton = CircleButton(type: .play)
        startStopButton.addTarget(self, action: #selector(startOrStopRecording), for: .touchUpInside)
        view.addSubview(startStopButton)

        statusLabel = UILabel()
        statusLabel.text = "녹음 준비"
        statusLabel.textAlignment = .center
        view.addSubview(statusLabel)

        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.centerX.equalTo(view)
            make.height.equalTo(40)
        }

        timerLabel = UILabel()
        timerLabel.text = "00:00"
        timerLabel.textAlignment = .center
        view.addSubview(timerLabel)

        timerLabel.snp.makeConstraints { make in
            make.bottom.equalTo(startStopButton.snp.top).offset(-8)
            make.centerX.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(40)
        }

        startStopButton.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(50)
            make.centerX.equalTo(view)
            make.width.height.equalTo(100)
        }
        
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
        createDirectoryIfNeeded()
        
        let audioFilename = getRecordingURL() // 파일명에 타임스탬프를 포함
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
            DispatchQueue.main.async {
                self.startStopButton.updateButtonType(to: .pause)
                self.statusLabel.text = "녹음 중"
            }
            
            startTimer()
        } catch {
            audioRecorder = nil
            print("Recording Failed")
        }
    }
    
    func createDirectoryIfNeeded() {
        let fileManager = FileManager.default
        // 오디오 파일을 저장할 디렉토리 경로 지정해주는 로직
        let newDirectoryPath = getDocumentsDirectory().appendingPathComponent("AudioRecordings")

        do {
            // 해당 경로에 디렉토리가 존재하는지 확인 -> 없으면 새로 생성
            if !fileManager.fileExists(atPath: newDirectoryPath.path) {
                try fileManager.createDirectory(at: newDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            print("Error creating directory: \(error.localizedDescription)")
        }
    }
    func stopRecording() {
        audioRecorder?.stop()
        savedAudioURL = audioRecorder?.url
        audioRecorder = nil
        DispatchQueue.main.async {
            self.startStopButton.updateButtonType(to: .stop)
            self.statusLabel.text = "녹음 멈춤"
        }
        
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
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: audioURL.path) {
            do {
                try fileManager.removeItem(at: audioURL)
            } catch {
                print("Error deleting recording: \(error.localizedDescription)")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }

    @objc func saveAction() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else {
                print("Error: self가 사용 가능하지 않습니다.")
                return
            }

            guard let audioURL = self.savedAudioURL else {
                print("Error: 오디오 URL을 보낼 수 없습니다.")
                return
            }

            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: audioURL.path) {
                print("Audio file exists at path: \(audioURL.path)")
                // URL을 델리게이트에게 보냄
                self.delegate?.didSaveRecording(with: audioURL)
                
                // 오디오 URL + 알림
                NotificationCenter.default.post(name: .init("RecordingDidFinish"), object: nil, userInfo: ["savedAudioURL": audioURL])
            } else {
                print("Error: 파일이 존재하지 않습니다.")
            }
        }
    }



    func getRecordingURL() -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateString = dateFormatter.string(from: Date())
        // 오디오 파일 이름을 타임스탬프 포함해 생성
        let fileName = "recording_\(dateString).m4a"
        // 오디오 파일을 저장할 디렉토리 경로 가져오는 로직
        let directoryURL = getDocumentsDirectory().appendingPathComponent("AudioRecordings")
        // 최종적인 오디오 파일의 경로 반환
        return directoryURL.appendingPathComponent(fileName)
    }
}

extension RecordingViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }
}
