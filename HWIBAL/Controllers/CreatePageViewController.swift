//
//  CreatePageView.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/12.

import AVFoundation
import EventBus
import SnapKit
import UIKit

class CreatePageViewController: RootViewController<CreatePageView>, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var keyboardHeight: CGFloat = 0
    private var attachedImageView: UIImageView?
    var playButton: UIButton?
    var savedAudioURL: URL?
    private var audioPlayer: AVAudioPlayer?
    private var isAudioPlaying = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        view.backgroundColor = .systemBackground
    
        rootView.soundButton.addTarget(self, action: #selector(startOrStopRecording), for: .touchUpInside)
        rootView.cameraButton.addTarget(self, action: #selector(presentImagePickerOptions), for: .touchUpInside)
        
        setupPlayButton()
        hideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        adjustCounterLabelWithKeyboard(notification: notification, isShowing: true)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        adjustCounterLabelWithKeyboard(notification: notification, isShowing: false)
    }
    
    func adjustCounterLabelWithKeyboard(notification: NSNotification, isShowing: Bool) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardHeight = isShowing ? keyboardFrame.cgRectValue.height : 0

        rootView.counterLabel.snp.remakeConstraints { make in
            if isShowing {
                make.bottom.equalTo(self.view.snp.bottom).offset(-keyboardHeight - 10)
            } else {
                make.trailing.equalToSuperview().offset(-24)
                make.bottom.equalToSuperview().offset(-40)
            }
            make.centerX.equalTo(rootView.snp.centerX)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.rootView.layoutIfNeeded()
        }
    }


    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupPlayButton() {
        print("setupPlayButton called")
        
        let PlayButton = rootView.playButton
        PlayButton.setImage(UIImage(named: "play"), for: .normal)
        PlayButton.addTarget(self, action: #selector(playSavedAudio), for: .touchUpInside)
        PlayButton.backgroundColor = .red

        playButton = PlayButton
        view.bringSubviewToFront(playButton!)
    }
    
    @objc func startOrStopRecording() {
        // 이미 저장된 오디오 URL이 있는지 확인
        if let savedAudioURL = savedAudioURL {
            let recordingVC = RecordingViewController()
            // Timestamp 추출
            let timestamp = savedAudioURL.lastPathComponent.replacingOccurrences(of: "recording_", with: "").replacingOccurrences(of: ".m4a", with: "")
            // 기존 녹음 삭제를 위한 timestamp 전달
            recordingVC.existingAudioTimestamp = timestamp
            presentRecordingVC(recordingVC)
        } else {
            // 기존 녹음이 없으므로 바로 RecordingViewController 표시
            presentRecordingVC(RecordingViewController())
        }
    }

    func presentRecordingVC(_ recordingVC: RecordingViewController) {
        recordingVC.modalPresentationStyle = .custom
        recordingVC.transitioningDelegate = recordingVC
        present(recordingVC, animated: true, completion: nil)
    }


    @objc func receiveAudioNotification(_ notification: Notification) {
        if let url = notification.userInfo?["savedAudioURL"] as? URL {
            savedAudioURL = url
            DispatchQueue.main.async {
                self.playButton?.backgroundColor = .green
            }
        } else {
            print("Audio URL is nil")
        }
    }
    
    @objc func playSavedAudio() {
        guard let url = savedAudioURL else {
            print("Audio URL is nil")
            return
        }
        
        if let player = audioPlayer, player.isPlaying {
            player.pause()
            isAudioPlaying = false
            playButton?.setImage(UIImage(named: "play"), for: .normal)
        } else {
            do {
                if audioPlayer == nil {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.delegate = self
                    audioPlayer?.prepareToPlay()
                }
                audioPlayer?.play()
                isAudioPlaying = true
                playButton?.setImage(UIImage(named: "pause"), for: .normal)
            } catch {
                print("AVAudioPlayer init or resume failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isAudioPlaying = false
            playButton?.setImage(UIImage(named: "play"), for: .normal)
        }
    }

    @objc func presentImagePickerOptions() {
        let actionSheet = UIAlertController(title: nil, message: "이미지 선택", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in
            self.presentImagePicker(sourceType: .camera)
        }
        
        let galleryAction = UIAlertAction(title: "앨범", style: .default) { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func adjustLayoutForKeyboardState() {
        if keyboardHeight > 0 {
            let padding: CGFloat = 10
            rootView.counterLabel.frame.origin.y = view.bounds.height - keyboardHeight - rootView.counterLabel.frame.height - padding
            rootView.cameraButton.frame.origin.y = rootView.counterLabel.frame.minY - rootView.cameraButton.frame.height - padding
            rootView.soundButton.frame.origin.y = rootView.cameraButton.frame.origin.y
        } else {
            rootView.layoutSubviews()
        }
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let leftItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(showCancelAlert))
        leftItem.tintColor = ColorGuide.main
        navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(title: "작성", style: .plain, target: self, action: #selector(showWriteAlert))
        rightItem.tintColor = ColorGuide.main
        navigationItem.rightBarButtonItem = rightItem
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineHeightMultiple = 41.0 / 34.0
        paragraphStyle.firstLineHeadIndent = 14.0
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .kern: 0.374,
            .paragraphStyle: paragraphStyle
        ]
        
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .black
        titleLabel.font = FontGuide.size32Bold
        titleLabel.sizeToFit()
        
        let leftPadding: CGFloat = 16
        let rightPadding: CGFloat = 16
        let bottomPadding: CGFloat = 15
        
        let titleViewHeight = navigationController?.navigationBar.bounds.height ?? 44.0
        let titleViewWidth = navigationController?.navigationBar.bounds.width ?? UIScreen.main.bounds.width
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleViewWidth, height: titleViewHeight))
        titleLabel.frame.origin = CGPoint(x: leftPadding, y: titleViewHeight - titleLabel.frame.height - bottomPadding)
        titleView.addSubview(titleLabel)
        
        navigationItem.title = "감정쓰레기"
        
        navigationController?.navigationBar.largeTitleTextAttributes = titleAttributes
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
    }
    
    @objc func showCancelAlert() {
        if rootView.textView.text.isEmpty {
            dismiss(animated: true, completion: nil)
        } else {
            let confirmAction: ((UIAlertAction) -> Void) = { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }

            AlertManager.shared.confirmAlert(on: self, title: "", message: "작성 중인 감정쓰레기를 취소하시겠습니까?", confirmAction: confirmAction)
        }
    }

    @objc func showWriteAlert() {
        AlertManager.shared.showMessageAlert(on: self, title: "", message: "오, 저런!\n휘발 주기에 맞춰 불 태워 드릴게요 🔥") {
            let text = self.rootView.textView.text ?? ""
            var recording: Recording?

            if let savedAudioURL = self.savedAudioURL, let currentUser = SignInService.shared.signedInUser {
                recording = RecordingService.shared.createRecording(filePath: savedAudioURL.path, duration: TimeInterval(), title: "Recording on \(Date())", user: currentUser)
            }

            if let recording = recording {
                if let imageView = self.attachedImageView, let attachedImage = imageView.image {
                    print("attachedImageView 첨부 with recording")
                    EmotionTrashService.shared.createEmotionTrash(user: SignInService.shared.signedInUser ?? User(), text: text, image: attachedImage, recording: recording)
                } else {
                    print("attachedImageView nil with recording")
                    EmotionTrashService.shared.createEmotionTrash(user: SignInService.shared.signedInUser ?? User(), text: text, image: nil, recording: recording)
                }
            } else {
                if let imageView = self.attachedImageView, let attachedImage = imageView.image {
                    print("attachedImageView 첨부 without recording")
                    EmotionTrashService.shared.createEmotionTrash(user: SignInService.shared.signedInUser ?? User(), text: text, image: attachedImage, recording: nil)
                } else {
                    print("attachedImageView nil without recording")
                    EmotionTrashService.shared.createEmotionTrash(user: SignInService.shared.signedInUser ?? User(), text: text, image: nil, recording: nil)
                }
            }
            EmotionTrashService.shared.printTotalEmotionTrashes(SignInService.shared.signedInUser!)
            NotificationCenter.default.post(name: NSNotification.Name("EmotionTrashUpdate"), object: nil)

            self.dismiss(animated: true, completion: nil)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        rootView.frame = view.bounds
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .init("RecordingDidFinish"), object: nil)
    }
}

extension CreatePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            addAndLayoutAttachedImageView(with: image)
        }
        picker.dismiss(animated: true)
    }
    
    private func addAndLayoutAttachedImageView(with image: UIImage) {
        if let existingImageView = attachedImageView {
            existingImageView.image = image
            return
        }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12.0
        rootView.addSubview(imageView)
        attachedImageView = imageView
        
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(rootView.textView.snp.leading)
            make.trailing.equalTo(rootView.textView.snp.trailing)
            make.top.equalTo(rootView.textView.snp.top).offset((rootView.textView.frame.height / 2) + 10)
            make.bottom.equalTo(rootView.cameraButton.snp.top).offset(-10)
        }
        rootView.isImageViewAttached = true
    }
}
