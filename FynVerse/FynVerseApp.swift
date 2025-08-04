import SwiftUI
import Firebase

@main
struct FynVerseApp: App {
    init() {
           // Step 1: Create the AuthViewModel instance.
           let authVM = AuthViewModel()
           
           // Step 2: Use the special `_` prefix to assign the wrapped value for @StateObject.
           // This is the correct way to initialize property wrappers inside an init.
           _authViewModel = StateObject(wrappedValue: authVM)
           
           // Step 3: Create the HomeViewModel and pass the SAME AuthViewModel instance to it.
           _vm = StateObject(wrappedValue: HomeViewModel(authViewModel: authVM))
           
           // This completes the initializer, and all stored properties are now set.
       }
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
   
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @StateObject var authViewModel: AuthViewModel
       @StateObject private var vm: HomeViewModel

    var body: some Scene {
        WindowGroup {
            // Apply .task to the top-level view inside the WindowGroup.
            // This ensures it runs when the view appears.
            VStack {
                if isLoggedIn {
                    NavigationStack {
                        MainTabView()
                    }
                } else {
                    RegisterView(showSignInView: .constant(true))
                }
            }
            .environmentObject(vm)
            .environmentObject(authViewModel)
            .task {
                // Now this is correctly applied to a View.
                try? await authViewModel.loadCurrentUser()
            }
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

