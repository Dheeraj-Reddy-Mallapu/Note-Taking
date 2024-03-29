import 'package:shared_preferences/shared_preferences.dart';

String orderBy = 'modifiedAt';
bool descending = true;
bool gridview = true;
bool fav = false;
String _orderByKey = 'orderByKey';
String _descendingKey = 'descendingKey';
String _gridviewKey = 'gridviewKey';
String _favKey = 'favKey';

Future<bool> setOrderBy(String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString(_orderByKey, value);
}

Future<String> getOrderBy() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  orderBy = prefs.getString(_orderByKey) ?? 'modifiedAt';
  return orderBy;
}

Future<bool> setDescending(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool(_descendingKey, value);
}

Future<bool> getDescending() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  descending = prefs.getBool(_descendingKey) ?? true;
  return descending;
}

Future<bool> setGridview(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool(_gridviewKey, value);
}

Future<bool> getGridview() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  gridview = prefs.getBool(_gridviewKey) ?? true;
  return gridview;
}

Future<bool> setFav(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool(_favKey, value);
}

Future<bool> getFav() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  fav = prefs.getBool(_favKey) ?? false;
  return fav;
}
