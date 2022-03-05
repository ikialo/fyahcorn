import 'package:flutter/material.dart';
import 'package:fyahcorn/changeNotifierProvider.dart';
import 'package:provider/provider.dart';

import '../Theme/colors.dart';
import '../dbhelper.dart';
import '../model.dart';


class AlertFIlter extends StatefulWidget {
  const AlertFIlter({Key? key}) : super(key: key);

  @override
  _AlertFIlterState createState() => _AlertFIlterState();
}

class _AlertFIlterState extends State<AlertFIlter> {

  late DatabaseHandler handler;
  late Future<List<item>> _item ;
  late Future<List<catagory>> _catagories;
  int activeCat = 0;




  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {

      setState(() {
        _catagories = getList();

      });


    });
  }

  Future<List<catagory>> getList() async {
    return await handler.catagories();
  }
  Future<List<item>> getItemList() async {
    return await handler.items(" ");
  }




  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer <ProviderBudget>(
        builder:  (context, provider, child) {
          return Container(
            height: 300.0, // Change as per your requirement
            width: 300.0, // Change as per your requirement
            child: FutureBuilder<List<catagory>>(
              future: _catagories,
              builder: (BuildContext context,
                  AsyncSnapshot<List<catagory>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return new Center(
                    child: new CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return new Text('Error: ${snapshot.error}');
                } else {
                  final items = snapshot.data ?? <catagory>[];
                  print(items.toString());
                  return Scrollbar(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              print(items[index].catagory1);
                              activeCat = index;
                              print(activeCat);
                            });

                            provider.CatagoryToFilterTo(items[index].catagory1);
                          },
                          child: Card(
                              color: activeCat == index
                                  ? green
                                  : white,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8.0),
                                title: Container(

                                    width: 70,
                                    child: Text(
                                        items[index].catagory1 )),

                              )),
                        );
                      },
                    ),

                  );
                }
              },
            ),
          );
        }
      ),
    );

  }


}
