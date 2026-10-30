enum Loadable<T> {
    case loading
    case failure(Error)
    case success(T)

    var result: T? {
        if case .success(let result) = self {
            return result
        }
        return nil
    }

    func map<R>(_ transform: (T) -> R) -> Loadable<R> {
        switch self {
        case .loading: .loading
        case .failure(let error): .failure(error)
        case .success(let result): .success(transform(result))
        }
    }
}
