//
//  DiffableViewModel.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/25.
//

import Foundation

import RxSwift

enum SearchError: Error {
    case noPhoto
    case serverError
}

class DiffableViewModel {
    
     var photoList = PublishSubject<SearchPhoto>()
    
    func requestSearchPhoto(query: String) {
        APIService.searchPhoto(query: query) {[weak self] photo, statusCode, error in
            guard let statusCode = statusCode, statusCode == 200 else {
                self?.photoList.onError(SearchError.serverError)
                return
            }
            
            guard let photo = photo else {
                self?.photoList.onError(SearchError.noPhoto)
                return }
            self?.photoList.onNext(photo)
        }
    }
    
}

