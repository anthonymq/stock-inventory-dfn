import AssocList "mo:base/AssocList";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Array "mo:base/Array";

import List "mo:base/List";

actor Inventory {
    object counter {
        var count = 0;
        public func inc() { count += 1 };
        public func read() : Nat { count };
        public func bump() : Nat {
            inc();
            read()
        };
    };
    

    public type UserId = Principal;
    
    public type CreateItemDto = {
        name: Text;
        description: Text;
    };

    public type ItemDto = {
        id: Nat;
        name: Text;
        description: Text;
    };

    func isEq(x: Int, y: Int): Bool { x == y };
    let hashMap = HashMap.HashMap<Nat, ItemDto>(1,isEq,Hash.hash);

    public func createOne(item: CreateItemDto): async () {
        let id = counter.bump();
        hashMap.put(id, {id = id;name= item.name; description= item.description});
    };

    public func getAllItems(): async [ItemDto] {
        var items: [ItemDto] = [];
        for((id, item) in hashMap.entries()) {
            items := Array.append<ItemDto>(items, [item]);
        };
        return items;
    };
    
    public func getOne(id: Nat): async ?ItemDto {
        hashMap.get(id)
    };



    private stable var availableItems: List.List<ItemDto> = List.nil();
    private stable var borrowedItems: AssocList.AssocList<ItemDto, Principal> = List.nil();

    public func createItem (item: CreateItemDto): async Int {
        var newItem: ItemDto = {id=counter.bump() ;name= item.name; description= item.description};
        availableItems := List.push(newItem, availableItems);
        return newItem.id;
    };

    // public query func getAllItems (): async List.List<(ItemDto)> {
    //     return availableItems;
    // };

    // public func clearAvailableItems(): async () {
    //     availableItems := List.nil();
    // }

};