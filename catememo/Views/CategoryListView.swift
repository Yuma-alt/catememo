import SwiftUI

struct CategoryListView: View {
    @ObservedObject var viewModel: MemoViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var editingCategory: EditingCategory?

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.categories) { category in
                        HStack {
                            Text(category.name)
                            Spacer()
                            Button(action: {
                                editingCategory = .edit(category)
                            }) {
                                Image(systemName: "pencil")
                            }
                        }
                    }
                    .onDelete(perform: deleteCategory)
                }
                .navigationTitle("Edit Categories")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }

                VStack {
                    Spacer()
                    Button(action: {
                        editingCategory = .new
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                }
            }
            .sheet(item: $editingCategory) { editingCategory in
                NavigationView {
                    switch editingCategory {
                    case .new:
                        AddCategoryView(viewModel: viewModel, category: nil)
                    case .edit(let category):
                        AddCategoryView(viewModel: viewModel, category: category)
                    }
                }
            }
        }
    }

    private func deleteCategory(at offsets: IndexSet) {
        offsets.forEach { index in
            let category = viewModel.categories[index]
            viewModel.deleteCategory(category)
        }
    }
}
