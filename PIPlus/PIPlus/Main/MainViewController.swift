//
//  ViewController.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 10. 25..
//

import UIKit
import TorrentSearch
import TorrentDownloader

class MainViewController: UIViewController, MainView {
    private lazy var searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.addArrangedSubview(searchTextField)
        stackView.addArrangedSubview(filterStateView)
        return stackView
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.placeholder = "Search for torrent"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var filterStateView: OFilterStateView = {
        let state = OFilterStateView()
        state.translatesAutoresizingMaskIntoConstraints = false
        let fGuesture = UITapGestureRecognizer(target: self, action: #selector(self.showFilter(sender:)))
        state.addGestureRecognizer(fGuesture)
        
        state.language = "en"
        state.typeImage = UIImage(systemName: "tv")!
        return state
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = ColumnFlowLayout()
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TorrentViewCell.self, forCellWithReuseIdentifier: "TorrentViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return collectionView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var presenter: MainViewPresenter!
    private var torrents = [TorrentViewCellState]()

    private var state: MainViewState? {
        didSet {
            guard let state = state else { return }

            self.renderState(state)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        presenter = MainModuleResolver.shared.resolveMainViewPresenter(view: self)

        setupView()
        search()
    }

    func render(_ state: MainViewState) {
        self.state = state
    }
    
    private func setupView() {
        let subViews = [searchStackView, collectionView, activityIndicator, errorLabel]
        subViews.forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            searchStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchStackView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -32),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.leadingAnchor.constraint(equalTo: searchStackView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: searchStackView.trailingAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        searchTextField.setContentHuggingPriority(filterStateView.contentHuggingPriority(for: .horizontal) - 1, for: .horizontal)
        searchTextField.setContentCompressionResistancePriority(filterStateView.contentCompressionResistancePriority(for: .horizontal) - 1, for: .horizontal)
        filterStateView.setContentCompressionResistancePriority(searchTextField.contentCompressionResistancePriority(for: .vertical) - 1, for: .vertical)
    }

    private func renderState(_ state: MainViewState) {
        switch state {
        case .loading:
            self.renderLoadingState()
        case .error(let message):
            self.renderErrorState(message)
        case .success(let successState):
            self.renderSuccessState(successState)
        case .downloading(let name):
            self.renderDownloading(name)
        }
    }

    private func renderLoadingState() {
        DispatchQueue.main.async {
            self.searchTextField.isEnabled = false
            self.activityIndicator.startAnimating()
            self.collectionView.isHidden = true
            self.errorLabel.isHidden = true
        }
    }

    private func renderErrorState(_ message: String) {
        DispatchQueue.main.async {
            self.searchTextField.isEnabled = true
            self.activityIndicator.stopAnimating()
            self.errorLabel.isHidden = false
            self.errorLabel.text = message
        }
    }

    private func renderSuccessState(_ successState: MainViewSuccessState) {
        DispatchQueue.main.async {
            self.searchTextField.isEnabled = true
            self.activityIndicator.stopAnimating()
            self.errorLabel.isHidden = true
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
            self.torrents = successState.torrents

            if successState.torrents.isEmpty {
                self.errorLabel.text = "No torrent found!"
                self.errorLabel.isHidden = false
            }
        }
    }

    private func renderDownloading(_ name: String) {
        DispatchQueue.main.async {
            self.searchTextField.isEnabled = true
            self.activityIndicator.stopAnimating()
            self.errorLabel.isHidden = true
            self.collectionView.isHidden = false
            self.showDownloadingAlert(name)
        }
    }

    private func showDownloadingAlert(_ name: String) {
        let alert = UIAlertController(title: "Downloading started",
                                      message: name,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Open Plex", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: "http://raspberrypi.local:32400/web/index.html")!, completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "Open Torrent", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: "http://raspberrypi.local:24560")!, completionHandler: nil)
        }))
        present(alert, animated: true)
    }

    private func search() {
        presenter.search(query: searchTextField.text!)
    }

    private func showActionSheet(for torrent: TorrentViewCellState) {
        let downloadMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let downloadAction = UIAlertAction(title: "Download", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.presenter.download(torrent)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        downloadMenu.addAction(downloadAction)
        downloadMenu.addAction(cancelAction)
        present(downloadMenu, animated: true, completion: nil)
    }

    @objc func showFilter(sender: AnyObject){
        let filterViewController = FilterViewController()
        let navigationController = UINavigationController()
        navigationController.viewControllers = [filterViewController]

        self.present(navigationController, animated: true, completion: nil)
    }
    
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        search()
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return torrents.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TorrentViewCell", for: indexPath) as! TorrentViewCell
        let torrent = torrents[indexPath.row]
        cell.render(torrent)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let torrent = torrents[indexPath.row]
        showActionSheet(for: torrent)
    }
}

//
//extension MainViewController: FilterViewControllerDelegate {
//    func searchParametersChanged() {
//        search()
//    }
//}

