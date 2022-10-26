//
//  SubscribeViewController.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/26.
//

import UIKit

import RxSwift
import RxCocoa

class SubscribeViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 버튼 탭 > 레이블: 안녕 반가워
        // 1.
        button.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.label.text = "안녕 반가워"
            })
            .disposed(by: disposeBag)
        
        
        // 2. 네트워크 통신이나 파일 다운로드 등 백그라운드 작업 - 메인 쓰레드로 바꿔주는
        button.rx.tap
            .observe(on: MainScheduler.instance) // 다른 쓰레드로 동작하게 변경
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.label.text = "안녕 반가워"
            })
            .disposed(by: disposeBag)
        
        // 3.
        button.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.label.text = "안녕 반가워"
            } // bind는 위의 observe를 사용할 필요가 없는게 자동으로 main thread에서 실행, 물론 error처리가 안돼서 에러 발생 시 런타임 에러
            .disposed(by: disposeBag)
        
        // 4. operator로 데이터의 stream을 조작
        button.rx.tap
            .map {"안녕 반가워"}
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        // 5. driver traits: bind + stream 공유(리소스 낭비 방지, share())
        button.rx.tap
            .map {"안녕 반가워"}
            .asDriver(onErrorJustReturn: "")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
    }
    

}
