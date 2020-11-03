//
//  FilterViewController.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 10. 26..
//

import Foundation
import UIKit

protocol FilterViewControllerDelegate {
    func searchParametersChanged()
}

class FilterViewController: UIViewController, FilterView {
    
    private let typeIndexMap: [Int: FilterViewState.Category] = [
        0: .series,
        1: .movies,
    ]
    
    private let languageIndexMap: [Int: FilterViewState.Language] = [
        0: .en,
        1: .hu,
    ]
    
    var delegate: FilterViewControllerDelegate?
    
    @IBAction func stopBarButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBarButtonTapped(_ sender: Any) {
        presenter.persistState()
        delegate?.searchParametersChanged()
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeSegmentedControl.addTarget(self, action: #selector(self.typeChanged(_:)), for:.valueChanged)
        languageSegmentedControl.addTarget(self, action: #selector(self.languageChanged(_:)), for:.valueChanged)
        presenter.loadState()
    }
    
    private lazy var presenter: FilterViewPresenter = {
        return FilterViewPresenter(view: self, filterManager: UserDefaultsFilterManager())
    }()
    
    @objc func typeChanged(_ sender: Any) {
        presenter.setCategory(typeIndexMap[typeSegmentedControl.selectedSegmentIndex]!)
    }
    
    @objc func languageChanged(_ sender: Any) {
        presenter.setLanguage(languageIndexMap[languageSegmentedControl.selectedSegmentIndex]!)
    }
    
    func render(_ state: FilterViewState) {
        DispatchQueue.main.async {
            self.setCategory(state.category)
            self.setLanguage(state.language)
        }
    }
    
    func setCategory(_ category: FilterViewState.Category) {
        guard let type = (typeIndexMap.first { $0.value == category }) else { return }
    
        typeSegmentedControl.selectedSegmentIndex = type.key
    }
    
    func setLanguage(_ language: FilterViewState.Language) {
        guard let language = (languageIndexMap.first { $0.value == language }) else { return }
    
        languageSegmentedControl.selectedSegmentIndex = language.key
    }
}
