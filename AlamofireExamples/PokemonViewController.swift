//
//  ViewController.swift
//  AlamofireExamples
//
//  Created by Nicholas Brandt on 4/27/18.
//  Copyright © 2018 Nicholas Brandt. All rights reserved.
//

import UIKit
import Alamofire

/// A UIViewController instance which uses Alamofire to load a JSON repsonse from the Pokéapi for a random pokemon.
///
/// The response is parsed into a Pokemon object using the Codable protocol.
/// The pokemon's sprite, name and type(s) and then outputted to the interface. The sprite is downloaded from a URL.
/// The download progress of the sprite image data is mapped to a UIProgressView.

class PokemonViewController: UIViewController {

    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 256, height: 256))
    let name = UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 40))
    let type = UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 40))
    let progressView = UIProgressView(progressViewStyle: .bar)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.center = view.center
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(name)
        name.center = CGPoint(x: imageView.center.x, y: imageView.center.y + 168)
        name.textColor = .black
        name.textAlignment = .center
        
        view.addSubview(type)
        type.center = CGPoint(x: imageView.center.x, y: imageView.center.y + 208)
        type.textColor = .black
        type.textAlignment = .center
        
        view.addSubview(progressView)
        progressView.frame = CGRect(x: 0, y: 0, width: 256, height: 32)
        progressView.center = imageView.center
        progressView.setProgress(0.0, animated: true)
        progressView.backgroundColor = .lightGray
        progressView.tintColor = UIColor.red.withAlphaComponent(0.75)
        
        fetchData(from: "https://pokeapi.co/api/v2/pokemon/\(arc4random_uniform(802))/", params: [:])
    }
    
    // Query string url encoding parameters
    private func fetchData(from url: String, params: [String: Any]) {
        Alamofire.request(url, parameters: params).responseJSON { (jsonResponse) in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let pokemon = try decoder.decode(Pokemon.self, from: jsonResponse.data!)
                self.updateInterfaceForPokemon(pokemon: pokemon)
                print(pokemon)
            } catch {
                print(error)
            }
        }.validate()
    }
    
    private func updateInterfaceForPokemon(pokemon: Pokemon) {
        // Saves the download into a file
        guard let spriteUrl = pokemon.sprites["frontDefault"], spriteUrl != nil else { return }
        
        let dest : DownloadRequest.DownloadFileDestination = { _, _ in
            let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let fileURL = cachesURL.appendingPathComponent(spriteUrl!.absoluteString)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        // Starts the download task, updates the progress bar
        Alamofire.download(spriteUrl!, to: dest).downloadProgress(closure: { (progress) in
            DispatchQueue.main.async {
                self.progressView.setProgress(Float(progress.fractionCompleted), animated: true)
            }
        })
        .responseData(completionHandler: { (data) in
            guard let imageData = data.value else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.progressView.removeFromSuperview()
                self.imageView.image = image
                self.name.text = "Pokemon: \(pokemon.name)"
                let types : [String] = pokemon.types.map({ (mainType) -> String in
                    return mainType.type.name
                })
                self.type.text = "Type(s): "
                self.type.text?.append(types.count == 1 ? "\(types[0])" : "\(types[0]) & \(types[1])")
            })
        })
    }
}

