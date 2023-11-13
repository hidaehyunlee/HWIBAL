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
    var startStopButton: UIButton!
    var timerLabel: UILabel!
    var recordingTimer: Timer?
    var currentRecordingTime: TimeInterval = 0.0
    var saveButton: UIButton!
    var cancelButton: UIButton!
    var completionHandler: ((Bool, URL?) -> Void)?
    weak var delegate: RecordingViewControllerDelegate?
    var currentUser: User?
    var savedAudioURL: URL?
    var existingAudioTimestamp: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        requestAudioPermission()
        setupUI()
        loadSignedInUser()
        if let timestamp = existingAudioTimestamp {
            // CreatePageViewController에서 전달받은 timestamp -> 기존 녹음 삭제
            deleteRecordingWithTimestamp(timestamp)
        }
    }
    
    func requestAudioPermission() {
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
            if granted {
                print("Audio: 권한 허용")
            } else {
                print("Audio: 권한 거부")
            }
        })
    }
    
    func loadSignedInUser() {
        if SignInService.shared.isSignedIn(),
           let userEmail = SignInService.shared.loadSignedInUserEmail()
        {
            currentUser = UserService.shared.getExistUser(userEmail)
        }
    }
    
    func setupUI() {
        startStopButton = UIButton()
        startStopButton.addTarget(self, action: #selector(startOrStopRecording), for: .touchUpInside)
        startStopButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
        view.addSubview(startStopButton)

        timerLabel = UILabel()
        timerLabel.text = "00:00"
        timerLabel.font = FontGuide.size21
        timerLabel.textColor = .label
        timerLabel.textAlignment = .center
        view.addSubview(timerLabel)
        
        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.centerX.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(40)
        }
        
        startStopButton.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(43 * UIScreen.main.bounds.height / 852)
            make.centerX.equalTo(view)
            make.width.height.equalTo(55)
        }

        cancelButton = UIButton(type: .system)
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.titleLabel?.font = FontGuide.size16Bold
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelButton.tintColor = ColorGuide.main
        view.addSubview(cancelButton)

        saveButton = UIButton(type: .system)
        saveButton.setTitle("저장", for: .normal)
        saveButton.titleLabel?.font = FontGuide.size16Bold
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        saveButton.tintColor = ColorGuide.main
        view.addSubview(saveButton)

        cancelButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(5)
            make.top.equalTo(5)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }

        saveButton.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).offset(-5)
            make.top.equalTo(5)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
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
                self.startStopButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
                // self.statusLabel.text = "녹음 중"
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
            self.startStopButton.setBackgroundImage(UIImage(named: "stop"), for: .normal)
            // self.statusLabel.text = "녹음 멈춤"
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
        
    func deleteRecordingWithTimestamp(_ timestamp: String) {
        let fileManager = FileManager.default
        let directoryURL = getDocumentsDirectory().appendingPathComponent("AudioRecordings")
        let recordingName = "recording_\(timestamp).m4a"
        let fileURL = directoryURL.appendingPathComponent(recordingName)
            
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
                print("Recording with timestamp \(timestamp) deleted success.")
            } catch {
                print("파일삭제 시도할때 에러발생: \(error.localizedDescription)")
            }
        } else {
            print("No recording found with timestamp.")
        }
    }
}
    
extension RecordingViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }
}
