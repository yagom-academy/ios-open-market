extension Array {
    subscript(safe index: Int) -> Element? {
        guard self.count > index else {
            return nil
        }
        return self[index]
    }
}
