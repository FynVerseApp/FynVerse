import SwiftUI
import GoogleSignInSwift

struct RegisterView: View {
    @StateObject private var vm: AuthViewModel = AuthViewModel()
    @Binding var showSignInView: Bool

    var body: some View {
        ZStack {
            // Background
            Color.theme.background 
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Welcome to FynVerse")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 40)

                Spacer()

                VStack(spacing: 16) {
                    NavigationLink {
                        SignUpView(showSignInView: $showSignInView, current: "SignUp")
                    } label: {
                        Text("Sign Up with Email")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .foregroundColor(Color.blue)
                            .font(.headline)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }

                    NavigationLink {
                        SignUpView(showSignInView: $showSignInView, current: "LogIn")
                    } label: {
                        Text("Log In with Email")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .foregroundColor(Color.blue)
                            .font(.headline)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }

                    Text("Or")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.subheadline)
                        .padding(.top, 8)

                    GoogleSignInButton(
                        viewModel: GoogleSignInButtonViewModel(
                            scheme: .dark,
                            style: .standard,
                            state: .normal
                        )
                    ) {
                        Task {
                            do {
                                try await vm.signInGoogle()
                                showSignInView = false
                            } catch {
                                print("❌ Google Sign-In failed: \(error.localizedDescription)")
                            }
                        }
                    }
                    .frame(height: 50)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        RegisterView(showSignInView: .constant(false))
    }
}
