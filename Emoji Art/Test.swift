import SwiftUI
class MyViewModel: ObservableObject {
    @Published var count: Int = 0
    @Published var name: String = "John"
}

struct ParentView: View {
    @StateObject var viewModel = MyViewModel()

    var body: some View {
        VStack {
            Button("Increment Count") {
                viewModel.count += 1
            }
            
            Button("Change Name") {
                viewModel.name = "Jane"
            }
            
            ChildA(count: viewModel.count) // Uses `count`
            ChildB(name: viewModel.name) // Uses `name`
        }
    }
}

struct ChildA: View {
    var count: Int

    var body: some View {
        print("ChildA re-rendered")
        return Text("Count: \(count)")
    }
}

struct ChildB: View {
    var name: String

    var body: some View {
        print("ChildB re-rendered")
        return Text("Name: \(name)")
    }
}

#Preview() {
    ParentView()
}
