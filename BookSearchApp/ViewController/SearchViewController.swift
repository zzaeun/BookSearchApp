import UIKit
import SnapKit

// 검색 탭 뷰
class SearchViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    // 더미 데이터
    private let searchResults = [
        ("책 먹는 여우", "프란치스카비어만", "14,000원"),
        ("아몬드", "손원평", "18,000원"),
        ("소년이 온다", "한강", "23,000원")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "검색"
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        // Compositional Layout 정의
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch Section.allCases[sectionIndex] {
            case .searchBar:
                return Self.createSearchBarSection()
            case .searchResults:
                return Self.createResultsSection()
            }
        }
        
        // 컬렉션뷰 생성
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 셀 & 헤더 등록
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: "SearchCell")
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: "SearchResultCell")
        collectionView.register(ResultHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,withReuseIdentifier: ResultHeaderView.identifier
        )
        
        // 데이터소스 연결
        collectionView.dataSource = self
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section.allCases[indexPath.section] {
        case .searchBar:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
            return cell
            
        case .searchResults:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
            let (title, detail, price) = searchResults[indexPath.item]
            cell.configure(with: title, bookDetail: detail, price: price)
            cell.backgroundColor = .secondarySystemBackground
            cell.layer.cornerRadius = 10
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section.allCases[section] {
        case .searchBar:
            return 1
        case .searchResults:
            return searchResults.count
        }
    }
    
    // 헤더 설정
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        switch Section.allCases[indexPath.section] {
        case .searchBar:
            return UICollectionReusableView()
        case .searchResults:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ResultHeaderView.identifier, for: indexPath
            ) as! ResultHeaderView
            header.title.text = "검색 결과"
            return header
        }
    }
}

extension SearchViewController {
    // 섹션 레이아웃
    static func createSearchBarSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        return section
    }
    
    static func createResultsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 16
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
        
        // 헤더 추가
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        return section
    }
}
    // 추후 검색 결과 리스트의 아이템을 탭하면 modalSheet 띄우게 할 것
//    @objc func tapButton() {
//        let bookDetailVC = BookDetailViewController()
//        bookDetailVC.modalPresentationStyle = .pageSheet
//        self.present(bookDetailVC, animated: true)
//    }
