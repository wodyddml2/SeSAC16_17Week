//
//  SubscribeViewController.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/26.
//

import UIKit

import RxSwift
import RxCocoa
import RxAlamofire
import RxDataSources

class SubscribeViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(
      configureCell: { dataSource, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(item)"
        return cell
    })
    
    func testRxAlamofire() {
        // Success Error -> <Single>
        let url = "\(APIKey.searchURL)apple"
        request(.get, url, headers: ["Authorization": APIKey.authorization])
            .data()
            .decode(type: SearchPhoto.self, decoder: JSONDecoder())
            .subscribe(onNext: { value in
                print(value.results[0].urls.regular)
            })
            .disposed(by: disposeBag)
    }
    
    func testRxDataSource() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
          }
        
        Observable.just([
            SectionModel(model: "취", items: [1, 2, 3]),
            SectionModel(model: "뽀", items: [1, 2, 3]),
            SectionModel(model: "가..", items: [1, 2, 3])
        ])
        .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        testRxAlamofire()
        testRxDataSource()
        
        Observable.of(1,2,3,4,5,6,7,8,9,10)
            .skip(3)
            .filter { $0 % 2 == 0 }
            .debug()
            .map { $0 * 2 }
            .subscribe { value in
                print("===\(value)")
            }
            .disposed(by: disposeBag)
        

        
        
        
        
        
        
        
        

        // 버튼 탭 > 레이블: 안녕 반가워
        // 1.
        let sample = button.rx.tap
        
        
        sample
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
