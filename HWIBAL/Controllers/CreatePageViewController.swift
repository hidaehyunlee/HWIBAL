//
//  CreatePageView.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/12.

import AVFoundation
import EventBus
import UIKit
import PhotosUI

class CreatePageViewController: RootViewController<CreatePageView>, AVAudioRecorderDelegate {
    var keyboardHeight: CGFloat = 0
    var audioRecorder: AVAudioRecorder?
    private var attachedImageView: UIImageView?
    var signedInUser = SignInService.shared.signedInUser!
    private var dimmedBackgroundView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        view.backgroundColor = .systemBackground
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] allowed in
            DispatchQueue.main.async {
                if !allowed {
                    let alert = UIAlertController(title: "Permission Denied", message: "Please allow access to microphone for recording.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
        rootView.soundButton.addTarget(self, action: #selector(startOrStopRecording), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(stopRecording))
        rootView.soundWaveView.addGestureRecognizer(tap)
        rootView.soundWaveView.isUserInteractionEnabled = true
        
        rootView.cameraButton.addTarget(self, action: #selector(presentImagePickerOptions), for: .touchUpInside)
    }
    
    @objc func startOrStopRecording() {
        if audioRecorder == nil {
            let session = AVAudioSession.sharedInstance()
            switch session.recordPermission {
            case .undetermined:
                session.requestRecordPermission { [weak self] allowed in
                    DispatchQueue.main.async {
                        if allowed {
                            self?.startRecording()
                        } else {
                            let alert = UIAlertController(title: "Permission Denied", message: "Please allow access to microphone for recording.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self?.present(alert, animated: true)
                        }
                    }
                }
            case .denied:
                let alert = UIAlertController(title: "Permission Denied", message: "Please allow access to microphone for recording in settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            case .granted:
                startRecording()
            @unknown default:
                break
            }
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
            
            rootView.soundButton.setTitle("Stop", for: .normal)
        } catch {
            audioRecorder = nil
            let alert = UIAlertController(title: "Recording Failed", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @objc func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        rootView.soundButton.setTitle("Record", for: .normal)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func presentImagePickerOptions() {
        let actionSheet = UIAlertController(title: nil, message: "Choose Image Source", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.presentImagePicker(sourceType: .camera)
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        {
            keyboardHeight = keyboardFrame.height
            adjustLayoutForKeyboardState()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardHeight = 0
        adjustLayoutForKeyboardState()
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
        
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94)
        
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
        let alertController = UIAlertController(title: "아, 휘발 🔥", message: "정말로 삭제 하시겠습니까?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func showWriteAlert() {
        let alertController = UIAlertController(title: "아, 휘발 🔥", message: "오... 그랬군요 🥹 \n당신의 감정을 3일 후에 불태워 드릴게요 🔥", preferredStyle: .alert)
        
        present(alertController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alertController.dismiss(animated: true) { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
        let text = rootView.textView.text ?? ""
        EmotionTrashService.shared.createEmotionTrash(signedInUser, text)
        EmotionTrashService.shared.printTotalEmotionTrashes(signedInUser)
        NotificationCenter.default.post(name: NSNotification.Name("EmotionTrashUpdate"), object: nil)   
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        rootView.frame = view.bounds
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
       
         attachedImageView?.removeFromSuperview()

         let imageView = UIImageView(image: image)
         imageView.contentMode = .scaleAspectFit

         let imageViewWidth = rootView.textView.bounds.width
         let imageViewHeight = rootView.textView.bounds.height / 2

         let spaceBetweenTextViewAndCounterLabel: CGFloat = 10
         let imageViewY = rootView.textView.frame.origin.y + rootView.textView.frame.height - imageViewHeight

         imageView.frame = CGRect(x: rootView.textView.frame.origin.x, y: imageViewY, width: imageViewWidth, height: imageViewHeight)

         rootView.addSubview(imageView)

         let textViewNewHeight = rootView.textView.frame.height / 2
         rootView.textView.frame = CGRect(x: rootView.textView.frame.origin.x, y: rootView.textView.frame.origin.y, width: rootView.textView.frame.width, height: textViewNewHeight)

         attachedImageView = imageView
    }
}
