import UIKit
import SnapKit

class BookDetailViewController: UIViewController {
    
    var book: Book?
    
    private let scrollView = UIScrollView() // 스크롤을 위한 스크롤 뷰
    private let contentView = UIView()      // 스크롤 뷰 내부의 컨텐츠 뷰
    
    // 제목, 저자, 가격 -> StackView (세로)
    private let textInfoStackView = UIStackView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let priceLabel = UILabel()
    
    
    // 책 이미지 + 정보(제목, 저자, 가격있는 stack)를 묶는 StackView (가로)
    private let topInfoStackView = UIStackView()
    private let bookImage = UIImageView()
    
    // 전체 내용을 담는 StackView (세로)
    private let mainStackView = UIStackView()
    
    private let contentTitleLabel = UILabel() // "책 소개"
    private let contentLabel = UILabel()      // 책 내용
    
    // Floating Button
    private let xButton = UIButton()
    private let addButton = UIButton()
    
    // 플로팅 버튼을 묶기 위한 StackView (가로)
    private let buttonStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupViews()
        setConstraints()
        configureUI()
    }
    
    private func setupViews() {

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainStackView)
        view.addSubview(buttonStackView)

        textInfoStackView.axis = .vertical
        textInfoStackView.spacing = 8
        textInfoStackView.alignment = .leading
        
        topInfoStackView.axis = .horizontal
        topInfoStackView.spacing = 15
        topInfoStackView.alignment = .top
        topInfoStackView.distribution = .fill
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 25
        mainStackView.alignment = .leading
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fill
        
        // 책 이미지
        bookImage.contentMode = .scaleAspectFit
        bookImage.backgroundColor = .secondarySystemBackground
        bookImage.layer.cornerRadius = 10
        bookImage.clipsToBounds = true
        
        // 제목
        titleLabel.font = .systemFont(ofSize: 22, weight: .heavy)
        titleLabel.numberOfLines = 0
        
        // 저자
        authorLabel.font = .systemFont(ofSize: 16, weight: .medium)
        authorLabel.textColor = .systemGray
        authorLabel.numberOfLines = 0
        
        // 가격
        priceLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        // 내용 제목
        contentTitleLabel.text = "책 소개"
        contentTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        // 내용 본문
        contentLabel.font = .systemFont(ofSize: 16, weight: .regular)
        contentLabel.textColor = .systemGray
        contentLabel.numberOfLines = 0
        
        // x 버튼
        xButton.setTitle("X", for: .normal)
        xButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        xButton.backgroundColor = .systemGray
        xButton.layer.cornerRadius = 20
        xButton.addTarget(self, action: #selector(dismissDetailView), for: .touchUpInside)
        
        // 담기 버튼
        addButton.setTitle("담기", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 20
        addButton.addTarget(self, action: #selector(addBookToList), for: .touchUpInside)
    }
    
    // 해당 책 데이터 받기
    private func configureUI() {
        guard let book = book else { return }
        
        titleLabel.text = book.title
        authorLabel.text = book.authors.joined(separator: ", ")
        priceLabel.text = "\(book.price)원"
        contentLabel.text = book.contents // 내용 없을 때 처리
        
        if let thumbnailURLString = book.thumbnail, let url = URL(string: thumbnailURLString) {
            // 비동기로 이미지 로드
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.bookImage.image = image
                    }
                }
            }
        } else {
            bookImage.image = UIImage(systemName: "book.closed.fill")
        }
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        [titleLabel, authorLabel, priceLabel].forEach { textInfoStackView.addArrangedSubview($0) }
        
        [bookImage, textInfoStackView].forEach { topInfoStackView.addArrangedSubview($0) }
                                                
        [topInfoStackView, contentTitleLabel, contentLabel].forEach { mainStackView.addArrangedSubview($0) }
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20))
        }
        
        bookImage.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(180)
        }
        
        xButton.snp.makeConstraints {
            $0.width.equalTo(90)
            $0.height.equalTo(75)
        }

        addButton.snp.makeConstraints {
            $0.width.equalTo(230)
            $0.height.equalTo(75)
        }
        
        [xButton, addButton].forEach { buttonStackView.addArrangedSubview($0) }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    @objc func dismissDetailView() {
        dismiss(animated: true)
    }
    
    @objc func addBookToList() {
        print("리스트에 추가하는 함수 구현합시다~")
        dismiss(animated: true)
    }
}
