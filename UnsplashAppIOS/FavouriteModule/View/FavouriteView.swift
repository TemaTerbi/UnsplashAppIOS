//
//  FavouriteView.swift
//  UnsplashAppIOS
//
//  Created by Артем Соловьев on 10.10.2022.
//

import UIKit

final class FavouriteView: UIViewController {
    
    let tableView = UITableView.init(frame: .zero)
    var photos: [Photos] = []
    var viewModel = FavouriteViewModel()
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (contex) in
            self.updateLayout(with: size)
        }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.favPhotos.bind { photos in
            self.photos = photos
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("favPhotos"), object: nil, queue: .main) { (_) in
            let data = UserDefaults.standard.data(forKey: "favPhotos")
            guard let data = data else { return }
            let favArray = try! JSONDecoder().decode([Photos].self, from: data)
            self.photos = favArray
            self.tableView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        updateLayout(with: self.view.frame.size)
        addSubView()
        setupTable()
        
        let data = UserDefaults.standard.data(forKey: "favPhotos")
        guard let data = data else { return }
        let favArray = try! JSONDecoder().decode([Photos].self, from: data)
        self.photos = favArray
        self.tableView.reloadData()
    }
    
    private func addSubView() {
        self.view.addSubview(tableView)
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect.init(origin: .zero, size: size)
    }
}

extension FavouriteView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavouriteCell
        let photosInfo = photos[indexPath.row]
        cell.selectionStyle = .none
        cell.setupCell(photosInfo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
