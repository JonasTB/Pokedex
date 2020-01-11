//
//  PokeListCell.swift
//  PokedexiOS
//
//  Created by Jonas on 08/12/19.
//  Copyright © 2019 Jonas. All rights reserved.
//

import UIKit


class PokeListProtypeCell: UITableViewCell {
    

    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var btnFavorites: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    
    var Id = Int()
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool ) {
        
        super.setSelected( selected, animated: animated )
    }

}
