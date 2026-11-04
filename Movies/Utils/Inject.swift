import Foundation

func inject<T>(_ type: T.Type = T.self) -> T {
    do {
        return try DI.container.resolve(type)
    } catch {
        fatalError("\(error)")
    }
}

@propertyWrapper
struct Inject<T> {
    private let value: T

    init() {
        value = inject(T.self)
    }

    var wrappedValue: T {
        get { value }
    }
}
