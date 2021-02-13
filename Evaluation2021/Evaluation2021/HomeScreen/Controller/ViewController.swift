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
    
    var favourites: [Favorite] = []
    
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
            videospage = 1
            videoLimit = 20
        case .videos:
            loadVideos()
            photopage = 1
            photoLimit = 20
        case .favorites:
            tableView.reloadData()
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
            self?.getFavoritePhotos()
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
    
    func getFavoritePhotos() {
        let favPhotos = photos.filter{$0.liked == true}
//        var FavList:
        for photo in favPhotos {
            let favPhoto = createFavPhoto(photo)
            favourites.append(favPhoto)
        }
    }
    
    private func createFavPhoto(_ photo: Photo) -> Favorite {
        var fav = Favorite()
        fav.id = photo.id
        fav.imageUrl = photo.source?.originalPhoto
        fav.name = photo.photographer
        fav.liked = photo.liked
        fav.type = .photo
        
        return fav
        
    }
    
    func configurePhotosCell(_ cell: HomeScreenTableViewCell, withPhoto photo: Photo) {
        cell.backgroundImageView.imageFromURL(urlString: photo.source?.originalPhoto ?? "")
        cell.playButton.isHidden = true
        cell.nameLabel.text = photo.photographer
        cell.isFavorite = photo.liked ?? false
        cell.favoriteButton.isSelected = photo.liked ?? false
        if photo.liked ?? false {
            cell.favoriteButton.setImage(UIImage(named: "Details-Favorite-slect"), for: .normal)
        } else {
            cell.favoriteButton.setImage(UIImage(named: "Facorite_home-deselet"), for: .normal)
        }
    
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
    
    func configureFavoriteCell(_ cell: HomeScreenTableViewCell, withFavorite favorite: Favorite) {
        if let url = URL(string: favorite.imageUrl ?? "") {
             cell.backgroundImageView.load(url: url)
        } else {
            cell.backgroundImageView.image = UIImage(named: "gray")
        }
        cell.nameLabel.text = favorite.name
        cell.playButton.isHidden = (favorite.type == .photo) ? true : false
    
    }
    
    func loadPhotoDetailScreen(_ photo: Photo) {
        if let photoDetailVC = UIViewController.loginViewController() as? PhotoDetailViewController {
            photoDetailVC.photo = photo
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.pushViewController(photoDetailVC, animated: true)
        }
    }

}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedTab {
        case .photos:
            return photos.count
        case .videos:
            return videos.count
        case .favorites:
            return favourites.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.homeScreenTableViewCellCellIdentifier, for: indexPath) as! HomeScreenTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        switch selectedTab {
        case .photos:
            configurePhotosCell(cell, withPhoto: photos[indexPath.row])
        case .videos:
            configureVideosCell(cell, withVideo: videos[indexPath.row])
        case .favorites:
            configureFavoriteCell(cell, withFavorite: favourites[indexPath.row])
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch selectedTab {
        case .photos:
            if indexPath.row == photos.count - 1 {
                loadPhotos()
            }
        case .videos:
            if indexPath.row == videos.count - 1 {
                loadVideos()
            }
        case .favorites:
            break
        default:
            break
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedTab {
        case .photos:
            loadPhotoDetailScreen(photos[indexPath.row])
        default:
            break
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

extension ViewController: HomeScreenTableViewCellProtocol {
    func didTapFavotiteButtom(_ value: Bool, indexPath: IndexPath?) {
        if let indexPath = indexPath {
            photos[indexPath.row].liked = value
            if value {
                let fav = createFavPhoto(photos[indexPath.row])
                favourites.append(fav)
            } else {
                if let index = favourites.index(where: { $0.id == photos[indexPath.row].id}) {
                    favourites.remove(at: index)
                }
            }
        }
        
        
        tableView.reloadData()
       
        
    }
    
    func didTapPlayButton(_ indexPath: IndexPath?) {
        
    }
    
    
}

