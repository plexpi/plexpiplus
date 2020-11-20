//
//  TorrentViewCell.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 10. 27..
//

import Foundation
import UIKit

class TorrentViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private var widthConstraint: NSLayoutConstraint?
    
    // MARK: Views
    private lazy var outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(propertiesStackView)
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var propertiesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(sizeLabel)
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private var state: TorrentViewCellState? {
        didSet {
            guard let state = state else { return }
            
            renderState(state)
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func render(_ newState: TorrentViewCellState) {
        state = newState
    }
    
    func renderState(_ state: TorrentViewCellState) {
        DispatchQueue.main.async {
            self.titleLabel.text = state.title
            self.dateLabel.text = state.date
            self.sizeLabel.text = state.size
        }
    }
    
    // MARK: Private
    private func setupView() {
        contentView.addSubview(outerStackView)
        
        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        dateLabel.setContentHuggingPriority(sizeLabel.contentHuggingPriority(for: .horizontal) - 1, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(sizeLabel.contentCompressionResistancePriority(for: .horizontal) - 1, for: .horizontal)
    }
    
    var isHeightCalculated: Bool = false

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        //Exhibit A - We need to cache our calculation to prevent a crash.
        if !isHeightCalculated {
            setNeedsLayout()
            layoutIfNeeded()
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            newFrame.size.width = CGFloat(ceilf(Float(size.width)))
            layoutAttributes.frame = newFrame
            isHeightCalculated = true
        }
        return layoutAttributes
    }
}
