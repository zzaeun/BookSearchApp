import Foundation

struct BookResponse: Decodable {
    let documents: [Book]
}

struct Book: Decodable {
    let title: String
    let authors: [String]
    let price: Int
    let thumbnail: String?
    let contents: String
}
