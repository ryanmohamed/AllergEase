import SwiftUI

struct AllergyDrawer: View {
    @Binding var selectedAllergies: [AllergyType]
    @Binding var isShowing: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Color.black.opacity(isShowing ? 0.5 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        self.isShowing = false
                    }

                VStack {
                    Spacer().frame(height: 75) // Adjust this value as needed
                    HStack {
                        Spacer().frame(width: 25)
                        Text("Allergies:")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer().frame(height: 25) // Adjust this value as needed
                    ForEach(AllergyType.allCases, id: \.self) { allergy in
                        HStack {
                            Toggle("", isOn: Binding(
                                get: { self.selectedAllergies.contains(allergy) },
                                set: { newValue in
                                    if newValue {
                                        self.selectedAllergies.append(allergy)
                                    } else {
                                        self.selectedAllergies.removeAll { $0 == allergy }
                                    }
                                }
                            ))
                            .fixedSize() // This will ensure that Toggle doesn't take up more space than it needs
                            Spacer().frame(width: 20)
                            Text(allergy.rawValue.capitalized)
                                .font(.title3)
                            Spacer() // Pushes the Toggle and Text to the left
                        }
                        .padding(.horizontal)
                    }
                    Spacer()
                }
                .frame(width: geometry.size.width * 0.75)
                .background(Color(UIColor.secondarySystemBackground))
                .edgesIgnoringSafeArea(.all)
                .offset(x: isShowing ? 0 : -geometry.size.width)
                .animation(.easeIn(duration: 0.25), value: isShowing) // Use easeIn for the VStack offset
                .foregroundColor(.primary)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 3, y: 0)
            }
        }
    }
}

struct AllergyDrawer_Previews: PreviewProvider {
    static var previews: some View {
        AllergyDrawer(selectedAllergies: .constant([.wheat]), isShowing: .constant(true))
    }
}
