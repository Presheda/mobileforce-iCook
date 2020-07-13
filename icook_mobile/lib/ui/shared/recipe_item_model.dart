import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icook_mobile/core/datasources/remotedata_source/DIsh/dishdatasource.dart';
import 'package:icook_mobile/models/response/Dish/dishitem.dart';
import 'setup_ui_dialog.dart';
import 'package:icook_mobile/ui/base_view_model.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:icook_mobile/locator.dart';
import 'package:icook_mobile/core/constants/view_routes.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecipeItemModel extends BaseNotifier {
  final navigation = locator<NavigationService>();
  final datasource = locator<DishDataSource>();
  final snack = locator<SnackbarService>();

  final dialogService = locator<DialogService>();

  bool _isLiked = false;
  bool get isLiked => _isLiked;

  int _likes = 0;
  int get likes => _likes;

  Dish _data;
  Dish get data => _data;

  DateTime _dateTime;
  DateTime get dateTime => _dateTime;

  String get time => timeago.format(dateTime) ?? "";

  void setData(final Dish data) {
    _data = data;
    _isLiked = data.isLiked;
    _likes = data.likesCount;
    _dateTime = DateTime.parse(data?.createdAt ?? DateTime.now().toString());
  }

  Future<void> like() async {
    _isLiked = !_isLiked;

    _isLiked ? _likes++ : _likes--;
    notifyListeners();

    try {
      var result = await datasource.toggleLikeDish(data.id);
      print(result);
      // _isLiked == true
      //     ? showSnack('Liked successfully')
      //     : showSnack('Unliked successfully');
    } catch (e) {
      print('dish model exception $e');
      showSnack(e.toString());
    }
  }

  void showShareDialog() async {
    String message = "";

    message += _data.name.toUpperCase() + "\n \n";

    message += "Recipes: \n";
    message += _data.recipe
            .toString()
            .substring(1, _data.recipe.toString().length - 1) +
        "\n \n";
    message += "Ingredients: \n";
    message += _data.ingredients
            .toString()
            .substring(1, _data.ingredients.toString().length - 1) +
        "\n \n";
    message += "Health Benefit: \n";
    message += _data.healthBenefits
            .toString()
            .substring(1, _data.healthBenefits.toString().length - 1) +
        "\n";

    Share.share(message, subject: "iCook Dish");
  }

  Future<void> favourite() async {
    try {
      var result = await datasource.toggleFavouriteDish(data.id);
      print(result);
      showSnack('Added Successfully');
    } catch (e) {
      print('dish model exception $e');
      showSnack(e.toString());
    }
  }

  void seeDetails(Dish dishe) {
    navigation.navigateTo(ViewRoutes.recipe_details, arguments: dishe);
  }

  void seeUserInfo() {
    navigation.navigateTo(ViewRoutes.userprofile);
  }

  void showSnack(String message) {
    snack.showCustomSnackBar(
        message: message,
        title: 'iCook_bot',
        instantInit: true,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM);
  }
}
