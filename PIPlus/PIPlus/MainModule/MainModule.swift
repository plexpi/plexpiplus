//
//  MainModule.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 04..
//

import Foundation

protocol MainModule {
    func resolveMainViewPresenter(view: MainView) -> MainViewPresenter
    func resolveFilterViewPresenter(view: OFilterView) -> FilterViewPresenter
}
