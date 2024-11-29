import SwiftUI

struct AddCategoryView: View {
    @ObservedObject var viewModel: MemoViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var categoryName: String = ""
    var category: Category?

    var body: some View {
        VStack {
            Spacer()

            Form {
                Section(header: Text(category != nil ? "Edit Category" : "New Category")) {
                    TextField("Category Name", text: $categoryName)
                        .textFieldStyle(DefaultTextFieldStyle())
                }
            }
            .frame(height: 100)

            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    saveCategory()
                }) {
                    Text("Save")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(categoryName.isEmpty ? Color.gray.opacity(0.7) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(categoryName.isEmpty)
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 20)
        }
        .navigationTitle(category != nil ? "Edit Category" : "Add Category")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let category = category {
                categoryName = category.name
            }
        }
    }

    private func saveCategory() {
        if var category = category {
            // Update category
            category.name = categoryName
            viewModel.updateCategory(category)
        } else {
            // Add new category
            let newCategory = Category(name: categoryName)
            viewModel.addCategory(newCategory)
        }
        presentationMode.wrappedValue.dismiss()
    }
}
