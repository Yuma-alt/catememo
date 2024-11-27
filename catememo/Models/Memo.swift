import Foundation

struct Memo: Identifiable, Codable {
    var id = UUID()
    var text: String
    var categoryId: UUID?
    var date: Date = Date()
}
