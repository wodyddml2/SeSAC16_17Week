//
//  NewsViewModel.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/25.
//
import Foundation
import RxSwift
import RxCocoa

class NewsViewModel {
    
    var pageNumber = BehaviorRelay(value: "3000")
    
//    var sample: BehaviorSubject<[News.NewsItem]> = BehaviorSubject(value: News.items)
    
    var sample = BehaviorRelay(value: News.items)
    
    func changePageNumberFormat(_ text: String) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else { return }
        let result = numberFormatter.string(for: number)!
        pageNumber.accept(result)
    }
    
    func resetSample() {
        sample.accept([])
    }
    
    func loadSample() {
        sample.accept(News.items)
    }
}
