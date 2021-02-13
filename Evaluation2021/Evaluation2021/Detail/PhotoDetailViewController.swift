//
//  PhotoDetailViewController.swift
//  Evaluation2021
//
//  Created by Sanat Salian on 13/02/21.
//  Copyright © 2021 Sanat Salian. All rights reserved.
//

import UIKit

class PhotoDetailViewController: BaseViewController {
    //MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var zoomInButton: UIButton!
    @IBOutlet weak var zoomOutButton: UIButton!
    
    var photo: Photo?
    
    
    //MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - Helper methods
    
    private func setUpUI() {
        if let photo = photo {
            if let url = URL(string: photo.source?.originalPhoto ?? "")  {
                imageView.load(url: url)
            }
        }
        
        
        
    }
    
    //MARK: - Button Action
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
    }
    

    @IBAction func zoomInButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func zoomOutButtonTapped(_ sender: UIButton) {
    }
}
