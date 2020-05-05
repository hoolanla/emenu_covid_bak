class setMenu{
  String ResultOk;
  String ErrorMessage;
  String restuarantID;

  List<menuItem> menuList;

  setMenu  ({this.ResultOk,
    this.ErrorMessage,
    this.restuarantID,
    this.menuList});

  factory setMenu.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['menuList'] as List;
    List<menuItem> data = list.map((i) => menuItem.fromJson(i)).toList();

    return setMenu(
        ResultOk: parsedJson['ResultOk'],
        ErrorMessage: parsedJson['ErrorMessage'],
        restuarantID: parsedJson['restuarant_id'],
        menuList: data

    );
  }
}

class menuItem{
  String menuID;
  String menuName;
  String price;
  String menuActivate;



  menuItem({
    this.menuID,
    this.menuName,
    this.price,
    this.menuActivate,
  });

  factory menuItem.fromJson(Map<String, dynamic> parsedJson){
    return menuItem(
      menuID: parsedJson['menu_id'],
      menuName : parsedJson['menu_name'],
      price: parsedJson['menu_price'],
      menuActivate:  parsedJson['menu_activate'],
    );
  }

}