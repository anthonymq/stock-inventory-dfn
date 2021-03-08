import Array "mo:base/Array";
import AssocList "mo:base/AssocList";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Item "./item";
import Principal "mo:base/Principal";

actor Inventory {
    public type Item = Item.Item;
    public type UserId = Principal;

    object counter {
        var count = 0;
        public func inc() { count += 1 };
        public func read() : Nat { count };
        public func bump() : Nat {
            inc();
            read()
        };
    };
    
    public type CreateItemDto = {
        name: Text;
        description: Text;
    };

    public type ItemDto = {
        id: Nat;
        name: Text;
        description: Text;
        borrower: ?Text;
    };

    let hashMap = HashMap.HashMap<Nat, (Item, ?UserId)>(1,Item.isEq,Hash.hash);

    public func createOne(item: CreateItemDto): async () {
        let id = counter.bump();

        hashMap.put(id, ({id= id; name= item.name; description= item.description}, null));
    };

    public query func getAllItems(): async [ItemDto] {
        var items: [ItemDto] = [];
        for((id, item) in hashMap.entries()) {
            items := Array.append<ItemDto>(items, [mapItem(item)]);
        };
        return items;
    };
    
    func getOne(id: Nat): ?(Item, ?UserId) {
        hashMap.get(id)
    };

    func mapItem((item: Item, principal: ?UserId)): ItemDto {
        {
            id= item.id;
            name= item.name;
            description= item.description;
            borrower= Option.map<UserId, Text>(principal, func(p: UserId) {Principal.toText(p)})
        };
    };

    public func borrow(id: Nat, caller: ?UserId): async Text {
        switch(getOne(id)) {
            case null {
                "Item " # Nat.toText(id) # " not found."
            };
            case (result) {
                let it1:?(Item, ?UserId) = Option.map<(Item, ?UserId), (Item, ?UserId)>(
                    result,
                    func ((it: Item, _: ?UserId)) : (Item, ?UserId) { (it, caller) }
                );

                hashMap.put(id, Option.unwrap(it1));
                "Item " # Nat.toText(id) # " borrowed."
            }
        };
    };

    public shared ({ caller }) func borrowItem(id: Nat): async Text {
        await borrow(id, ?(caller));
    };

    public shared func unborrowItem(id: Nat): async Text {
        await borrow(id, null);
    };


};