import SwiftUI

struct SignUpView: View {
    @Binding var showSignInView: Bool
    var current: String
    @StateObject private var vm: AuthViewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 127/255, green: 255/255, blue: 212/255) // Sea Green
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(current == "SignUp" ? "Create an Account" : "Welcome Back")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 40)

                TextField("Email...", text: $vm.email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .autocapitalization(.none)

                SecureField("Password...", text: $vm.password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.black)

                Button {
                    Task {
                        do {
                            if current == "SignUp" {
                                try await vm.signUp()
                            } else {
                                try await vm.logIn()
                            }
                            showSignInView = false
                            DispatchQueue.main.async {
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                                    window.rootViewController = UIHostingController(rootView: LoadingTransitionView(authvm: vm))
                                    window.makeKeyAndVisible()
                                }
                            }

                        } catch {
                            print("❌ Auth error: \(error)")
                        }
                    }
                } label: {
                    Text(current)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                }

                if current == "LogIn" {
                    Button("Reset Password") {
                        Task {
                            do {
                                try await vm.resetPassword()
                                print("🔐 Reset password link sent.")
                            } catch {
                                print("❌ Reset password error: \(error)")
                            }
                        }
                    }
                    .foregroundColor(.black)
                    .font(.subheadline)
                    .padding(.top, 10)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(current)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SignUpView(showSignInView: .constant(false), current: "SignUp")
    }
}
