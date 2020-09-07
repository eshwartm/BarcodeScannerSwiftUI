//
//  BarcodeScannerView.swift
//  BarcodeScanner
//
//  Created by Eshwar Ramesh on 9/4/20.
//  Copyright © 2020 Eshwar Ramesh. All rights reserved.
//

import SwiftUI
import AVFoundation

struct BarcodeScannerView: View {
    
    var body: some View {
        VStack {
            Text("Hello World")
//            CustomUIKitView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)))
            CustomUIKitViewController()
        }
    }
    
}

final class CustomUIKitView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let button = UIButton(type: .custom)
        self.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        
        let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
        button.addConstraints([widthConstraint, heightConstraint])
        
        let centerXConstraint = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        button.addConstraints([centerXConstraint, centerYConstraint])
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
        
        button.setTitle("Hello World", for: .normal)
        button.backgroundColor = .purple
        
        button.addTarget(self, action: #selector(CustomUIKitViewController.buttonTapped), for: .touchUpInside)
        
        self.backgroundColor = UIColor.red
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /*override func layoutSubviews() {
        super.layoutSubviews()
//        button.frame = bounds
    }*/
    
    
}

final class CustomUIKitViewController:UIViewController, UIViewControllerRepresentable {
    
    var sharedProp = 0
    typealias UIViewControllerType = UIViewController
    
    override func loadView() {
        view = CustomUIKitView()
    }
    
    override func viewDidLoad() {
        print("shared prop \(sharedProp)")
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CustomUIKitViewController>) -> UIViewController {
        return self
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CustomUIKitViewController>) {
        print("======================== Updating view controller: \(uiViewController)")
    }
    
    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        print("======================== Dismantling custom view controller : \(uiViewController), coordinator : \(coordinator)")
    }
    
    func makeCoordinator() -> CustomUIKitViewController.Coordinator {
        return Coordinator()
    }
    
    @objc func buttonTapped() {
        sharedProp += 1
        print("something \(sharedProp)")
    }
}

extension CustomUIKitView: UIViewRepresentable {
    
    typealias UIViewType = UIView
    
    func makeUIView(context: UIViewRepresentableContext<CustomUIKitView>) -> CustomUIKitView.UIViewType {
        return self
    }
    
    func updateUIView(_ uiView: CustomUIKitView.UIViewType, context: UIViewRepresentableContext<CustomUIKitView>) {
        print("======================== Updating custom view: \(uiView)")
    }
    
    static func dismantleUIView(_ uiView: CustomUIKitView.UIViewType, coordinator: CustomUIKitView.Coordinator) {
        print("======================== Dismantling custom view : \(uiView), coordinator : \(coordinator)")
    }
    
    /*func makeCoordinator() -> CustomUIKitView.Coordinator {
        return CustomUIKitView.UIViewType
    }*/
    
}

struct BarcodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
    }
}

/*
 import UIKit
 import AVFoundation

 class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

     let session         : AVCaptureSession = AVCaptureSession()
     var previewLayer    : AVCaptureVideoPreviewLayer!
     var highlightView   : UIView = UIView()

     override func viewDidLoad() {
         super.viewDidLoad()

         // Allow the view to resize freely
         self.highlightView.autoresizingMask =
             UIViewAutoresizing.FlexibleTopMargin |
             UIViewAutoresizing.FlexibleBottomMargin |
             UIViewAutoresizing.FlexibleLeftMargin |
             UIViewAutoresizing.FlexibleRightMargin

         // Select the color you want for the completed scan reticle
         self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
         self.highlightView.layer.borderWidth = 3

         // Add it to our controller's view as a subview.
         self.view.addSubview(self.highlightView)

         // For the sake of discussion this is the camera
         let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)

         // Create a nilable NSError to hand off to the next method.
         // Make sure to use the "var" keyword and not "let"
         var error : NSError? = nil

         let input : AVCaptureDeviceInput? =
             AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error)
                 as? AVCaptureDeviceInput

         // If our input is not nil then add it to the session, otherwise we're kind of done!
         if input != nil {
             session.addInput(input)
         } else {
             // This is fine for a demo, do something real with this in your app. :)
             println(error)
         }

         let output = AVCaptureMetadataOutput()
         output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
         session.addOutput(output)
         output.metadataObjectTypes = output.availableMetadataObjectTypes

         previewLayer =
             AVCaptureVideoPreviewLayer.layerWithSession(session)
                 as! AVCaptureVideoPreviewLayer
         previewLayer.frame = self.view.bounds
         previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
         self.view.layer.addSublayer(previewLayer)

         // Start the scanner. You'll have to end it yourself later.
         session.startRunning()
     }

     // This is called when we find a known barcode type with the camera.
     func captureOutput(
         captureOutput: AVCaptureOutput!,
         didOutputMetadataObjects metadataObjects: [AnyObject]!,
         fromConnection connection: AVCaptureConnection!) {

         var highlightViewRect = CGRectZero
         var barCodeObject : AVMetadataObject!
         var detectionString : String!

         let barCodeTypes = [AVMetadataObjectTypeUPCECode,
             AVMetadataObjectTypeCode39Code,
             AVMetadataObjectTypeCode39Mod43Code,
             AVMetadataObjectTypeEAN13Code,
             AVMetadataObjectTypeEAN8Code,
             AVMetadataObjectTypeCode93Code,
             AVMetadataObjectTypeCode128Code,
             AVMetadataObjectTypePDF417Code,
             AVMetadataObjectTypeQRCode,
             AVMetadataObjectTypeAztecCode]

         // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
         for metadata in metadataObjects {

             for barcodeType in barCodeTypes {

                 if metadata.type == barcodeType {
                     barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject)
                     highlightViewRect = barCodeObject.bounds
                     detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                     self.session.stopRunning()
                     self.alert(detectionString)
                     break
                 }
             }
         }

         println(detectionString)
         self.highlightView.frame = highlightViewRect
         self.view.bringSubviewToFront(self.highlightView)
     }

     func alert(Code: String){
         let actionSheet:UIAlertController =
             UIAlertController(
                 title: "Barcode",
                 message: "\(Code)",
                 preferredStyle: UIAlertControllerStyle.Alert)

         // for alert add .Alert instead of .Action Sheet
         // start copy
         let firstAlertAction:UIAlertAction =
             UIAlertAction(
                 title: "OK",
                 style: UIAlertActionStyle.Default,
                 handler: { (alertAction: UIAlertAction!) in
                 // action when pressed
                 self.session.startRunning()
         })

         actionSheet.addAction(firstAlertAction)
         // end copy
         self.presentViewController(actionSheet, animated: true, completion: nil)
     }
 }
 */

/*
 public class BarcodeFramework: AVCaptureMetadataOutputObjectsDelegate {
     let session = AVCaptureSession()
     var previewLayer = AVCaptureVideoPreviewLayer()
     let device = AVCaptureDevice.default(for: .video)
     var error: NSError? = nil
     var input: AVCaptureDeviceInput?
     let output = AVCaptureMetadataOutput()
 
     func initializeCaptureDeviceInput() {
         guard let avCaptureDevice = device else {
             return
         }
         do {
             if let input = try? AVCaptureDeviceInput(device: avCaptureDevice) {
                 session.addInput(input)
             }
             output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
             session.addOutput(output)
             output.metadataObjectTypes = output.availableMetadataObjectTypes
         } catch let err {
             print(err)
             print(error)
         }
     }
 }
 */
