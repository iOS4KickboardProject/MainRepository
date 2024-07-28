//
//  QRcodeViewcontroller.swift
//  kickBoardProject
//
//  Created by 이득령 on 7/28/24.
//

import UIKit
import AVFoundation

class QRcodeViewcontroller: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var guideLayer: CAShapeLayer!
    var shared = KickboardRepository.shared
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        // 사각형 가이드라인 추가
        addGuideLayer()

        // 뒤로 가기 버튼 추가
        addBackButton()

        captureSession.startRunning()
    }

    func addGuideLayer() {
        let guideSize = CGSize(width: 250, height: 250)
        let guideRect = CGRect(x: (view.frame.size.width - guideSize.width) / 2,
                               y: (view.frame.size.height - guideSize.height) / 2,
                               width: guideSize.width,
                               height: guideSize.height)

        guideLayer = CAShapeLayer()
        guideLayer.path = UIBezierPath(rect: guideRect).cgPath
        guideLayer.strokeColor = UIColor.green.cgColor
        guideLayer.lineWidth = 4.0
        guideLayer.fillColor = UIColor.clear.cgColor

        view.layer.addSublayer(guideLayer)
    }

    func addBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setTitle("뒤로가기", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backButton.layer.cornerRadius = 8
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 60),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    func failed() {
        let ac = UIAlertController(title: "스캔되지 않음", message: "장치에서 항목에서 코드를 스캔하는 것을 지원하지 않습니다. 카메라가 있는 장치를 사용하십시오.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "확인", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        print(shared.kickboardID)
        shared.qrMOdalShow = true
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        print(code)
        self.shared.kickboardID = code
        self.shared.qrMOdalShow = true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
