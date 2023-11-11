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
    var attributedStringFilePath: URL?
    var playButton: CircleButton?
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
        NotificationCenter.default.addObserver(self, selector: #selector(receiveAudioNotification(_:)), name: NSNotification.Name("RecordingDidFinish"), object: nil)
    }
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            updateViewConstraintsForKeyboardHeight(keyboardHeight: keyboardSize.height)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        resetViewConstraintsForKeyboardDismissal()
    }

    func updateViewConstraintsForKeyboardHeight(keyboardHeight: CGFloat) {
        rootView.counterLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardHeight - 10)
        }

        rootView.cameraButton.snp.remakeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardHeight - 10)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func resetViewConstraintsForKeyboardDismissal() {
        rootView.counterLabel.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-40)
        }

        rootView.cameraButton.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupPlayButton() {
        print("setupPlayButton called")
        
        let playButton = CircleButton(type: .play)
        self.playButton = playButton
        playButton.isHidden = true

        view.addSubview(playButton)
        
        playButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.leading.equalTo(rootView.soundButton.snp.trailing).offset(16)
            make.bottom.equalTo(rootView.cameraButton.snp.bottom)
        }
        
        playButton.addTarget(self, action: #selector(playSavedAudio), for: .touchUpInside)
        view.bringSubviewToFront(playButton)
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
                self.playButton?.isHidden = false
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
            playButton?.updateButtonType(to: .play)
        } else {
            do {
                if audioPlayer == nil {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.delegate = self
                    audioPlayer?.prepareToPlay()
                }
                audioPlayer?.play()
                isAudioPlaying = true
                playButton?.updateButtonType(to: .pause)
            } catch {
                print("AVAudioPlayer init or resume failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isAudioPlaying = false
            playButton?.updateButtonType(to: .play)
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
            let attributedText = self.rootView.textView.attributedText ?? NSAttributedString()
            var recording: Recording?

            if let savedAudioURL = self.savedAudioURL, let currentUser = SignInService.shared.signedInUser {
                recording = RecordingService.shared.createRecording(filePath: savedAudioURL.path, duration: TimeInterval(), title: "Recording on \(Date())", user: currentUser)
            }
            EmotionTrashService.shared.createEmotionTrash(user: SignInService.shared.signedInUser ?? User(), text: attributedText.string, attributedText: attributedText, image: nil, recording: recording)
            
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
            insertImageIntoTextView(image: image)
        }
        picker.dismiss(animated: true)
    }
    
    private func insertImageIntoTextView(image: UIImage) {
        let targetSize = CGSize(width: rootView.textView.bounds.width, height: (rootView.textView.bounds.width / image.size.width) * image.size.height)
        let scaledImage = image.scaleToSize(targetSize: targetSize)
        
        // 조절된 이미지 -> NSTextAttachment로 만들기
        let textAttachment = NSTextAttachment()
        textAttachment.image = scaledImage
        
        // NSTextAttachment를 NSAttributedString으로 만들기
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        
        // 현재 UITextView에서 NSAttributedString 가져오기
        let attributedString = NSMutableAttributedString(attributedString: rootView.textView.attributedText)
        
        // NSAttributedString에 폰트 및 색상 설정
        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontGuide.size16,
            .foregroundColor: UIColor.label // Set the text color to the system label color
        ]

        // 이미지 -> NSAttributedString에 추가하기
        attributedString.append(attrStringWithImage)
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))

        // UITextView의 attributedText 업데이트
        rootView.textView.attributedText = attributedString
        
        // 커서를 이미지 다음 줄로 이동 해야함
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveAttributedString(_ attributedString: NSAttributedString) -> URL? {
        let uniqueFileName = UUID().uuidString + ".dat"
        let savePath = getDocumentsDirectory().appendingPathComponent(uniqueFileName)
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: attributedString, requiringSecureCoding: false)
            try data.write(to: savePath)
            return savePath
        } catch {
            print("AttributedString을 저장하는데 실패했습니다: \(error.localizedDescription)")
            return nil
        }
    }
}

extension UIImage {
    func scaleToSize(targetSize: CGSize) -> UIImage {
        if size == targetSize {
            return self
        }
        
        let newSize: CGSize
        let widthRatio = targetSize.width / size.width // widthRatio -> 이미지의 너비를 조정하기 위한 비율
        let heightRatio = targetSize.height / size.height
        
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
}
