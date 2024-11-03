import SwiftUI

public struct RubberLoadingButton: View {
    let title: String
    let action: () -> Void
    @State private var isPressed = false
    @State private var isLoading = false
    @State private var touchLocation: CGPoint = .zero
    @State private var buttonFrame: CGRect = .zero

    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                action()
            }
        }) {
            ZStack {
                GeometryReader { geometry in
                    // Deep cavity layer (visible when pressed)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.gray.opacity(0.3),
                                    Color.gray.opacity(0.1),
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)

                    // Button face
                    ZStack {
                        // Base button shape
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .shadow(
                                color: .black.opacity(0.2),
                                radius: isPressed ? 1 : 4,
                                x: 0,
                                y: isPressed ? 1 : 2
                            )

                        // Pressure point circle
                        if isPressed {
                            Circle()
                                .fill(
                                    .radialGradient(
                                        Gradient(colors: [
                                            .clear,
                                            .black,
                                            .black,
                                        ]),
                                        center: .center,
                                        startRadius: .infinity,
                                        endRadius: .zero
                                    )
                                )
                                .frame(
                                    width: 40,
                                    height: 40
                                )
                                .blur(radius: 3)
                                .position(touchLocation)
                                .offset(y: 3)
                                .clipped()
                        }

                        // Content
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(isPressed ? 0.95 : 1.0)
                                .offset(y: isPressed ? 2 : 0)
                        }
                        else {
                            Text(title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .scaleEffect(isPressed ? 0.95 : 1.0)
                                .offset(y: isPressed ? 2 : 0)
                        }
                    }
                    .scaleEffect(isPressed ? 0.97 : 1.0)
                    .onAppear {
                        buttonFrame = geometry.frame(in: .local)
                        touchLocation = CGPoint(x: buttonFrame.midX, y: buttonFrame.midY)
                    }
                }

                // Highlight effect
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .white.opacity(isPressed ? 0.2 : 0.4),
                                .clear,
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                    .opacity(isPressed ? 0.5 : 1)
            }
        }
        .frame(height: 50)
        .padding(.horizontal)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    if !isPressed {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isPressed = true
                        }
                        // Add haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                    }

                    // Update touch location
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                        touchLocation = gesture.location
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isPressed = false
                        // Reset touch location to center when released
                        touchLocation = CGPoint(x: buttonFrame.midX, y: buttonFrame.midY)
                    }
                }
        )
    }

    public func isLoading(_ loading: Bool) -> RubberLoadingButton {
        var button = self
        button.isLoading = loading
        return button
    }
}

#Preview {
    VStack(spacing: 20) {
        RubberLoadingButton(title: "Press Me") {
            print("Button pressed!")
        }
        Spacer()
        RubberLoadingButton(title: "Loading...") {
            print("Loading button pressed!")
        }
        .isLoading(true)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
