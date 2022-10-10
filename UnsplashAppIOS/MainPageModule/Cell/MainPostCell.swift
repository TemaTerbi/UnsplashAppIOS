//
//  MainPostCell.swift
//  UnsplashAppIOS
//
//  Created by Артем Соловьев on 10.10.2022.
//

import UIKit

class MainPostCell: UITableViewCell {
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemIndigo
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var postImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
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
    }
    
    private func setupConstraints() {
        let constraints = [
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainView.heightAnchor.constraint(equalToConstant: 320),
            
            postImage.topAnchor.constraint(equalTo: mainView.topAnchor),
            postImage.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            postImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            postImage.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupCell(_ data: Photos) {
        let url = URL(string: data.urls?.small ?? "")
        guard let url = url else { return }
        let data = try? Data(contentsOf: url)
        guard let data = data else { return }
        
        DispatchQueue.main.async {
            self.postImage.image = UIImage(data: data)
        }
    }
}
