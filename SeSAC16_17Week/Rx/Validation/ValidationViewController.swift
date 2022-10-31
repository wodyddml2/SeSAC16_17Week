//
//  ValidationViewController.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/27.
//

import UIKit

import RxSwift
import RxCocoa

class ValidationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var stepButton: UIButton!
    @IBOutlet weak var validationLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    let viewModel = ValidationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
//        observableVSSubject()
    }
   
}

extension ValidationViewController {
    func bind() {
        
        viewModel.validText
            .asDriver()
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = nameTextField.rx.text
            .orEmpty
            .map { $0.count >= 8 }
            .share() // Subject, Relay에 내부적으로 구성

        validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)

        validation
            .withUnretained(self)
            .bind { vc, value in
                let color: UIColor = value ? .systemPink : .systemGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        // Stream == Sequence : 데이터의 흐름
     
        
        stepButton.rx.tap
            .bind(onNext: { _ in
                print("next")
            })
            .disposed(by: disposeBag)

    }
    
    func observableVSSubject() {
        
        let testA = stepButton.rx.tap
            .map {"안녕하세요"}
            .asDriver(onErrorJustReturn: "")
//            .share()
            
        testA
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(stepButton.rx.title())
            .disposed(by: disposeBag)
        
        // 1:1 관계라 세개의 리소스를 사용
        let sampleInt = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            
            return Disposables.create()
        }
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        // 1:3 관계라서 리소스를 하나를 공유(stream 공유)해 사용하기에 결과가 같은 값이 나옴
        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 1...100))
        
        subjectInt.subscribe { value in
            print("subject: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subject: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subject: \(value)")
        }
        .disposed(by: disposeBag)
    }
}
