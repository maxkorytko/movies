import Foundation

// MARK: - DIContainer

final class DIContainer {
    enum Error: Swift.Error {
        case typeNotBound(String)
    }

    private typealias KeyType = ObjectIdentifier

    private var bindings: [ObjectIdentifier: Any] = [:]
    private let lock: NSLock = .init()

    func clear() {
        lock.withLock { bindings = [:] }
    }

    func bind<T>(_ type: T.Type, _ value: T) {
        setBinding(Self.key(from: type), value: value)
    }

    func bindLazy<T>(_ type: T.Type, _ value: @escaping () -> T) {
        setBinding(Self.key(from: type), value: LazyValueProvider(value))
    }

    func resolve<T>(_ type: T.Type) throws -> T {
        try resolve(type, key: Self.key(from: type))
    }

    private func resolve<T>(_ type: T.Type, key: KeyType) throws -> T {
        if let value: T = binding(key) {
            return value
        }

        if let valueProvider: LazyValueProvider<T> = binding(key) {
            return valueProvider()
        }

        throw Error.typeNotBound("\(T.self)")
    }

    private func binding<T>(_ key: KeyType) -> T? {
        lock.withLock { bindings[key] as? T }
    }

    private func setBinding<T>(_ key: KeyType, value: T) {
        lock.withLock { bindings[key] = value }
    }

    private static func key<T>(from type: T.Type) -> KeyType {
        ObjectIdentifier(type)
    }
}

private final class LazyValueProvider<T> {
    lazy var value: T = makeValue()
    private let makeValue: () -> T
    private let lock: NSLock = .init()

    init(_ makeValue: @escaping () -> T) {
        self.makeValue = makeValue
    }

    func callAsFunction() -> T {
        lock.withLock { value }
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
