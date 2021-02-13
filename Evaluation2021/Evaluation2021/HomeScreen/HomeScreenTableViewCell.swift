//
//  HomeScreenTableViewCell.swift
//  Evaluation2021
//
//  Created by Sanat Salian on 13/02/21.
//  Copyright © 2021 Sanat Salian. All rights reserved.
//

import UIKit

class HomeScreenTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    //MARK: - Button Actions
    

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    }
    

    @IBAction func playButtonTapped(_ sender: UIButton) {
    }
    
}
