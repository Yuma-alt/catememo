import SwiftUI

struct AddMemoView: View {
    @ObservedObject var viewModel: MemoViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var memoText: String = ""
    @State private var selectedCategoryId: UUID?
    @State private var showAlert = false
    var memo: Memo?

    var body: some View {
        NavigationView{
            VStack{
                Form {
                    Section(header: Text("Memo")) {
                        TextEditor(text: $memoText)
                            .frame(height: 400)
                    }
                    
                    Section(header: Text("Category")) {
                        Picker("Category", selection: $selectedCategoryId) {
                            Text("None").tag(UUID?.none)
                            ForEach(viewModel.categories) { category in
                                Text(category.name).tag(category.id as UUID?)
                            }
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        if !memoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            saveMemo()
                        } else {
                            showAlert = true
                        }
                    }) {
                        Text("Save")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(memo != nil ? "Edit Memo" : "Add Memo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveMemo()
                }
                .disabled(memoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .onAppear {
            if let memo = memo {
                memoText = memo.text
                selectedCategoryId = memo.categoryId
            }
        }
    }

    private func saveMemo() {
        let newMemo = Memo(
            id: memo?.id ?? UUID(),
            text: memoText,
            categoryId: selectedCategoryId,
            date: memo?.date ?? Date()
        )
        viewModel.saveMemo(newMemo)
        presentationMode.wrappedValue.dismiss()
    }
}
