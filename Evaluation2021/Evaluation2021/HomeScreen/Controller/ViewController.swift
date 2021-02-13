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
            loadData()
        }
    }
    
    var photoObject: PhotoObject?
    var photos: [Photo] = []
    var photopage = 1
    var photoLimit = 20
    
    var videoObject: VideoObject?
    var videos: [Video] = []
    var videospage = 1
    var videoLimit = 20
    
    //MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotos()
        searchTextView.roundCorners(cornerRadius: 4)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigatinView()
    
    }

    override var navigationView: UIView? {
        let navView = Bundle.main.loadNibNamed(AppConstants.homeNavigation, owner: self, options: nil)?.first as? UIView
        return navView
    }
    
    
    //MARK: - Helper Methods
    
    func loadData() {
        switch selectedTab {
        case .photos:
            loadPhotos()
        case .videos:
            loadVideos()
        default:
            break
        }
    }
    
    func loadPhotos() {
        showActivityIndicator()
        NewtworkManager.loadPhotos(of: "animal", page: photopage, perPage: photoLimit) { [weak self] response in
            self?.hideActivityIndicator()
            self?.photopage = (self?.photopage ?? 1) + 1
            self?.processPhotosResponse (response: response)
        }
    }
    
    func loadVideos() {
        showActivityIndicator()
        NewtworkManager.loadVideos(of: "sunset", page: videospage, perPage: videoLimit) { [weak self] response in
            self?.hideActivityIndicator()
            self?.videospage = (self?.videospage ?? 1) + 1
            self?.processVideosResponse (response: response)
        }
    }
    
    private func processPhotosResponse (response: APIResponse) {
        if response.status == .ok {
            self.photoObject = response.data as? PhotoObject
            self.photos.append(contentsOf: self.photoObject?.photos ?? [])
    
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            
        } else {
            self.displayError(with: response.errorMessage ?? "")
        }
    }
    
    private func processVideosResponse (response: APIResponse) {
        if response.status == .ok {
            self.videoObject = response.data as? VideoObject
            self.videos.append(contentsOf: self.videoObject?.videos ?? [])
    
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            
        } else {
            self.displayError(with: response.errorMessage ?? "")
        }
    }
    
    func configurePhotosCell(_ cell: HomeScreenTableViewCell, withPhoto photo: Photo) {
        if let url = URL(string: photo.source?.originalPhoto ?? "") {
             cell.backgroundImageView.load(url: url)
        } else {
            cell.backgroundImageView.image = UIImage(named: "gray")
        }
        cell.playButton.isHidden = true
        cell.nameLabel.text = photo.photographer
    
    }
    
    func configureVideosCell(_ cell: HomeScreenTableViewCell, withVideo video: Video) {
        if let url = URL(string: video.imageUrl ?? "") {
             cell.backgroundImageView.load(url: url)
        } else {
            cell.backgroundImageView.image = UIImage(named: "gray")
        }
        cell.nameLabel.text = video.user?.name
        cell.playButton.isHidden = false
    
    }

}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedTab {
        case .photos:
            return photos.count
        case .videos:
            return videos.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.homeScreenTableViewCellCellIdentifier, for: indexPath) as! HomeScreenTableViewCell
        
        switch selectedTab {
        case .photos:
            configurePhotosCell(cell, withPhoto: photos[indexPath.row])
        case .videos:
            configureVideosCell(cell, withVideo: videos[indexPath.row])
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == photos.count - 1 {
            loadPhotos()
        }
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

