//
//  BaseViewController.swift
//  Evaluation2021
//
//  Created by Sanat Salian on 13/02/21.
//  Copyright © 2021 Sanat Salian. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var activityView: UIActivityIndicatorView?
    
    var navigationView: UIView? {
        return UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupNavigatinView() {
        if let navView = navigationView {
            
            view.addSubview(navView)
            navView.translatesAutoresizingMaskIntoConstraints = false
            navView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
            navView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
            navView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
            navView.heightAnchor.constraint(equalToConstant: 94).isActive = true
            view.layoutIfNeeded()
            
        }
    }
    
    func displayError(with message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
    
}
