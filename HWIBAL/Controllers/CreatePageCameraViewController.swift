//
//  CreatePageCameraViewController.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/20.
//

import UIKit
import AVFoundation
import EventBus

class CreatePageCameraViewController: UIViewController {
    
    private var cameraView: CreatePageCameraView!
    private var captureSession: AVCaptureSession?
    private var stillImageOutput: AVCapturePhotoOutput?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initializeCamera()
    }
    
    private func setupUI() {
        cameraView = CreatePageCameraView(frame: view.bounds)
        view.addSubview(cameraView)
        
        cameraView.captureButton.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
    }
    
    private func initializeCamera() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession?.canAddInput(input) == true && captureSession?.canAddOutput(stillImageOutput!) == true {
                captureSession?.addInput(input)
                captureSession?.addOutput(stillImageOutput!)
                setupLivePreview()
            }
        }
        catch let error  {
        }
    }
    
    private func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspect
        videoPreviewLayer?.connection?.videoOrientation = .portrait
        cameraView.layer.addSublayer(videoPreviewLayer!)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
            DispatchQueue.main.async {
                self?.videoPreviewLayer?.frame = self?.cameraView.bounds ?? CGRect.zero
            }
        }
    }
    
    @objc func captureImage() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession?.stopRunning()
    }
}

extension CreatePageCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        let image = UIImage(data: imageData)
    }
}
