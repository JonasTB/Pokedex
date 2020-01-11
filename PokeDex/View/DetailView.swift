//
//  DetailViewController.swift
//  PokedexiOS
//
//  Created by Jonas on 04/12/19.
//  Copyright © 2019 Jonas. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class DetailView: UIViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var labelHeight: UILabel!
    @IBOutlet weak var labelWeight: UILabel!
    @IBOutlet weak var textEntry: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    var pokemonId = Int()
    var pokemonName = String()
    var pokemonType = String()
    var pokemonImage = UIImage()
    var pokemonWeight = String()
    var pokemonHeight = String()
    var pokemonEntry = String()

    override func viewWillAppear(_ animated: Bool ) {
        
        pokemonType = pokemonType.capitalizingFirstLetter()
        
        labelName.text = "Nome: \(pokemonName)"
        labelType.text = "Tipo: \(pokemonType)"
        image.image = pokemonImage
        labelHeight.text = "Altura: \(pokemonHeight)"
        labelWeight.text = "Peso: \(pokemonWeight)"
        
        getPokedexEntry()
    }
    
    public func getPokedexEntry() {
        
        AF.request( "https://pokeapi.co/api/v2/pokemon-species/" + String( pokemonId ) ).responseJSON( completionHandler: { response in
            
        print( response )
        switch response.result {
            
        case .success( let model ):
            let json = JSON( model )
            let newEntry = json[ "flavor_text_entries" ][ 1 ][ "flavor_text" ].string
            self.pokemonEntry = newEntry!
            self.textEntry.text = self.pokemonEntry
            
        case .failure( let error ):
            
            print( error )
        }
        })
    }

}
