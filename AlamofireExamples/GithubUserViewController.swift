//
//  GIthubUserViewController.swift
//  AlamofireExamples
//
//  Created by Nicholas Brandt on 4/28/18.
//  Copyright © 2018 Nicholas Brandt. All rights reserved.
//

import UIKit
import Alamofire

/// A UIViewController instance which uses Alamofire to load a JSON repsonse from the Github API for my account.
///
/// The response is parsed into a GithubUser object using the Codable protocol.
/// The user's avatar, name and bio are then outputted to the interface. The avatar is downloaded from a URL.
/// The progress closure for the data response will update a progress bar when downloading the avatar.

class GithubUserViewController: UIViewController {
    
    let avatar = UIImageView(frame: CGRect(x: 0, y: 0, width: 256, height: 256))
    let name = UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 40))
    let bio = UILabel(frame: CGRect(x: 0, y: 0, width: 280, height: 280))
    let progressView = UIProgressView(progressViewStyle: .bar)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(avatar)
        avatar.center = CGPoint(x: view.center.x, y: 168)
        avatar.contentMode = .scaleAspectFit
        
        view.addSubview(name)
        name.center = CGPoint(x: avatar.center.x, y: avatar.frame.maxY + 20)
        name.textColor = .black
        name.textAlignment = .center
        
        view.addSubview(bio)
        bio.center = CGPoint(x: avatar.center.x, y: name.frame.maxY + 140)
        bio.textColor = .black
        bio.textAlignment = .center
        bio.numberOfLines = 0
        
        view.addSubview(progressView)
        progressView.frame = CGRect(x: 0, y: 0, width: 256, height: 32)
        progressView.center = avatar.center
        progressView.setProgress(0.0, animated: true)
        progressView.backgroundColor = .lightGray
        progressView.tintColor = UIColor.blue.withAlphaComponent(0.75)
        
        fetchData(from: "https://api.github.com/users/nakkamarra")
    }
    
    private func fetchData(from url: String) {
        Alamofire.request(url).responseJSON { (jsonResponse) in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let user = try decoder.decode(GithubUser.self, from: jsonResponse.data!)
                self.updateInterfaceWithUser(user: user)
                print(user)
            } catch {
                print(error)
            }
        }.validate()
    }
    
    private func updateInterfaceWithUser(user: GithubUser) {
        let dest : DownloadRequest.DownloadFileDestination = { _, _ in
            let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let fileURL = cachesURL.appendingPathComponent(user.avatarUrl.absoluteString)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(user.avatarUrl, to: dest)
            .downloadProgress { (downloadProgress) in
                let percent = Float(downloadProgress.fractionCompleted)
                self.progressView.setProgress(percent, animated: true)
            }.responseData { (data) in
                print(data)
                guard let imageData = data.value else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    // Remove progress bar
                    self.progressView.removeFromSuperview()
                    
                    // Set avatar
                    self.avatar.image = UIImage(data: imageData)
                    
                    // Set name
                    self.name.text = user.name
                    
                    // Set bio
                    self.bio.text = "User has no biography."
                    guard user.bio != nil else { return }
                    self.bio.text = user.bio
                })
            }.validate()
    }
}
