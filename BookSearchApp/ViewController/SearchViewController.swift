import UIKit
import CoreData
import SnapKit

protocol BookDetailDelegate: AnyObject {
    // 책 상세 뷰 보기만 해도 호출
    func bookDetailDidDismiss(viewBook: Book)
    // 담기 버튼 누르면 호출
    func bookDetailDidSelectSave(savedBook: Book)
}

// 검색 탭 뷰
class SearchViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var searchResults: [Book] = []
    
    // 최근 본 책 임시 데이터
    private var recentBooks: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "검색"
        
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchRecentBooksFromCoreData()
    }
    
    private func setupCollectionView() {
        // Compositional Layout 정의
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            
            let hasRecentBooks = !self.recentBooks.isEmpty
            let visibleSections = Section.visibleSections(hasRecentBooks: hasRecentBooks)
            
            guard sectionIndex < visibleSections.count else { return nil }
            let currentSection = visibleSections[sectionIndex]
            
            switch currentSection {
            case .searchBar:
                return Self.createSearchBarSection()
            case .recentBooks:
                return Self.createRecentBooksSection()
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
        
        // 검색 셀 등록
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: "SearchCell")
        
        // 검색 결과 셀 & 헤더 등록
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: "SearchResultCell")
        collectionView.register(ResultHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ResultHeaderView.identifier
        )
        
        // 최근 본 책 셀 & 헤더 등록
        collectionView.register(RecentBookCell.self, forCellWithReuseIdentifier: RecentBookCell.identifier)
        collectionView.register(RecentBookHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: RecentBookHeaderView.identifier)
        
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
                    let hasRecentBooks = !self.recentBooks.isEmpty
                    let visibleSections = Section.visibleSections(hasRecentBooks: hasRecentBooks)
                    
                    if let searchResultsIndex = visibleSections.firstIndex(of: .searchResults) {
                        self.collectionView.reloadSections(IndexSet(integer: searchResultsIndex))
                    } else {
                        self.collectionView.reloadData()
                    }
                
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
}

extension SearchViewController: BookDetailDelegate {
    // 상세 뷰 닫힐 때 호출
    func bookDetailDidDismiss(viewBook: Book) {
        // 최근 본 책에 저장
        self.saveRecentBookToCoreData(book: viewBook, isSaved: false)
        self.fetchRecentBooksFromCoreData()
    }
    // 담기 눌렀을 때 호출
    func bookDetailDidSelectSave(savedBook: Book) {
        self.saveRecentBookToCoreData(book: savedBook, isSaved: true)
        self.fetchRecentBooksFromCoreData()
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let hasRecentBooks = !recentBooks.isEmpty
        let visibleSections = Section.visibleSections(hasRecentBooks: hasRecentBooks)
        return visibleSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hasRecentBooks = !recentBooks.isEmpty
        let visibleSections = Section.visibleSections(hasRecentBooks: hasRecentBooks)
        let currentSection = visibleSections[indexPath.section]
        
        switch currentSection {
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
            
        case .recentBooks:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentBookCell.identifier, for: indexPath) as!
            RecentBookCell
            let book = recentBooks[indexPath.item]
            // 이미지 URL 받아오는
            cell.configure(with: book.thumbnail)
            cell.backgroundColor = .systemBackground
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let hasRecentBooks = !recentBooks.isEmpty
        let visibleSections = Section.visibleSections(hasRecentBooks: hasRecentBooks)
        let currentSection = visibleSections[section]
        
        switch currentSection {
        case .searchBar:
            return 1
        case .searchResults:
            return searchResults.count
        case .recentBooks:
            return recentBooks.count
        }
    }
    
    // 헤더 설정
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        let hasRecentBooks = !recentBooks.isEmpty
        let visibleSections = Section.visibleSections(hasRecentBooks: hasRecentBooks)
        let currentSection = visibleSections[indexPath.section]
        
        switch currentSection {
        case .searchBar:
            return UICollectionReusableView()
        
        case .searchResults:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ResultHeaderView.identifier, for: indexPath
            ) as! ResultHeaderView
            header.title.text = "검색 결과"
            return header
        
        case .recentBooks:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RecentBookHeaderView", for: indexPath
            ) as! RecentBookHeaderView
            header.title.text = "최근 본 책"
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 16
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
        
        // 헤더 추가
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    static func createRecentBooksSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(105), heightDimension: .absolute(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
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
        // 현재 보이는 섹션 목록을 가져옴
        let hasRecentBooks = !recentBooks.isEmpty
        let visibleSections = Section.visibleSections(hasRecentBooks: hasRecentBooks)
        
        // 선택된 indexPath.section이 어떤 Section인지 확인
        guard indexPath.section < visibleSections.count else { return }
        let currentSection = visibleSections[indexPath.section]
        
        // 검색 결과 섹션의 셀만 반응하게
        guard currentSection == .searchResults else { return }
            
        // 선택된 셀에 해당하는 책 데이터 가져오기
        let selectedBook = searchResults[indexPath.item]
        
        // BookDetailVC 인스턴스 생성 및 데이터 전달
        let bookDetailVC = BookDetailViewController()
        bookDetailVC.book = selectedBook
        
        bookDetailVC.delegate = self
        
        // Sheet 형태로 띄우게 설정
        bookDetailVC.modalPresentationStyle = .pageSheet
        
        // Sheet로 띄우기
        present(bookDetailVC, animated: true)
    }
}

// Core Data & RecentBooks
extension SearchViewController {
    // Core Data에서 최근 본 책 데이터를 불러와 recentBooks 배열에 할당
    private func fetchRecentBooksFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<BookModelEntity> = BookModelEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 10
        
        do {
            let savedBooks = try context.fetch(fetchRequest)
            
            self.recentBooks = savedBooks.compactMap { entity in
                // Core Data Entity를 Book 모델로 변환
                guard let title = entity.title,
                      let authorsString = entity.authors,
                      let contents = entity.contents else {
                    return nil
                }
                let price = Int(entity.price)
                let authors = authorsString.components(separatedBy: ", ")
                
                return Book(title: title, authors: authors, price: price, thumbnail: entity.thumbnail, contents: contents)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        } catch let error as NSError {
            print("CoreData 불러오기 실패")
        }
    }
    
    // 책을 Core Data에 저장 및 업데이트하는 메서드
    private func saveRecentBookToCoreData(book: Book, isSaved: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BookModelEntity> = BookModelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND authors == %@", book.title, book.authors.joined(separator: ", "))
        
        do {
            let results = try context.fetch(fetchRequest)
            let existingBook: BookModelEntity
            
            if let first = results.first {
                existingBook = first
            } else {
                existingBook = BookModelEntity(context: context)
                existingBook.title = book.title
                existingBook.authors = book.authors.joined(separator: ", ")
                existingBook.price = Int64(book.price)
                existingBook.thumbnail = book.thumbnail
                existingBook.contents = book.contents
            }
            
            if isSaved == true {
                existingBook.isSaved = true
            } else {
                if existingBook.isSaved != true {
                    existingBook.isSaved = false
                }
            }
            
            try context.save()
        } catch let error as NSError {
            print("Core Data 저장 실패")
        }
    }
}
