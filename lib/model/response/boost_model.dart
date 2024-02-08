class BoostItemModel {
  List<Boostitems>? boostitems;

  BoostItemModel({this.boostitems});

  BoostItemModel.fromJson(Map<String, dynamic> json) {
    if (json['boostitems'] != null) {
      boostitems = <Boostitems>[];
      json['boostitems'].forEach((v) {
        boostitems!.add(Boostitems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (boostitems != null) {
      data['boostitems'] = boostitems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Boostitems {
  int? id;
  String? itemName;
  int? boostCount;
  double? price;
  int? discount;
  double? finalPrice;
  String? createdAt;
  String? updatedAt;

  Boostitems(
      {this.id,
        this.itemName,
        this.boostCount,
        this.price,
        this.discount,
        this.finalPrice,
        this.createdAt,
        this.updatedAt});

  Boostitems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
    boostCount = json['boost_count'];
    price = json['price'].toDouble();
    discount = json['discount'];
    finalPrice = json['final_price'].toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_name'] = itemName;
    data['boost_count'] = boostCount;
    data['price'] = price;
    data['discount'] = discount;
    data['final_price'] = finalPrice;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
