//
//  ResultTableViewController.swift
//  GitHubClient
//
//  Created by Павел on 15.10.2020.
//

import UIKit

class ResultTableViewController: UIViewController {
    
    private var repoArray: [Repos.Repo]?
    
    private lazy var reposNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Repositories found: \(repoArray?.count ?? 0)"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: String(describing: ResultTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(repoArray: [Repos.Repo]) {
        super.init(nibName: nil, bundle: nil)
        
        self.repoArray = repoArray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.5949709415, green: 0.9076359868, blue: 0.4050972462, alpha: 1)
        addSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupLayout()
    }
    
    private func addSubviews() {
        view.addSubview(reposNumberLabel)
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            reposNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            reposNumberLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            reposNumberLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: reposNumberLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}

// MARK: - UITableViewDataSource

extension ResultTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let repoArray = repoArray else { return 1 }
        
        return repoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ResultTableViewCell.self), for: indexPath) as? ResultTableViewCell,
           let repoArray = repoArray {
            cell.repo = repoArray[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }

}

//MARK: - Delegate

extension ResultTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let url = repoArray?[indexPath.row].url else {
            print(type(of: self), #function, "Can't make url")
            return
        }
        let webViewController = WKWebViewController(url: url)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
}
