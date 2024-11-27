import SwiftUI

class MemoViewModel: ObservableObject {
    @Published var memos: [Memo] = []
    @Published var categories: [Category] = []
    @Published var isEditingMemo = false
    @Published var selectedCategoryId: UUID?

    init() {
        loadMemos()
        loadCategories()
    }

    func deleteMemo(at offsets: IndexSet) {
        memos.remove(atOffsets: offsets)
        saveMemos()
    }

    func getFirstLine(of text: String) -> String {
        return text.components(separatedBy: .newlines).first ?? text
    }

    func saveMemo(_ memo: Memo) {
        let trimmedText = memo.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedText.isEmpty {
            if let index = memos.firstIndex(where: { $0.id == memo.id }) {
                memos[index] = memo
            } else {
                memos.append(memo)
            }
            saveMemos()
        }
    }

    func addCategory(_ category: Category) {
        categories.append(category)
        saveCategories()
    }

    func deleteCategory(_ category: Category) {
        categories.removeAll { $0.id == category.id }
        saveCategories()

        for index in memos.indices {
            if memos[index].categoryId == category.id {
                memos[index].categoryId = nil
            }
        }
        saveMemos()

        if selectedCategoryId == category.id {
            selectedCategoryId = nil
        }
    }

    func updateCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            saveCategories()
        }
    }

    func saveMemos() {
        if let encoded = try? JSONEncoder().encode(memos) {
            UserDefaults.standard.set(encoded, forKey: "savedMemos")
        }
    }

    private func loadMemos() {
        if let savedMemos = UserDefaults.standard.data(forKey: "savedMemos"),
           let decodedMemos = try? JSONDecoder().decode([Memo].self, from: savedMemos) {
            memos = decodedMemos
        }
    }

    private func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: "savedCategories")
        }
    }

    private func loadCategories() {
        if let savedCategories = UserDefaults.standard.data(forKey: "savedCategories"),
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: savedCategories) {
                categories = decodedCategories
            }
    }
}
