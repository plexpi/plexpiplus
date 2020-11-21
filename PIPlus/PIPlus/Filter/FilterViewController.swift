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

    private let resolver: MainModule = MainModuleResolver.shared

    private lazy var presenter: FilterViewPresenter = {
        return resolver.resolveFilterViewPresenter(view: self)
    }()
//
    var delegate: FilterViewControllerDelegate?
    
    private lazy var stackview: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        stackView.addArrangedSubview(typeFilter)
        stackView.addArrangedSubview(languageFilter)
        return stackView
    }()
    
    private lazy var typeFilter: FilterCategoryView = {
        let typeFilter = FilterCategoryView()
        typeFilter.translatesAutoresizingMaskIntoConstraints = false
        typeFilter.delegate = self
        typeFilter.title = "Type"
        typeFilter.appendItem(.image(UIImage(systemName: "tv")!))
        typeFilter.appendItem(.image(UIImage(systemName: "film")!))
        return typeFilter
    }()
    
    private lazy var languageFilter: FilterCategoryView = {
        let languageFilter = FilterCategoryView()
        languageFilter.translatesAutoresizingMaskIntoConstraints = false
        languageFilter.delegate = self
        languageFilter.title = "Language"
        languageFilter.appendItem(.text("en"))
        languageFilter.appendItem(.text("hu"))
        return languageFilter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(stopBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButtonTapped(_:)))
        setupViews()
        presenter.loadState()
    }
    
    private func setupViews() {
        view.addSubview(stackview)
        NSLayoutConstraint.activate([
            stackview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackview.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            stackview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackview.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
        ])
    }
    
    
    
    @objc func stopBarButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @objc func doneBarButtonTapped(_ sender: Any) {
        presenter.persistState()
        delegate?.searchParametersChanged()
        dismiss(animated: true, completion: nil)
    }

    func render(_ state: FilterViewState) {
        DispatchQueue.main.async {
            self.setCategory(state.category)
            self.setLanguage(state.language)
        }
    }

    func setCategory(_ category: FilterViewState.Category) {
        guard let type = (typeIndexMap.first { $0.value == category }) else { return }

        typeFilter.selectedIndex = type.key
    }

    func setLanguage(_ language: FilterViewState.Language) {
        guard let language = (languageIndexMap.first { $0.value == language }) else { return }

        languageFilter.selectedIndex = language.key
    }
}

extension FilterViewController: FilterCategoryViewDelegate {
    func valueChanged(filterCategoryView: FilterCategoryView) {
        switch filterCategoryView {
        case typeFilter:
            presenter.setCategory(typeIndexMap[typeFilter.selectedIndex!]!)
        case languageFilter:
            presenter.setLanguage(languageIndexMap[languageFilter.selectedIndex!]!)
        default:
            break
        }
    }
}
