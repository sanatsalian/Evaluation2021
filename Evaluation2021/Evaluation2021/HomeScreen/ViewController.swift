//
//  ViewController.swift
//  Evaluation2021
//
//  Created by Sanat Salian on 12/02/21.
//  Copyright © 2021 Sanat Salian. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigatinView()
    
    }

    override var navigationView: UIView? {
        
        let navView = Bundle.main.loadNibNamed(AppConstants.homeNavigation, owner: self, options: nil)?.first as? UIView
        return navView
    }

}

