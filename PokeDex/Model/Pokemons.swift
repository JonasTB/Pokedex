//
//  Pokemons.swift
//  PokedexiOS
//
//  Created by Jonas on 03/12/19.
//  Copyright © 2019 Jonas. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension String {
    
    func capitalizingFirstLetter() -> String {
        
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        
        self = self.capitalizingFirstLetter()
    }
}

class Pokemons {
    
    var name: String = ""
    var ID: Int
    var descPokemons: String = ""
    var type: String = ""
    var defense: String = ""
    var height: String = ""
    var weight: String = ""
    var attack: String = ""
    var nextEvolution: String = ""
    var lastEvolution: String = ""
    var imagePokemons: UIImage? = nil
    var entryPokemons: String = ""

    
    init( ID: Int ) {
        
        self.ID = ID
    }
    
    init( name: String, ID: Int, descPokemons: String, type: String, defense: String, attack: String, weight: String, height: String, nextEvolution: String, lastEvolution: String, imagePokemons: UIImage, entryPokemons: String ) {
        
        self.name = name
        self.ID = ID
        self.descPokemons = descPokemons
        self.type = type
        self.defense = defense
        self.attack = attack
        self.height = height
        self.weight = weight
        self.nextEvolution = nextEvolution
        self.lastEvolution = lastEvolution
        self.entryPokemons = entryPokemons
    }
    	
    func getData( from url: URL, completion: @escaping ( Data?, URLResponse?, Error? ) -> ()) {
        
        URLSession.shared.dataTask( with: url, completionHandler: completion ).resume()
    }
    
    func downloadImagePokemons( from url: URL ) {
        
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                
                self.imagePokemons = UIImage( data: data )!
            }
        }
    }
    
   func downloadInfoPokes( completed: @escaping ()->() ) {
    
        AF.request( "https://pokeapi.co/api/v2/pokemon/" + String( ID ) ).responseJSON( completionHandler: { response in
            
            switch response.result {
                
            case .success( let model ):
                
                let json = JSON( model )
                let height = json[ "height" ].int
                let weight = json[ "weight" ].int
                let aux = json[ "types" ].count - 1
                let type = json[ "types" ][ aux ][ "type" ][ "name" ].string
                let defense = json[ "stats" ][ 3 ][ "base_stat" ].int
                let attack = json[ "stats" ][ 0 ][ "base_stat" ].int
                let name = json[ "name" ].string
                let img_url = json[ "sprites" ][ "front_default" ].string
                self.name = name!.capitalizingFirstLetter()
                self.height = "\( height ?? 0 )"
                self.weight = "\( weight ?? 0 )"
                self.type = type!
                self.defense = "\( defense ?? 0 )"
                self.attack = "\( attack ?? 0 )"
                self.downloadImagePokemons( from: URL(string: img_url! )!)
                
            case .failure( let error ):
                
                print( error )
            }
            
            completed()
        })
    }
    
    public func getPokedexEntry( completed: @escaping () -> () ) {
        
        AF.request( "https://pokeapi.co/api/v2/pokemon-species/" + String( ID ) ).responseJSON(completionHandler: { response in
            
        print( response )
            
        switch response.result {
            
        case .success( let model ):
            
            let json = JSON( model )
            let newEntry = json[ "flavor_text_entries" ][ 1 ][ "flavor_text" ].string
            self.entryPokemons = newEntry!
            
        case .failure( let error ):
            
            print( error )
        }
            
            completed()
        })
    }
    
    public func printPokemon() {
        
        print( "Name: " + self.name, "Carregado" )
        print( "Height: " + self.height )
        print( "Weight: " + self.weight )
        print( "Type: " + self.type )
        print( "Defense: " + self.defense )
        print( "Attack: " + self.attack )
    }
    
    public func printLoaded() {
        
        print( self.ID, "..", terminator: "" )
    }
        
}

