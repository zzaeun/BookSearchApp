import UIKit
import CoreData
import SnapKit

class ContainBookViewController: UIViewController {
    
    // BookModelEntity 불러온 후 배열에 저장
    var containedBooks: [BookModelEntity] = []
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setupCollectionView()
        fetchBooks()
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBooks()
        collectionView.reloadData()
    }
    
    private func setUpNavigationBar() {
        let allDeleteButton = UIBarButtonItem(title: "전체 삭제", style: .plain, target: self, action: #selector(didTapAllDeleteButton))
        let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(didTappAddButton))
        
        navigationItem.leftBarButtonItem = allDeleteButton
        allDeleteButton.tintColor = .gray
        
        title = "담은 책"
        
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func didTapAllDeleteButton() {
        let allDeleteAlert = UIAlertController(title: "담은 책 전부를 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        allDeleteAlert.addAction(UIAlertAction(title: "아니오", style: .cancel))
        allDeleteAlert.addAction(UIAlertAction(title: "네", style: .destructive))
        
        present(allDeleteAlert, animated: true)
    }
    
    @objc func didTappAddButton() {
        print("추가")
    }
    
    // 저장된 데이터 불러오기
    private func fetchBooks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<BookModelEntity> = BookModelEntity.fetchRequest()
        
        do {
            self.containedBooks = try context.fetch(fetchRequest)
            
            print("불러온 책 개수: \(containedBooks.count)개")
        } catch let error as NSError {
            print("Core Data Fetch 실패: \(error), \(error.userInfo)")
        }
    }
    
    // collectionView 설정 함수
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return Self.containedBookContents()
        }
        // collectionView 생성
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        
        // cell 등록
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: "SearchResultCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    // CollectionView 생성
    static func containedBookContents() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 16
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)

        return section
    }
}

extension ContainBookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return containedBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else {
            return UICollectionViewCell()
        }
        let bookEntity = containedBooks[indexPath.item]
        
        // CoreData 엔티티에서 데이터 추출
        let title = bookEntity.title ?? "제목 없음"
        let authors = bookEntity.authors ?? "작가 정보 없음"
        let price = "\(bookEntity.price)원"
        
        cell.configure(with: title, author: authors, price: price)
        return cell
    }
}
