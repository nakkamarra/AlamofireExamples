//
//  UploaderViewController.swift
//  AlamofireExamples
//
//  Created by Nicholas Brandt on 4/28/18.
//  Copyright © 2018 Nicholas Brandt. All rights reserved.
//

import UIKit
import Alamofire

/// A UIViewController instance which allows a user to take a photo using the UIImagePickerController.
/// The image that is taken is then compressed into data and Alamofire is used to upload said data.
/// The API endpoint provided accepts images and then deletes them.

class UploaderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 256, height: 256))
    let mainLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 80))
    let progressView = UIProgressView(progressViewStyle: .bar)
    let button = UIButton(type: UIButtonType.contactAdd)
    let cameraInstance = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.center = CGPoint(x: view.center.x, y: view.center.y)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "camera")
        
        view.addSubview(mainLabel)
        mainLabel.center = CGPoint(x: imageView.center.x, y: 80)
        mainLabel.textColor = .black
        mainLabel.textAlignment = .center
        mainLabel.text = "Click the button below to upload an image"
        mainLabel.numberOfLines = 0
        
        view.addSubview(button)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.center = CGPoint(x: imageView.center.x, y: imageView.frame.maxY + 120)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(takePhoto))
        button.addGestureRecognizer(tapGR)
        
        cameraInstance.delegate = self
        cameraInstance.sourceType = .camera
    }
    
    @objc private func takePhoto() {
        present(cameraInstance, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let imageTaken = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        guard let imageData = UIImageJPEGRepresentation(imageTaken, 0.6) else { return }
        DispatchQueue.main.async {
            self.imageView.image = imageTaken
        }
        self.cameraInstance.dismiss(animated: true, completion: nil)
        startUpload(data: imageData)
    }
    
    private func startUpload(data: Data) {
        view.addSubview(progressView)
        progressView.frame = CGRect(x: 0, y: 0, width: 256, height: 32)
        progressView.center = CGPoint(x: imageView.center.x, y: imageView.frame.minY - 48)
        progressView.setProgress(0.0, animated: true)
        progressView.backgroundColor = .lightGray
        progressView.tintColor = UIColor.blue.withAlphaComponent(0.75)
        uploadImage(to: "https://orangevalleycaa.org/api/upload_simple.php", imageData: data)
    }
    
    private func uploadImage(to uploadUrl: String, imageData: Data) {
        Alamofire.upload(imageData, to: uploadUrl)
            .uploadProgress { (progress) in
                let currentProg = Float(progress.fractionCompleted)
                self.progressView.setProgress(currentProg, animated: true)
            }.responseJSON { (jsonResponse) in
                print("RESPONSE: \(jsonResponse)")
                guard let responseData = jsonResponse.data else { return }
                jsonResponse.result.ifSuccess {
                    self.updateInterface(message: "Upload succeeded!")
                    debugPrint(responseData)
                }
                jsonResponse.result.ifFailure {
                    self.updateInterface(message: "Upload failed!")
                    debugPrint(responseData)
                }
            }.validate()
    }
    
    private func updateInterface(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.progressView.removeFromSuperview()
            self.mainLabel.text = message
            self.imageView.image = UIImage()
        }
    }
}
