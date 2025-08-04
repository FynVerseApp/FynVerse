import SwiftUI

@MainActor
struct SettingsView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @StateObject var vm: AuthViewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            // Background Color
            Color.theme.background.ignoresSafeArea()
            ScrollView {
                
                VStack(alignment: .leading, spacing: 32) {
                   
                    // Buttons
                  
                        Button(action: {
                            vm.logout()
                        }) {
                            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .controlSize(.large)

                        Button(action: {
                            Task { try? await vm.updatePassword() }
                        }) {
                            Label("Update Password", systemImage: "key.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)

                        Button(role: .destructive) {
                            Task { try? await vm.updatePassword() }
                        } label: {
                            Label("Delete Account", systemImage: "trash.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                
                .padding()
                
            }
        }
    }
}

#Preview {
    SettingsView()
}
