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
  String open_time;
  String close_time;
  String tel;
  RestaurantItems({
    this.restaurantID,
    this.restaurantName,
    this.content,
    this.description,
    this.images,
    this.distance,
    this.distance_price,
    this.open_time,
    this.close_time,
    this.tel
  });

  factory RestaurantItems.fromJson(Map<String, dynamic> parsedJson){
    return RestaurantItems(
        restaurantID: parsedJson['restaurantID'],
        restaurantName : parsedJson['restaurantName'],
        content: parsedJson['content'],
        description: parsedJson['description'],
        images: parsedJson['images'],
        distance: parsedJson['distance'],
        distance_price: parsedJson['distance_price'],
        open_time: parsedJson['open_time'],
        close_time: parsedJson['close_time'],
        tel: parsedJson['tel']
    );
  }
}