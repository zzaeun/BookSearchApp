import UIKit
import SnapKit

// 검색 탭 뷰
class SearchViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var searchResults: [Book] = []
    
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
        collectionView.delegate = self
    }
    
    private func fetchBooks(keyword: String) {
        let apiKey = "eb78786cfaab76e97ad0fed4f145f8e4"
        guard let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://dapi.kakao.com/v3/search/book?query=\(query)") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error:", error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code:", httpResponse.statusCode)
            }
            guard let data = data else { return }

            // 응답 raw JSON 확인
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON:", jsonString)
            }
            do {
                let decoded = try JSONDecoder().decode(BookResponse.self, from: data)
                self.searchResults = decoded.documents
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(integer: Section.searchResults.rawValue))
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
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
            cell.searchBar.delegate = self
            return cell
            
        case .searchResults:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
            let book = searchResults[indexPath.item]
            let authors = book.authors.joined(separator: ", ")
            let price = "\(book.price)원"
            cell.configure(with: book.title, author: authors, price: price)
            cell.backgroundColor = .systemBackground
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

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty else { return }
        fetchBooks(keyword: keyword)
    }
}

// cell 누르면 책 상세 정보 sheet 띄우기
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 검색 결과 섹션의 셀만 반응하게
        guard Section.allCases[indexPath.section] == .searchResults else { return }
            
        // 선택된 셀에 해당하는 책 데이터 가져오기
        let selectedBook = searchResults[indexPath.item]
        
        // BookDetailVC 인스턴스 생성 및 데이터 전달
        let bookDetailVC = BookDetailViewController()
        bookDetailVC.book = selectedBook
        
        // Sheet 형태로 띄우게 설정
        bookDetailVC.modalPresentationStyle = .pageSheet
        
        // Sheet로 띄우기
        present(bookDetailVC, animated: true)
    }
}
