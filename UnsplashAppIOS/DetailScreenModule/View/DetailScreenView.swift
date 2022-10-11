//
//  DetailScreenView.swift
//  UnsplashAppIOS
//
//  Created by Артем Соловьев on 11.10.2022.
//

import UIKit

class DetailScreenView: UIViewController {
    
    var userName = ""
    var date = ""
    var locate = ""
    var countOfDownloads = 0
    var url = ""
    var id = ""
    
    var currentElement: Photos?
    
    var isFav = false
    var oneLoop = false
    
    let viewModel = DetaiScreenViewModel()
    
    private lazy var detailImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .white
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var userIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "person.fill")
        image.clipsToBounds = true
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = userName
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(userIcon)
        stackView.addArrangedSubview(userLabel)
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var dateIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "calendar.circle.fill")
        image.clipsToBounds = true
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = date
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(dateIcon)
        stackView.addArrangedSubview(dateLabel)
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var locateIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "location.fill")
        image.clipsToBounds = true
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var locateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = locate
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(locateIcon)
        stackView.addArrangedSubview(locateLabel)
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var downloadsIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "square.and.arrow.down.fill")
        image.clipsToBounds = true
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var downloadsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = String(countOfDownloads)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var downloadsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(downloadsIcon)
        stackView.addArrangedSubview(downloadsLabel)
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.addArrangedSubview(userStackView)
        stackView.addArrangedSubview(dateStackView)
        stackView.addArrangedSubview(locateStackView)
        stackView.addArrangedSubview(downloadsStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToFavourite), for: .touchUpInside)
        button.setTitle("Добавить в избранное", for: .normal)
        button.backgroundColor = .systemGreen
        return button
    }()
    
    private lazy var favouriteButtonTwo: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(alertShow), for: .touchUpInside)
        button.backgroundColor = .systemRed
        return button
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.currentElement = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkInFavourite()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemIndigo
        
        addSubView()
        setupConstraints()
        
        viewModel.getDetail()
        
        favouriteButtonTwo.isHidden = true
        
        viewModel.download.bind { download in
            self.downloadsLabel.text = String(download)
        }
        
        setPhoto()
    }
    
    private func setupFunction() {
//        self.isFav ? favouriteButton.addTarget(self, action: #selector(alertShow), for: .touchUpInside) : favouriteButton.addTarget(self, action: #selector(addToFavourite), for: .touchUpInside)
        
        if isFav {
            favouriteButton.isHidden = true
            favouriteButtonTwo.isHidden = false
        }
    }
    
    private func setPhoto() {
        let url = URL(string: url)
        guard let url = url else { return }
        let data = try? Data(contentsOf: url)
        guard let data = data else { return }
        
        DispatchQueue.main.async {
            self.detailImage.image = UIImage(data: data)
        }
    }
    
    private func addSubView() {
        view.addSubview(detailImage)
        view.addSubview(descriptionStackView)
        view.addSubview(favouriteButton)
        view.addSubview(favouriteButtonTwo)
    }
    
    private func setupConstraints() {
        let constraints = [
            detailImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            detailImage.heightAnchor.constraint(equalToConstant: 250),
            detailImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            descriptionStackView.topAnchor.constraint(equalTo: detailImage.bottomAnchor, constant: 30),
            descriptionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            userIcon.heightAnchor.constraint(equalToConstant: 40),
            userIcon.widthAnchor.constraint(equalToConstant: 40),
            
            dateIcon.heightAnchor.constraint(equalToConstant: 40),
            dateIcon.widthAnchor.constraint(equalToConstant: 40),
            
            locateIcon.heightAnchor.constraint(equalToConstant: 40),
            locateIcon.widthAnchor.constraint(equalToConstant: 40),
            
            downloadsIcon.heightAnchor.constraint(equalToConstant: 40),
            downloadsIcon.widthAnchor.constraint(equalToConstant: 40),
            
            favouriteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            favouriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            favouriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            favouriteButton.heightAnchor.constraint(equalToConstant: 65),
            
            favouriteButtonTwo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            favouriteButtonTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            favouriteButtonTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            favouriteButtonTwo.heightAnchor.constraint(equalToConstant: 65),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func checkInFavourite() {
        self.isFav = false
        
        let favData = UserDefaults.standard.data(forKey: "favPhotos")
        guard let favData = favData else { return }
        let favArray = try! JSONDecoder().decode([Photos].self, from: favData)
        
        if favArray.isEmpty {
            self.isFav = false
            self.setupFunction()
        } else {
            for el in favArray {
                if el.id == self.currentElement?.id ?? "" {
                    DispatchQueue.main.async {
                        self.favouriteButtonTwo.setTitle("Удалить из избранного", for: .normal)
                        self.favouriteButton.backgroundColor = .systemRed
                        self.isFav = true
                        self.setupFunction()
                    }
                    break
                } else {
                    DispatchQueue.main.async {
                        self.favouriteButton.setTitle("Добавить в избранное", for: .normal)
                        self.favouriteButton.backgroundColor = .systemGreen
                        self.isFav = false
                        self.setupFunction()
                    }
                    continue
                }
            }
        }
    }
    
    @objc private func alertShow() {
        let alert = UIAlertController(title: "Удаление из избранного", message: "Вы действительно хотите удалить этот пост из избранного?", preferredStyle: .alert)
        
        let alertOk = UIAlertAction(title: "Ok", style: .destructive) { _ in
            self.deleteFavourite()
        }
        
        let alertCancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in
        }
        
        alert.addAction(alertOk)
        alert.addAction(alertCancel)
        self.present(alert, animated: true)
    }
    
    @objc private func addToFavourite() {
        let favData = UserDefaults.standard.data(forKey: "favPhotos")
        guard let favData = favData else { return }
        var favArray = try! JSONDecoder().decode([Photos].self, from: favData)
        favArray.append(currentElement!)
        let favDataa = try! JSONEncoder().encode(favArray)
        UserDefaults.standard.set(favDataa, forKey: "favPhotos")
        NotificationCenter.default.post(name: NSNotification.Name("favPhotos"), object: nil)
        self.navigationController?.popViewController(animated:  true)
    }
    
    @objc private func deleteFavourite() {
        
        let favData = UserDefaults.standard.data(forKey: "favPhotos")
        guard let favData = favData else { return }
        var favArray = try! JSONDecoder().decode([Photos].self, from: favData)
        
        favArray.removeAll { photos in
            photos.id == currentElement?.id
        }
        
        let favDataa = try! JSONEncoder().encode(favArray)
        UserDefaults.standard.set(favDataa, forKey: "favPhotos")
        NotificationCenter.default.post(name: NSNotification.Name("favPhotos"), object: nil)
        self.navigationController?.popViewController(animated:  true)
    }
}
