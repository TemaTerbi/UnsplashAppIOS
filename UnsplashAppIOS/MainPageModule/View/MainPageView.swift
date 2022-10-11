//
//  MainPageView.swift
//  UnsplashAppIOS
//
//  Created by Артем Соловьев on 10.10.2022.
//

import UIKit

final class MainPageView: UIViewController {
    
    let tableView = UITableView.init(frame: .zero)
    let viewModel = MainPageViewModel()
    var photos: [Photos] = []
    
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
        
        UserDefaults.standard.set(1, forKey: "page")
    }
    
    private func addSubView() {
        self.view.addSubview(tableView)
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MainPostCell.self, forCellReuseIdentifier: "cell")
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
}

extension MainPageView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainPostCell
        cell.selectionStyle = .none
        let photos = self.photos[indexPath.row]
        cell.setupCell(photos)
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
