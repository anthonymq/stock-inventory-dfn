import Principal "mo:base/Principal";

module {
    public type ItemId = Nat;
    public type UserId = Principal;

    public type Item = {
        id: ItemId;
        name: Text;
        description: Text;
    };

    public func isEq(x: ItemId, y: ItemId): Bool {
        x == y;
    };
};