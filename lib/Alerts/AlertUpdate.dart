
import 'package:flutter/material.dart';

import '../dbhelper.dart';

class AlertUpdate extends StatefulWidget {

  final item_;
  final id_;
  final quantity_;
  final unitprice_;

  const AlertUpdate({Key? key, this.item_, this.unitprice_, this.quantity_, this.id_}) : super(key: key);

  @override
  _AlertUpdateState createState() => _AlertUpdateState(id_: this.id_, quanity_: this.quantity_, unitprice_: this.unitprice_, item_: this.item_);
}

class _AlertUpdateState extends State<AlertUpdate> {

  late DatabaseHandler handler;
  late String item_ ;
  late double unitprice_ ;
  late int quanity_;
  late int id_;

  _AlertUpdateState({required this.item_,required this.unitprice_,required this.quanity_, required this.id_});


  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {



    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      child: Column(

        children: [
          SizedBox(
            width: 200,
            child: TextField(

              onChanged: (value){

                setState(() {
                  item_ =value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Item Name',


              ),
            ),
          ),

          SizedBox(
            width: 200,
            child: TextField(
              onChanged: (value){

                setState(() {
                  unitprice_ = double.parse(value);
                });
              },
              decoration: const InputDecoration(
                hintText: 'Unit Price',


              ),
              keyboardType: TextInputType.number,

            ),
          ),

          SizedBox(
            width: 200,
            child: TextField(
              onChanged: (value){

                setState(() {
                  quanity_ = int.parse(value);
                });
              },

              decoration: const InputDecoration(
                  hintText: 'Quantity'


              ),
              keyboardType: TextInputType.number,
            ),
          ),

          SizedBox(height: 15,),
          TextButton(
            onPressed: () {

              double total = unitprice_*quanity_;

              handler.updateItem(item_, unitprice_, quanity_, total, id_);
              //_onRefresh();
              Navigator.pop(context, 'Update');

            },
            child: const Text('Update'),
          ),
        ],),
    );
  }
}
