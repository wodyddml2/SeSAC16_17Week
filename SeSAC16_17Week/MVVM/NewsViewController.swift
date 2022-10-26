//
//  NewsViewController.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/25.
//

import UIKit

import RxSwift
import RxCocoa

class NewsViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    //1. ViewModel 가져오기
    
    var viewModel = NewsViewModel()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, News.NewsItem>!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierachy()
        configureDataSource()
        
        bindData()
      
    }
    
    @objc func numberTextFieldChanged() {
        guard let text = numberTextField.text else { return }
        viewModel.changePageNumberFormat(text)
    }
    
    
    func bindData() {
        //2.bind 구문을 이용해 VC에 보여주기
        viewModel.pageNumber
            .withUnretained(self)
            .bind(onNext: { vc, value in
            vc.numberTextField.text = value
        })
        .disposed(by: disposeBag)
        
        numberTextField.rx.text.orEmpty
            .withUnretained(self)
            .bind { vc, value in
                    vc.viewModel.changePageNumberFormat(value)
            }
            .disposed(by: disposeBag)
    
        
        //추가 되더라도, 제거 되더라도 snapshot이 찍힌다.
        viewModel.sample
            .withUnretained(self)
            .bind(onNext: { vc, item in
            var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
            snapshot.appendSections([0])
            snapshot.appendItems(item)
            vc.dataSource.apply(snapshot, animatingDifferences: false)
        })
        .disposed(by: disposeBag)
        
        loadButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.viewModel.loadSample()
            })
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.viewModel.resetSample()
            })
            .disposed(by: disposeBag)
    }
    
}

extension NewsViewController {

    func configureHierachy() { //addSubView, init, snapkit
        
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .lightGray
        
    }
    
    func configureDataSource() { //셀 등록하기
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.body
            
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
       
        
    }
    
    func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}
