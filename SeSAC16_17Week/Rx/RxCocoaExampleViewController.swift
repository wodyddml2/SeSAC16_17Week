//
//  RxCocoaExampleViewController.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/25.
//

import UIKit

import RxCocoa
import RxSwift

class RxCocoaExampleViewController: UIViewController {

    
    @IBOutlet weak var simpleTableView: UITableView!
    
    @IBOutlet weak var simplePickerView: UIPickerView!
    
    @IBOutlet weak var simpleSwitch: UISwitch!
    
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    
    var disposeBag = DisposeBag()
  
    var nickname = Observable.just("just do it")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickname
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        simpleLabel.numberOfLines = 2
//        setTableView()
//        setPickerView()
//        setSwitch()
//        setSign()
//
//        setOperator()
        
        setExample()
    }
    
    // viewcontroller deinit 되면, 알아서 disposed도 동작한다.
    // 다만 rootviewcontroller인 경우는 deinit이 안되기때문에 무한한 시퀀스 같은 경우 특정 시점에서 dispose를 해줘야한다.
    deinit {
        print("deinit")
    }
   
    func setExample() {
      

    }
    
    func setOperator() {
        
//        Observable.repeatElement("j") // Infinite Observable Sequence
//            .take(5) // Finite Observable Sequence
//            .subscribe { value in
//                print("repeat - \(value)")
//            } onError: { error in
//                print("repeat - \(error)")
//            } onCompleted: {
//                print("repeat completed")
//            } onDisposed: {
//                print("repeat disposed")
//            }
//            .disposed(by: disposeBag) // complete가 끝난 후 메모리가 남아있을 필요가 없는데 그때 리소스를 정리하기 위한 개체 (ex. deinit)
        
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.of(itemsA, itemsB) // just랑 다른 점은 객체가 여러개가 들어갈 수 있다.
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.from(itemsA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)

//        let intervalObservable2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//            .subscribe { value in
//                print("interval - \(value)")
//            } onError: { error in
//                print("interval - \(error)")
//            } onCompleted: {
//                print("interval completed")
//            } onDisposed: {
//                print("interval disposed")
//            }
//            .disposed(by: disposeBag)
//
//        let intervalObservable3 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//            .subscribe { value in
//                print("interval - \(value)")
//            } onError: { error in
//                print("interval - \(error)")
//            } onCompleted: {
//                print("interval completed")
//            } onDisposed: {
//                print("interval disposed")
//            }
//            .disposed(by: disposeBag)
        // disposeBag : 리소스 해제 관리 -
            // 1. 시퀀스 끝날 때
            // 2. class deinit 자동 해제 (bind)
            // 3. dispose 직접 호출 -> dispose() : 구독하는 것마다 별도로 관리해야한다.
            // 4. disposeBag을 새롭게 할당하거나, nil을 전달.
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        // 리소스에 대한 참조 유지 역할을 해서 위의 인터벌이 끝난 후 deinit이 된다.
//            self.disposeBag = DisposeBag()
//        }

    }
    
    func setTableView() {
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
        .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map({ data in
                "\(data)를 클릭했습니다."
            })
            .bind(to: simpleLabel.rx.text)
//            .subscribe { value in
//                print(value)
//            } onError: { error in
//                print(error)
//            } onCompleted: {
//                print("completed")
//            } onDisposed: {
//                print("disposed")
//            } 무조건 선택이 가능하고 선택할 때 에러가 날 수 없는 UI적인 요소이기 떄문에 bind사용
            .disposed(by: disposeBag)

    }
    
    func setPickerView() {
        let items = Observable.just([
                "영화",
                "애니메이션",
                "드라마",
                "기타"
            ])
     
        items
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setSwitch() {
        Observable.of(false)
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    func setSign() {
        // ex. 텍1(Observable), 텍2(Observable) > 레이블(Observer, bind)
        // orEmpty: 빈 값일 시 내부적 처리, 옵셔널 처리~
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return "name은 \(value1)이고 email은 \(value2)입니다."
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        signName // UITextField
            .rx // Reactive
            .text // String?
            .orEmpty // String 데이터의 흐름 Stream
            .map { $0.count < 4 } // 문자의 갯수 Int < 4 Bool
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
            
        
        signButton.rx.tap
            .withUnretained(self) // weak self
            .subscribe(onNext: { vc, _ in
                vc.showAlert()
            })
            .disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "클릭", message: nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}

