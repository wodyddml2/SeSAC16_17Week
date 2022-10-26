import UIKit

import RxSwift
import RxCocoa

class DiffableViewController: UIViewController {
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var viewModel = DiffableViewModel()
    
    let disposeBag = DisposeBag()
    
    private var cellRegisteration: UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult>!
        
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        collectionView.collectionViewLayout = createLayout()
        
//        searchBar.delegate = self
        
        collectionView.delegate = self
        
        configureDataSource()

        bindData()
    }
    
    func bindData() {
        viewModel.photoList
            .withUnretained(self)
            .subscribe(onNext: { vc, photo in
            var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>() //인스턴스 처럼 생성
            snapshot.appendSections([0])//섹션 추가
            snapshot.appendItems(photo.results)//아이템 추가
            vc.dataSource.apply(snapshot)
        }, onError: { error in
            print("=====error: \(error)")
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        })
        .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { (vc, value) in
                vc.viewModel.requestSearchPhoto(query: value)
            }
            .disposed(by: disposeBag)
    }
    
    
}

extension DiffableViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                    
    }
    
}

//extension DiffableViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        viewModel.requestSearchPhoto(query: searchBar.text!)
//
//    }
//
//}

extension DiffableViewController {

    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDataSource() {
        cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            
            content.text = "\(itemIdentifier.likes)"
            
            // String -> URL -> Data -> Image
            DispatchQueue.global().async {
                let url = URL(string: itemIdentifier.urls.thumb)! //String -> URL
                let data = try? Data(contentsOf: url) //URL -> Data
                
                DispatchQueue.main.async {
                    content.image = UIImage(data: data!) //Data를 기반으로 Image 표현
                    cell.contentConfiguration = content //main에서 담아줘야한다!
                }
            }
                        
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.strokeWidth = 2
            backgroundConfig.strokeColor = .brown
            cell.backgroundConfiguration = backgroundConfig
            
            
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegisteration, for: indexPath, item: itemIdentifier)
            return cell
        })
    
    }
}
