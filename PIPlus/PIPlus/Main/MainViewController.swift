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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    private var presenter: MainViewPresenter!
    private var torrents = [Torrent]()
    
    private var state: MainViewState? {
        didSet {
            guard let state = state else { return }
            
            self.renderState(state)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainViewPresenter(view: self,
                                      torrentSearch: CustomTorrentSearch(),
                                      torrentDownloader: PITorrentDownloader(),
                                      filterManager: UserDefaultsFilterManager())
        
        setupView()
        search()
    }
    
    func render(_ state: MainViewState) {
        self.state = state
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let filterVC as FilterViewController:
            filterVC.delegate = self
        default:
            return
        }
    }
    
    private func setupView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.searchTextField.delegate = self
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
    
    private func showActionSheet(for torrent: Torrent) {
        let downloadMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let downloadAction = UIAlertAction(title: "Download", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.presenter.download(torrent)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        downloadMenu.addAction(downloadAction)
        downloadMenu.addAction(cancelAction)
        present(downloadMenu, animated: true, completion: nil)
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
        let state = TorrentViewCellState(
            title: torrent.title,
            date: torrent.date,
            size: torrent.size
        )
        cell.render(state)
        cell.width = collectionView.bounds.width
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let torrent = torrents[indexPath.row]
        showActionSheet(for: torrent)
    }
}

extension MainViewController: FilterViewControllerDelegate {
    func searchParametersChanged() {
        search()
    }
}

