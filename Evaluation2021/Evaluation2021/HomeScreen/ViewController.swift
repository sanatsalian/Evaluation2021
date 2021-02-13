//
//  ViewController.swift
//  Evaluation2021
//
//  Created by Sanat Salian on 12/02/21.
//  Copyright © 2021 Sanat Salian. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    //MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTextView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedTab: HomeScreenTabs = HomeScreenTabs.photos{
        didSet{
            let previousSelectedIndexpath = IndexPath(item: oldValue.rawValue, section: 0)
            let selectedIndexpath = IndexPath(item: selectedTab.rawValue, section: 0)
            collectionView.reloadItems(at: [previousSelectedIndexpath, selectedIndexpath])
//            getEoiSitePrepCount()
//            switchChildViewController(from: oldValue, to: selectedTab)
        }
    }
    
    //MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return HomeScreenTabs.numberOfTabs
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.homeScreentabCellIdentifier, for: indexPath) as! HomeScreenCategoryCollectionViewCell
          let tab = HomeScreenTabs(rawValue: indexPath.item)!
          cell.tabTitleLabel.text = tab.title
         
          if tab == selectedTab{
              cell.tabTitleLabel.isEnabled = true
              cell.selectionHighlightIndicatorView.isHidden = false
          } else {
              cell.tabTitleLabel.isEnabled = false
              cell.selectionHighlightIndicatorView.isHidden = true
          }
          
          return cell
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != selectedTab.rawValue {
            selectedTab = HomeScreenTabs(rawValue: indexPath.item)!
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tab = HomeScreenTabs(rawValue: indexPath.item)!
        //let fontAttributes = [NSFontAttributeName: font] // it says name, but a UIFont works
        let size = (tab.title as NSString).size(withAttributes: nil)
        return CGSize(width: max(70, size.width + 40), height: 44.0)
    }
}

