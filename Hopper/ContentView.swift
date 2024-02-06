import SwiftUI

struct AnimalCardView: View {
    var animal: Animal
    var onRemove: () -> Void  // Callback when card is removed
    
    @State private var dragState = CGSize.zero
    @State private var flipped = false  // Tracks the flip state
    @State private var degrees = 0.0  // Tracks the rotation angle

    var body: some View {
        VStack {
            ZStack {
                Group {
                    if !flipped {
                        // Front of the card
                        VStack {
                            Image(systemName: animal.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 350)
                                .padding(.top)
                            
                            Text(animal.name)
                                .font(.headline)
                                .padding(.bottom)
                        }
                    } else {
                        // Back of the card, initially rotated 180 degrees
                        Text("More details about \(animal.name)")
                            .font(.headline)
                            .padding()
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0)) // This ensures it starts flipped
                    }
                }
                .frame(width: 320, height: 420)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        degrees += 180
                        flipped.toggle()
                    }
                }
            }
            .offset(x: dragState.width, y: 0)
            .rotationEffect(.degrees(Double(dragState.width / 20)))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragState = value.translation
                    }
                    .onEnded { value in
                        if abs(dragState.width) > 100 {
                            onRemove()
                        } else {
                            dragState = .zero
                        }
                    }
            )
            .animation(.easeOut, value: dragState)
        }
    }
}

struct ContentView: View {
    /*
    @State private var animals = [
        Animal(id: 0, name: "Dog", image: "pawprint.fill"),
        Animal(id: 1, name: "Rabbit", image: "hare.fill"),
        Animal(id: 2, name: "Cat", image: "cat.fill")
        // ... more animals
    ]
    */
    @State private var animals: [Animal] = []
    @State private var currentAnimalIndex = 0
    private let animalDataService = AnimalDataService()

    var body: some View {
        VStack {
            if currentAnimalIndex < animals.count {
                AnimalCardView(animal: animals[currentAnimalIndex], onRemove: {
                    // Remove the current card and show the next one
                    removeCurrentAnimal()
                })
                .transition(AnyTransition.scale.combined(with: .opacity))
                .id(animals[currentAnimalIndex].id) // Add a unique ID for each card view
            } else {
                Text("No more animals to show")
                    .padding()
                
                // Button to restart the card stack, shown only when all animals have been swiped
                Button(action: restartCards) {
                    Text("Start Over")
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
        }
    }
    
    private func removeCurrentAnimal() {
        // Increment the current index instead of removing the animal
        // This keeps the animal in the array but moves the view to the next one
        currentAnimalIndex += 1
    }
    
    private func restartCards() {
        currentAnimalIndex = 0 // Resets the index to show the first animal
    }
}

#Preview {
    ContentView()
}
