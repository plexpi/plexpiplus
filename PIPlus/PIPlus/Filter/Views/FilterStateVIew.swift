//
//  FilterStateVIew.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 17..
//

import Foundation
import UIKit

class FilterStateView: UIView {
    
    var typeImage: UIImage? {
        get {
            return typeImageView.image
        }
        set {
            typeImageView.image = newValue
        }
    }
    
    var language: String? {
        get {
            return languageLabel.text
        }
        set {
            languageLabel.text = newValue
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.addArrangedSubview(typeImageView)
        stackView.addArrangedSubview(languageLabel)
        return stackView
    }()
    
    private lazy var typeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        return imageView
    }()
    
    private lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
