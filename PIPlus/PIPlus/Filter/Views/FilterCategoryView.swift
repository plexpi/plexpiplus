import Foundation
import UIKit

enum FilterCategoryItem: Equatable {
    case text(String)
    case image(UIImage)
}

protocol FilterCategoryViewDelegate: class {
    func valueChanged(filterCategoryView: FilterCategoryView)
}

class FilterCategoryView: UIView {
    // MARK: - Properties
    weak var delegate: FilterCategoryViewDelegate?
    
    var title: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    var selectedIndex: Int? {
        get {
            return segment.selectedSegmentIndex
        }
        set {
            guard let index = newValue else { return }
            segment.selectedSegmentIndex = index
        }
    }
    
    // MARK: Views
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(segment)
        return stackView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title2)
        return label
    }()
    
    private lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        segment.addTarget(self, action: #selector(self.valueChanged(_:)), for:.valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    @objc func valueChanged(_ sender: Any) {
        delegate?.valueChanged(filterCategoryView: self)
    }
    
    func appendItem(_ item: FilterCategoryItem) {
        switch item {
        case .image(let image):
            segment.insertSegment(with: image, at: segment.numberOfSegments, animated: false)
        case .text(let text):
            segment.insertSegment(withTitle: text, at: segment.numberOfSegments, animated: false)
        }
    }
    
    // MARK: Private
    private func setupView() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
