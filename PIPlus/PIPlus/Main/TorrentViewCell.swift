//
//  TorrentViewCell.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 10. 27..
//

import Foundation
import UIKit

struct TorrentViewCellState {
    let title: String
    let date: String
    let size: String
}

class TorrentViewCell: UICollectionViewCell {
    
    @IBOutlet private var widthConstraint: NSLayoutConstraint! {
        didSet {
            widthConstraint.isActive = false
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    private var state: TorrentViewCellState? {
        didSet {
            guard let state = state else { return }
            
            renderState(state)
        }
    }
    
    var width: CGFloat? = nil {
         didSet {
             guard let width = width else {
                 return
             }
            widthConstraint.isActive = true
            widthConstraint.constant = width
         }
     }
    
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
}
