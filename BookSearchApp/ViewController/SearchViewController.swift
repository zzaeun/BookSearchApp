import UIKit
import SnapKit

// 검색 탭 뷰
class SearchViewController: UIViewController {
    
    private let searchBook = UISearchBar()
    private let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
    }

    private func configureUI() {
        searchBook.placeholder = "책 이름을 검색해주세요"
        searchBook.layer.cornerRadius = 10
        searchBook.backgroundImage = UIImage()  // 경계선 안보이게 하려고
        
        button.setTitle("button", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    private func setConstraints() {
        [searchBook, button].forEach { view.addSubview($0) }
        
        searchBook.snp.makeConstraints {
            $0.width.equalTo(380)
            $0.height.equalTo(30)
            $0.center.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.center.equalToSuperview()
        }
    }
    
    // 추후 검색 결과 리스트의 아이템을 탭하면 modalSheet 띄우게 할 것
    @objc func tapButton() {
        let bookDetailVC = BookDetailViewController()
        bookDetailVC.modalPresentationStyle = .pageSheet
        self.present(bookDetailVC, animated: true)
    }
}
