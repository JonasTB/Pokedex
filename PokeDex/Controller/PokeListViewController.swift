//
//  PokeListViewController.swift
//  PokedexiOS
//
//  Created by Jonas on 08/12/19.
//  Copyright © 2019 Jonas. All rights reserved.
//

import UIKit

class PokeListViewController: UITableViewController {
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    var pokemons = Array< Pokemons >()
    var favoritePokemons = Array< Pokemons >()
    var currentPokemon = 0

    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadPokemons()
    }
    
    
    @IBAction func addToFavorites(_ sender: UIButton ) {
        
        let tag = sender.tag
        let favoritePokemon = Pokemons( ID: tag )
        
        favoritePokemon.downloadInfoPokes {
            
            self.favoritePokemons.append( favoritePokemon )
        }
    }
    
    @IBAction func SegmentedChange(_ sender: Any ) {
        
        tableView.reloadData()
    }
    
    func loadOnePokemon(){
        
        let loadOnePokemon = Pokemons( ID: 1 )
        self.pokemons.append( loadOnePokemon )
        
        loadOnePokemon.downloadInfoPokes {
            
            self.tableView.reloadData()
        }
    }
    
    func loadPokemons() {
        
        if ( currentPokemon <= 151 ) {
            
            let start = currentPokemon + 1
            let end = currentPokemon + 20
            print( "Carregando Pokemons... ", terminator: "" )
            
            for i in start...end {
                
                let insideNewPoke = Pokemons( ID: i )
                self.pokemons.append( insideNewPoke )
                insideNewPoke.printLoaded()
                
                insideNewPoke.downloadInfoPokes {
                    
                    self.tableView.reloadData()
                }
            }
            
            currentPokemon = end + 1
            print( "" )
        }
    }


    override func numberOfSections( in tableView: UITableView ) -> Int {
        
        1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath ) {
        
        let lastElement = pokemons.count - 1
        
        if ( indexPath.row == lastElement ) {
            
            loadPokemons()
        }
    }
    
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        
         if ( segmentedController.selectedSegmentIndex == 0 ) {
            
            return self.pokemons.count
         } else {
            
            if ( segmentedController.selectedSegmentIndex == 1 ) {
                
            return self.favoritePokemons.count
            }
        }
        
        return 0
    }

    @IBAction func shareButtonClicked(_ sender: UIButton ) {
        
        let tag = sender.tag
        
               let text = "https://pokemondb.net/pokedex/\( tag )"
               //let url = "https://twitter.com/login?lang=pt/\( tag )"

               let textToShare = [ text ]
               let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.view
               
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

               self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell( withIdentifier: "PokeCell", for: indexPath ) as!
        PokeListProtypeCell
        
        if ( segmentedController.selectedSegmentIndex == 0 ) {
            
            let pokemon = self.pokemons[ indexPath.row ]
            
            cell.listNameLabel.text = pokemon.name
            cell.listImage.image = pokemon.imagePokemons
            cell.Id = pokemon.ID
            cell.btnFavorites.tag = pokemon.ID
            cell.btnShare.tag = pokemon.ID
            cell.btnFavorites.isHidden = false
            
        } else {
            
            if ( segmentedController.selectedSegmentIndex == 1 ) {
                
            let pokemon = self.favoritePokemons[indexPath.row]
                
            cell.listNameLabel.text = pokemon.name
            cell.listImage.image = pokemon.imagePokemons
            cell.Id = pokemon.ID
            cell.btnShare.tag = pokemon.ID
            cell.btnFavorites.isHidden = true
            }
        }

        return cell
    }
    
    let pokemonDetailIdentifier = "DetailView"
    var Entry = String()
    
    func defineEntry( id: Int ) {
        
        Entry = pokemons[ id ].entryPokemons
    }
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {
        
        if ( segmentedController.selectedSegmentIndex == 0 ) {
            
            if ( segue.identifier == pokemonDetailIdentifier ) ,
                
                let destination = segue.destination as? DetailView,
                
                let pokemonIndex = tableView.indexPathForSelectedRow?.row {
                
                    destination.pokemonName = pokemons[ pokemonIndex ].name
                    destination.pokemonImage = pokemons[ pokemonIndex ].imagePokemons!
                    destination.pokemonType = pokemons[ pokemonIndex ].type
                    destination.pokemonHeight = pokemons[ pokemonIndex ].height
                    destination.pokemonWeight = pokemons[ pokemonIndex ].weight
                    destination.pokemonId = pokemons[ pokemonIndex ].ID
            }
            
        } else {
            
            if ( segmentedController.selectedSegmentIndex == 1 ) {
                
            if ( segue.identifier == pokemonDetailIdentifier ),
                
                let destination = segue.destination as? DetailView,
                
                let pokemonIndex = tableView.indexPathForSelectedRow?.row {
                
                    destination.pokemonName = favoritePokemons[ pokemonIndex ].name
                    destination.pokemonImage = favoritePokemons[ pokemonIndex ].imagePokemons!
                    destination.pokemonType = favoritePokemons[ pokemonIndex ].type
                    destination.pokemonHeight = favoritePokemons[ pokemonIndex ].height
                    destination.pokemonWeight = favoritePokemons[ pokemonIndex ].weight
                    destination.pokemonId = favoritePokemons[ pokemonIndex ].ID
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath ) {
        
        if ( editingStyle == .delete ) {
            
            self.favoritePokemons.remove( at: indexPath.row )
            tableView.deleteRows( at: [ indexPath ], with: .fade )
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath ) -> Bool {
        
        if ( segmentedController.selectedSegmentIndex == 0 ) {
            
            return false
        }else {
            
            if ( segmentedController.selectedSegmentIndex == 1 ) {
                
            return true
            }
        }
        
        return false
    }

}
