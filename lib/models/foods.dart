class Menu{
  String ResultOk;
  String ErrorMessage;
  String CountMenu;
  String restuarantName;
  String imageRestuarant;
  List<Data> data;

  Menu  ({this.ResultOk,
    this.ErrorMessage,
    this.CountMenu,
    this.restuarantName,
    this.imageRestuarant,
    this.data});

  factory Menu.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['Data'] as List;
    List<Data> data = list.map((i) => Data.fromJson(i)).toList();

    return Menu(
        ResultOk: parsedJson['ResultOk'],
        ErrorMessage: parsedJson['ErrorMessage'],
        CountMenu: parsedJson['CountMenu'],
        restuarantName: parsedJson['restuarantName'],
        imageRestuarant: parsedJson['imageRestuarant'],
        data: data

    );
  }
}

class Data{
  String foodsTypeIDLevel1;
  String foodsTypeIDLevel2;
  String foodsTypeNameLevel1;
  String foodsTypeNameLevel2;
  List<foodsItem> foodsItems;

  Data({
    this.foodsTypeIDLevel1,
    this.foodsTypeIDLevel2,
    this.foodsTypeNameLevel1,
    this.foodsTypeNameLevel2,
    this.foodsItems
  });

  factory  Data.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['foodsItems'] as List;
    List<foodsItem> foods = list.map((i) => foodsItem.fromJson(i)).toList();

    return Data(
        foodsTypeIDLevel1: parsedJson['foodsTypeIDLevel1'],
        foodsTypeIDLevel2: parsedJson['foodsTypeIDLevel2'],
        foodsTypeNameLevel1: parsedJson['foodsTypeNameLevel1'],
        foodsTypeNameLevel2: parsedJson['foodsTypeNameLevel2'],
        foodsItems: foods

    );
  }
}

class foodsItem{
  int foodID;
  String foodName;
  String price;
  String priceS;
  String priceM;
  String priceL;
  String size;
  String description;
  String images;
  int qty;
  String totalPrice;
  String taste;


  foodsItem({
    this.foodID,
    this.foodName,
    this.price,
    this.priceS,
    this.priceM,
    this.priceL,
    this.size,
    this.description,
    this.images,
    this.qty,
    this.totalPrice,
    this.taste
  });

  factory foodsItem.fromJson(Map<String, dynamic> parsedJson){
    return foodsItem(
      foodID: int.parse(parsedJson['foodsID']),
      foodName : parsedJson['foodsName'],
      price: parsedJson['price'],
      priceS: parsedJson['priceS'],
      priceM: parsedJson['priceM'],
      priceL: parsedJson['priceL'],
      size : parsedJson['size'],
      description: parsedJson['description'],
      images : parsedJson['images'],
      qty : parsedJson['qty'],
      totalPrice : parsedJson['totalPrice'],
      taste : parsedJson['taste'],
    );
  }

}

class detailFood{
  int foodID;
  String foodName;
  String price;
  String priceS;
  String priceM;
  String priceL;
  String size;
  String description;
  String images;


  detailFood(
      this.foodID,
      this.foodName,
      this.price,
      this.priceS,
      this.priceM,
      this.priceL,
      this.size,
      this.description,
      this.images
      );
}

