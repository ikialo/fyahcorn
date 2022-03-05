import 'package:flutter/material.dart';

class ProviderBudget extends ChangeNotifier{

  String Cata = " ";
  bool newItemAdded = false;

  void CatagoryToFilterTo(String catagory){
      Cata = catagory;
      notifyListeners();
  }

  void wasNewItemAdded(bool check){
    newItemAdded = check;
    notifyListeners();
  }

  //Getter for Filtered Catagory
  String get catagoryFilter => Cata;
  bool get itemAdded => newItemAdded;





}