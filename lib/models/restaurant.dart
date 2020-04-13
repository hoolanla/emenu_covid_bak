class Restaurant{
  String ResultOk;
  String ErrorMessage;
  List<RestaurantItems> data;

  Restaurant({this.ResultOk,
    this.ErrorMessage,
    this.data});

  factory Restaurant.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['data'] as List;
    List<RestaurantItems> data = list.map((i) => RestaurantItems.fromJson(i)).toList();

    return Restaurant(
        ResultOk: parsedJson['ResultOk'],
        ErrorMessage: parsedJson['ErrorMessage'],
        data: data
    );
  }
}

class RestaurantItems{
  String restaurantID;
  String restaurantName;
  String content;
  String description;
  String images;
  String distance;
  String distance_price;
  RestaurantItems({
    this.restaurantID,
    this.restaurantName,
    this.content,
    this.description,
    this.images,
    this.distance,
    this.distance_price
  });

  factory RestaurantItems.fromJson(Map<String, dynamic> parsedJson){
    return RestaurantItems(
        restaurantID: parsedJson['restaurantID'],
        restaurantName : parsedJson['restaurantName'],
        content: parsedJson['content'],
        description: parsedJson['description'],
        images: parsedJson['images'],
      distance: parsedJson['distance'],
      distance_price: parsedJson['distance_price']
    );
  }
}