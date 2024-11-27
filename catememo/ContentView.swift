import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MemoViewModel()
    @State private var showingAddMemoView = false
    @State private var showingAddCategoryView = false
    @State private var activeMemoIndex: Int?
    @State private var showingCategoryListView = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    categoryPicker

                    List {
                        ForEach(filteredMemos) { memo in
                            NavigationLink(
                                destination: AddMemoView(
                                    viewModel: viewModel,
                                    memo: memo
                                )
                            ) {
                                Text(viewModel.getFirstLine(of: memo.text))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                        .onDelete(perform: viewModel.deleteMemo)
                        .onMove(perform: moveMemo)
                    }
                    .toolbar {
                        EditButton()
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddCategoryView = true
                        }) {
                            Image(systemName: "folder.badge.plus")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 16)
                    }
                }
                
                VStack {
                    Spacer()
                    Button(action: {
                        showingAddMemoView = true
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.bottom, 16)
                }
            }
            .sheet(isPresented: $showingAddMemoView) {
                AddMemoView(viewModel: viewModel, memo: nil)
            }
            .sheet(isPresented: $showingAddCategoryView) {
                CategoryListView(viewModel: viewModel)
            }
        }
    }

    private var categoryPicker: some View {
        HStack {
            Picker("Category", selection: $viewModel.selectedCategoryId) {
                Text("All").tag(UUID?.none)
                ForEach(viewModel.categories) { category in
                    Text(category.name).tag(category.id as UUID?)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .padding()
    }

    private var filteredMemos: [Memo] {
        if let selectedCategoryId = viewModel.selectedCategoryId {
            return viewModel.memos.filter { $0.categoryId == selectedCategoryId }
        } else {
            return viewModel.memos
        }
    }

    private func moveMemo(from source: IndexSet, to destination: Int) {
        if viewModel.selectedCategoryId == nil {
            // If category is not selected, operate viewModel.memos directly
            viewModel.memos.move(fromOffsets: source, toOffset: destination)
        } else {
            // Operate filtered memos
            var filtered = filteredMemos
            filtered.move(fromOffsets: source, toOffset: destination)
            
            // Update viewModel.memos
            var newMemos: [Memo] = []
            var filteredIndex = 0

            for memo in viewModel.memos {
                if memo.categoryId == viewModel.selectedCategoryId {
                    // Add orders after sorting in Memos of selected category
                    newMemos.append(filtered[filteredIndex])
                    filteredIndex += 1
                } else {
                    // Add others
                    newMemos.append(memo)
                }
            }
            viewModel.memos = newMemos
            viewModel.saveMemos()
        }
    }
}

// Add to show preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
