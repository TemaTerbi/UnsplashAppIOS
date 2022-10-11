//
//  MainPageView.swift
//  UnsplashAppIOS
//
//  Created by Артем Соловьев on 10.10.2022.
//

import UIKit

final class MainPageView: UIViewController {
    
    private let tableView = UITableView.init(frame: .zero)
    private let viewModel = MainPageViewModel()
    private var photos: [Photos] = []
    private var filteredPhotos: [Photos] = []
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isSearhcBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearhcBarIsEmpty
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (contex) in
            self.updateLayout(with: size)
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        updateLayout(with: self.view.frame.size)
        addSubView()
        setupTable()
        viewModel.getRandomPhotos()
        bindingsViewModel()
        checkFavArray()
        
        UserDefaults.standard.set(1, forKey: "page")
        NotificationCenter.default.post(name: NSNotification.Name("page"), object: nil)
    }
    
    private func checkFavArray() {
        let favData = UserDefaults.standard.data(forKey: "favPhotos")
        guard let favData = favData else {
            let photosArray: [Photos] = []
            let photosArrayData = try! JSONEncoder().encode(photosArray)
            UserDefaults.standard.set(photosArrayData, forKey: "favPhotos")
            NotificationCenter.default.post(name: NSNotification.Name("favPhotos"), object: nil)
            return
        }
        let favArray = try! JSONDecoder().decode([Photos].self, from: favData)
    }
    
    private func addSubView() {
        self.view.addSubview(tableView)
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MainPostCell.self, forCellReuseIdentifier: "cell")
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Введите имя автора"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect.init(origin: .zero, size: size)
    }
    
    private func bindingsViewModel() {
        viewModel.photos.bind { photos in
            self.photos = photos
            self.tableView.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 {
            //            self.tableView.setContentOffset(.zero, animated: true)
            viewModel.getMoreRandomPhotos()
        }
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredPhotos = photos.filter { (photo: Photos) -> Bool in
            return photo.user?.username?.lowercased().contains(searchText.lowercased()) ?? false
        }
        
        tableView.reloadData()
    }
}

extension MainPageView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPhotos.count
        } else {
            return photos.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainPostCell
        cell.selectionStyle = .none
        if isFiltering {
            let photos = self.filteredPhotos[indexPath.row]
            cell.setupCell(photos)
        } else {
            let photos = self.photos[indexPath.row]
            cell.setupCell(photos)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering {
            let vc = DetailScreenView()
            let photosInfo = filteredPhotos[indexPath.row]
            vc.userName = photosInfo.user?.username ?? ""
            vc.date = photosInfo.created_at ?? ""
            vc.locate = photosInfo.user?.location ?? "Не указано"
            vc.countOfDownloads = photosInfo.downloads ?? 0
            let id = photosInfo.id
            UserDefaults.standard.set(id, forKey: "idPhoto")
            vc.url = photosInfo.urls?.small ?? ""
            vc.currentElement = photosInfo
            vc.id = photosInfo.id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = DetailScreenView()
            let photosInfo = photos[indexPath.row]
            vc.userName = photosInfo.user?.username ?? ""
            vc.date = photosInfo.created_at ?? ""
            vc.locate = photosInfo.user?.location ?? "Не указано"
            vc.countOfDownloads = photosInfo.downloads ?? 0
            let id = photosInfo.id
            UserDefaults.standard.set(id, forKey: "idPhoto")
            vc.url = photosInfo.urls?.small ?? ""
            vc.currentElement = photosInfo
            vc.id = photosInfo.id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MainPageView: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text ?? "")
    }
}
