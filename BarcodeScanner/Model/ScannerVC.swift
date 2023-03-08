//
//  ScannerVC.swift
//  BarcodeScanner
//
//  Created by Lucas on 2023-03-07.
//
/*This is a Swift code that implements a ScannerVC class that is a subclass of UIViewController and provides functionality to capture and scan barcodes using the device's camera.
 
 The ScannerVC class conforms to the AVCaptureMetadataOutputObjectsDelegate protocol, which enables it to receive metadata objects, including barcode information, from the camera. The ScannerVC also defines a ScannerVCDelegate protocol that has two methods: didFind(barcode: String) and didSurface(error: CameraError). The didFind(barcode: String) method is called when a valid barcode is found and the didSurface(error: CameraError) method is called when an error occurs during barcode scanning.

 The class has a captureSession property that is an instance of AVCaptureSession, which is used to configure and manage the capture of video and audio data from the device's camera. The previewLayer property is an instance of AVCaptureVideoPreviewLayer, which is used to display the video captured by the device's camera.

 The setupCaptureSession() method is used to configure the captureSession and previewLayer properties. It initializes the videoCaptureDevice property with the default video capture device, creates an instance of AVCaptureDeviceInput using videoCaptureDevice, and adds it to the captureSession. It then creates an instance of AVCaptureMetadataOutput to handle the metadata objects received from the camera and adds it to the captureSession. The metadataObjectTypes property of the AVCaptureMetadataOutput instance is set to [.ean8, .ean13] to specify the types of barcode to be scanned. Finally, the previewLayer property is set to display the video preview layer on the view.

 The metadataOutput(_:didOutput:from:) method is called when the AVCaptureMetadataOutput receives a metadata object from the camera. It first checks if there is at least one object in the metadataObjects array and then casts the first object to an instance of AVMetadataMachineReadableCodeObject. It then extracts the stringValue property from the machineReadableObject and passes it to the scannerDelegate via the didFind(barcode: String) method.

 If an error occurs during the barcode scanning process, the didSurface(error: CameraError) method of the ScannerVCDelegate protocol is called with an appropriate error type from the CameraError enum.

 Overall, this code provides a simple implementation of barcode scanning functionality using the device's camera and can be used as a starting point for building more complex barcode scanning apps.*/



import AVFoundation
import UIKit


enum CameraError {
    case invalidDeviceInput
    case invalidScannedValue
}


protocol ScannerVCDelegate: AnyObject {
    
    func didFind(barcode: String)
    func didSurface(error: CameraError)
    
}

final class ScannerVC: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    weak var scannerDelegate: ScannerVCDelegate!
    
    init(scannerDelegate: ScannerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let previewLayer = previewLayer else{
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer.frame = view.layer.bounds
    }
    
    
    
    private func setupCaptureSession(){
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        }else{
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput){
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
        }else{
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
        
    }
    
    
}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate{
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        guard let barcode = machineReadableObject.stringValue else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        
//        captureSession.stopRunning() - uncomment this line with you do not want to keep scanning
        scannerDelegate?.didFind(barcode: barcode)
        
        
    }
    
}
