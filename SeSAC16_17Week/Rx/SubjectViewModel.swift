//
//  SubjectViewModel.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/25.
//
import Foundation
import RxSwift

struct Contact {
    var name: String
    var age: Int
    var number: String
}

class SubjectViewModel {
    var contactData = [
        Contact(name: "JY", age: 26, number: "01010101010"),
        Contact(name: "EY", age: 25, number: "0102222222"),
        Contact(name: "JJ", age: 27, number: "010222233333")
    ]
    
    var list = PublishSubject<[Contact]>()
    
    func fetchData() {
        list.onNext(contactData)
    }
    
    func resetData() {
        list.onNext([])
    }
    
    func newData() {
        let new = Contact(name: "SSS", age: 1, number: "01010102020")
        contactData.append(new)
        list.onNext(contactData)
    }
    
    func filterData(query: String) {
        let result = query != "" ? contactData.filter { $0.name.contains(query)
        } : contactData
        
        list.onNext(result)
    }
}
