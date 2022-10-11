//
//  FavouriteCell.swift
//  UnsplashAppIOS
//
//  Created by Артем Соловьев on 10.10.2022.
//

import UIKit

class FavouriteCell: UITableViewCell {
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemIndigo
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private lazy var postImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configureCell() {
        addSubView()
        setupConstraints()
    }
    
    private func addSubView() {
        self.contentView.addSubview(mainView)
        self.mainView.addSubview(postImage)
        self.mainView.addSubview(userStackView)
    }
    
    private func setupConstraints() {
        let constraints = [
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainView.heightAnchor.constraint(equalToConstant: 320),
            
            postImage.topAnchor.constraint(equalTo: mainView.topAnchor),
            postImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            postImage.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            postImage.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.5),
            
            userStackView.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 65),
            userStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 15),
            userStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -15),
            
            userIcon.heightAnchor.constraint(equalToConstant: 40),
            userIcon.widthAnchor.constraint(equalToConstant: 40),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupCell(_ data: Photos) {
        let url = URL(string: data.urls?.small ?? "")
        guard let url = url else { return }
        let dataPhoto = try? Data(contentsOf: url)
        guard let dataPhoto = dataPhoto else { return }
        
        postImage.image = UIImage(data: dataPhoto)
        userLabel.text = data.user?.username
    }
}

