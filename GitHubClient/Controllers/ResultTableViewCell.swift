//
//  ResultTableViewCell.swift
//  GitHubClient
//
//  Created by Павел on 15.10.2020.
//

import UIKit
import Kingfisher

class ResultTableViewCell: UITableViewCell {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    private var userLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        
        // Настроим сжимание текста для того, чтобы максимально вписаться в ширину.
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        
        return label
    }()
    
    private var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var repo: Repo? {
        didSet {
            guard let repo = repo else { return }
            titleLabel.text = repo.title
            detailsLabel.text = repo.details
            userLabel.text = repo.user
            let url = URL(string: repo.avatarURL)
            avatarView.kf.setImage(with: url)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
    
    private func setupLayout() {
        [titleLabel,
         detailsLabel,
         userLabel,
         avatarView]
            .forEach {
                contentView.addSubview($0)
                $0.toAutoLayout()
            }
        
        let avatarWidth = contentView.frame.width * 0.2
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: userLabel.leadingAnchor, constant: -5),

            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            detailsLabel.trailingAnchor.constraint(equalTo: userLabel.leadingAnchor, constant: -5),
            detailsLabel.bottomAnchor.constraint(lessThanOrEqualTo: avatarView.bottomAnchor),

            userLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            userLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            userLabel.widthAnchor.constraint(equalToConstant: avatarWidth),

            avatarView.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 5),
            avatarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            avatarView.widthAnchor.constraint(equalToConstant: avatarWidth),
            avatarView.heightAnchor.constraint(equalToConstant: avatarWidth),
            avatarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = avatarWidth / 2
    }
    
}


extension UIView {
    
    func toAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
