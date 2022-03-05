class catagory {
  final int id;
  final String catagory1;

  catagory({
    required this.id,
    required this.catagory1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'catagory': catagory1,
    };
  }

  catagory.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        catagory1= res["Catagory"];

  @override
  String toString() {
    return 'catagory{id: $id, catagory: $catagory1}';
  }
}


class item {
  final int id;
  final String catagory1;
  final String item_;
  final double unitPrice;
  final int quantity;
  final double itemcost;

  item({
    required this.id,
    required this.catagory1,
    required this.item_,
    required this.unitPrice,
    required this.quantity,
    required this.itemcost
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'catagory': catagory1,
      'item': item_,
      'unitprice': unitPrice,
      'quantity':quantity,
      'itemcosts':itemcost
    };
 }

  item.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        catagory1= res["Catagory"],
        item_ = res["item"],
        unitPrice = res["unitprice"],
        quantity = res["quantity"],
        itemcost = res["itemcosts"]

  ;

  @override
  String toString() {
    return 'catagory{id: $id, catagory: $catagory1, item: $item_, unitprice : $unitPrice, quantity: $quantity, itemcost: $itemcost}';
  }
}

