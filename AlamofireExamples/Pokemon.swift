//
//  Pokemon.swift
//  AlamofireExamples
//
//  Created by Nicholas Brandt on 4/28/18.
//  Copyright © 2018 Nicholas Brandt. All rights reserved.
//

import Foundation

struct Pokemon : Codable {
    let id : Int
    let name : String
    let weight : Int
    let height : Int
    let baseExperience : Int
    let types : [PokemonType]
    let sprites : [String : URL?]
}

struct PokemonType: Codable {
    let slot : Int
    let type : Type
}

struct Type: Codable {
    let name : String
    let url : URL
}
