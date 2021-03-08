import AssocList "mo:base/AssocList";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Array "mo:base/Array";
import Option "mo:base/Option";
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
    public type CreateItemDto = {
        name: Text;
        description: Text;
    };
    public type ItemDto = {
        id: Nat;
        name: Text;
        description: Text;
        borrower: ?UserId;
    };
    public type UserId = Principal;

    func isEq(x: Int, y: Int): Bool { x == y };
    let hashMap = HashMap.HashMap<Nat, ItemDto>(1,isEq,Hash.hash);

    public func createOne(item: CreateItemDto) {
        let id = counter.bump();
        hashMap.put(id, {id = id;name= item.name; description= item.description; borrower=null});
    };

    public query func getOne(id: Nat): async ?ItemDto {
        hashMap.get(id)
    };

    public query func getAllItems(): async [ItemDto] {
        var items: [ItemDto] = [];
        for((id, item) in hashMap.entries()) {
            items := Array.append<ItemDto>(items, [item]);
        };
        return items;
    };

    public shared({caller}) func borrowItem(id:Nat): async () {
      Option.iterate(await getOne(id), func (currentItem: ItemDto){
          hashMap.put(id, {
            id = currentItem.id;
            name= currentItem.name; 
            description= currentItem.description; 
            borrower =?caller
          });
      });
    };
};