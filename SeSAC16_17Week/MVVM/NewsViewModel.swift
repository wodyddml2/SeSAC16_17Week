//
//  NewsViewModel.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/25.
//
import Foundation
import RxSwift

class NewsViewModel {
    
    var pageNumber = BehaviorSubject(value: "3000")
    
    var sample = BehaviorSubject(value: News.items)
    
    func changePageNumberFormat(_ text: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else { return }
        let result = numberFormatter.string(for: number)!
        pageNumber.onNext(result) 
    }
    
    func resetSample() {
        sample.onNext([])
    }
    
    func loadSample() {
        sample.onNext(News.items)
    }
}
