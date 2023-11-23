//
//  ViewController.swift
//  SimpleCamera
//
//  Created by Owner on 2023/11/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var previewLayerBackgroundView: UIView!
    
    var captureSession: AVCaptureSession? = nil
    var videoDevice: AVCaptureDevice?
    var previewLayer: AVCaptureVideoPreviewLayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        setupCaptureSession(withPosition: .back)
        setupPreviewLayer()
    }
    
    @IBAction func cameraButtonTapped() {
        //Take photo
    }
    
    @IBAction func reverseCamera() {
        reverseCameraPosition()
    }
    
    func setupCaptureSession(withPosition cameraPosition: AVCaptureDevice.Position) {
        videoDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: cameraPosition)
        captureSession = AVCaptureSession()
        let videoInput = try! AVCaptureDeviceInput(device: videoDevice!)
        captureSession?.addInput(videoInput)
        let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
        let audioInput = try! AVCaptureDeviceInput(device: audioDevice!)
        captureSession?.addInput(audioInput)
        let captureOutput: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
        captureSession?.addOutput(captureOutput)
        self.captureSession?.startRunning()
    }
    
    func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.frame = CGRect(x: 0, y: 0, width: previewLayerBackgroundView.frame.width, height: previewLayerBackgroundView.frame.height)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayerBackgroundView.layer.addSublayer(previewLayer!)
    }

        func reverseCameraPosition() {
            captureSession?.stopRunning()
            captureSession?.inputs.forEach { input in
                captureSession?.removeInput(input)
            }
            captureSession?.outputs.forEach { output in
                captureSession?.removeOutput(output)
            }
            
            let newCameraPosition: AVCaptureDevice.Position = videoDevice?.position == .front ? .back : .front
            setupCaptureSession(withPosition: newCameraPosition)
            let newVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
            newVideoLayer.frame = CGRect(x: 0, y: 0, width: previewLayerBackgroundView.frame.width, height: previewLayerBackgroundView.frame.height)
            newVideoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            UIView.transition(with: previewLayerBackgroundView, duration: 0.8, options: [.transitionFlipFromLeft], animations: nil, completion: { _ in
                self.previewLayerBackgroundView.layer.replaceSublayer(self.previewLayer!, with: newVideoLayer)
                self.previewLayer = newVideoLayer
            })
        }

}

