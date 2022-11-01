//
//  SubjectViewModel.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/25.
//
import Foundation
import RxSwift
import RxCocoa

// assosiated type
protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

struct Contact {
    var name: String
    var age: Int
    var number: String
}

class SubjectViewModel: ViewModelType {
    var contactData = [
        Contact(name: "JY", age: 26, number: "01010101010"),
        Contact(name: "EY", age: 25, number: "0102222222"),
        Contact(name: "JJ", age: 27, number: "010222233333")
    ]
    
    var list = PublishRelay<[Contact]>()
    
    func fetchData() {
        list.accept(contactData)
    }
    
    func resetData() {
        list.accept([])
    }
    
    func newData() {
        let new = Contact(name: "SSS", age: 1, number: "01010102020")
        contactData.append(new)
        list.accept(contactData)
    }
    
    func filterData(query: String) {
        let result = query != "" ? contactData.filter { $0.name.contains(query)
        } : contactData
        
        list.accept(result)
    }
    
    struct Input {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        let searchText: ControlProperty<String?>
    }
    
    struct Output {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        let list: Driver<[Contact]>
        let searchText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let list = list.asDriver(onErrorJustReturn: [])
        
        let search = input.searchText
            .orEmpty
            .debounce(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance) // 실시간 검색을 하는 문제로 API 호출을 줄이기 위해 입력에 시간을 줌.
            .distinctUntilChanged() // 같은 값을 받지 않음(낼 보완)
        
        return Output(addTap: input.addTap, resetTap: input.resetTap, newTap: input.newTap, list: list, searchText: search)
    }
}
