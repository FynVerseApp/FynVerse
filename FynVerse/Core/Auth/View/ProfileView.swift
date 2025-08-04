import SwiftUI

@MainActor
struct ProfileView: View {
    @StateObject var vm: AuthViewModel = AuthViewModel()
    @State private var profileImage: UIImage? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        // MARK: Header
                        Text("My Profile")
                            .font(.largeTitle.bold())
                            .foregroundColor(Color.theme.accent)
                            .padding(.top, 16)

                        // MARK: Profile Card
                        HStack(spacing: 16) {
                            Group {
                                if let image = profileImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text( "Mr Zubair Ahmed")
                                    .font(.title2.weight(.semibold))
                                    .foregroundColor(Color.theme.accent)

                                if let date = vm.user?.dateCreated {
                                    Text("Investing Since \(date.formatted(.dateTime.month().year()))")
                                        .font(.subheadline)
                                        .foregroundColor(Color.theme.secondary)
                                } else {
                                    Text("Investing Since —")
                                        .font(.subheadline)
                                        .foregroundColor(Color.theme.secondary)
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)

                        // MARK: Navigation Links
                        VStack(spacing: 16) {
                            NavigationLink {
                                SettingsView()
                            } label: {
                                HStack {
                                    Image(systemName: "gearshape")
                                    Text("Settings")
                                }
                                .font(.headline)
                                .foregroundColor(Color.theme.accent)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                            }

                            NavigationLink {
                                Text("Help Center") // Placeholder
                            } label: {
                                HStack {
                                    Image(systemName: "questionmark.circle")
                                    Text("Help & Support")
                                }
                                .font(.headline)
                                .foregroundColor(Color.theme.accent)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        }

                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .task {
                    do {
                        try await vm.loadCurrentUser()
                        print("User Loaded: \(String(describing: vm.user))")

                        if let urlString = vm.user?.photoURL,
                           let url = URL(string: urlString) {
                            do {
                                let (data, response) = try await URLSession.shared.data(from: url)
                                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                                    print("❌ Invalid HTTP Response")
                                    return
                                }

                                if let uiImage = UIImage(data: data) {
                                    profileImage = uiImage
                                } else {
                                    print("❌ Failed to convert Data to UIImage")
                                }
                            } catch {
                                print("❌ Error fetching image data: \(error)")
                            }
                        } else {
                            print("❌ photoURL is nil or invalid")
                        }

                    } catch {
                        print("❌ Error loading user: \(error)")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProfileView()
}
