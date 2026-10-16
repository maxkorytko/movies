import Foundation

// MARK: - DIContainer

final class DIContainer {
    enum Error: Swift.Error {
        case typeNotBound(String)
    }

    private var bindings: [String: Any] = [:]

    private static func key<T>(from type: T.Type) -> String {
        String(reflecting: type.self)
    }

    func bind<T>(_ type: T.Type, _ value: T) {
        bindings[Self.key(from: type)] = value
    }

    func bindLazy<T>(_ type: T.Type, _ value: @escaping () -> T) {
        bindings[Self.key(from: type)] = LazyValueProvider(value)
    }

    func resolve<T>(_ type: T.Type) throws -> T {
        try resolve(type, key: Self.key(from: type))
    }

    private func resolve<T>(_ type: T.Type, key: String) throws -> T {
        if let value = bindings[key] as? T {
            return value
        }

        if let valueProvider = bindings[key] as? LazyValueProvider<T> {
            return valueProvider()
        }

        throw Error.typeNotBound("\(T.self)")
    }

    func clear() {
        bindings = [:]
    }
}

private final class LazyValueProvider<T> {
    let makeValue: () -> T
    lazy var value: T = makeValue()

    init(_ makeValue: @escaping () -> T) {
        self.makeValue = makeValue
    }

    func callAsFunction() -> T {
        value
    }
}

// MARK: - DI

enum DI {
    private static var _container: DIContainer?

    static var container: DIContainer {
        get {
            guard let _container else {
                fatalError("DI Container container is accessed before it's initialized.")
            }
            return _container
        } set {
            _container = newValue
        }
    }
}

// MARK: - Utilities

func inject<T>(_ type: T.Type = T.self) -> T {
    do {
        return try DI.container.resolve(type)
    } catch {
        fatalError(error.localizedDescription)
    }
}
