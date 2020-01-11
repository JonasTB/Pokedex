//
//  ViewController.swift
//  PokedexiOS
//
//  Created by Jonas on 03/12/19.
//  Copyright © 2019 Jonas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var postPokemons = Pokemons( ID: 1 )

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        postPokemons.downloadInfoPokes {
            
            print( "Completado!" )
        }
    }


}

