//
//  HomeScreenTableViewCell.swift
//  Evaluation2021
//
//  Created by Sanat Salian on 13/02/21.
//  Copyright © 2021 Sanat Salian. All rights reserved.
//

import UIKit

protocol HomeScreenTableViewCellProtocol {
    func didTapFavotiteButtom(_ value: Bool, indexPath: IndexPath?)
    func didTapPlayButton(_ indexPath: IndexPath?)
}


class HomeScreenTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var delegate: HomeScreenTableViewCellProtocol?
    var indexPath: IndexPath?
    var isFavorite: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    //MARK: - Button Actions
    

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        isFavorite = !isFavorite
        delegate?.didTapFavotiteButtom(isFavorite, indexPath: indexPath)
    }
    

    @IBAction func playButtonTapped(_ sender: UIButton) {
        delegate?.didTapPlayButton(indexPath)
    }
    
}
