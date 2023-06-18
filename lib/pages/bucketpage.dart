import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testtask/widgets/circle_avatar.dart';
import 'package:intl/intl.dart';

import '../models/bucket_model.dart';

class BucketPage extends StatefulWidget {
  const BucketPage({super.key});

  @override
  State<BucketPage> createState() => _BucketPageState();
}

class _BucketPageState extends State<BucketPage> {

  List<Map<String, dynamic>> selectedDishes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final selectedDish = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;


    if (selectedDish != null) {
      setState(() {
        selectedDishes.add(selectedDish);
      });
    }
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (var dish in selectedDishes) {
      totalPrice += dish['price'] ?? 0;
    }
    return totalPrice;
  }

  int _currentIndex = 2;

  void _onBottomNavigationBarItemTapped(int index) {
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else if (index == 2) {
      Navigator.pushNamedAndRemoveUntil(context, '/bucket', (route) => false);
    }
  }
  void _addToBucket(Map<String, dynamic> selectedDish, BuildContext context) {
    Provider.of<BucketModel>(context, listen: false).addToBucket(selectedDish);
  }


  @override
  Widget build(BuildContext context) {
    final currentDate = DateFormat.yMMMMd('en_US').format(DateTime.now());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.location_on_outlined,
            color: Colors.black,
            size: 40,
            ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Санкт-Петербург',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                ),
              ),
              Text(
                currentDate,
                  style: TextStyle(
                  color: Colors.black38,
                  fontSize: 20.0,
                ),
              )
            ],
          ),
          actions: <Widget>[new Padding(
              padding: EdgeInsets.fromLTRB(1, 1, 10, 1),
              child: CircleImage(),
            ),
          ],
          elevation: 0,
        ),
        body: Consumer<BucketModel>(
          builder: (context, bucketModel, _) {
            List<Map<String, dynamic>> selectedDishes = bucketModel
                .getSelectedDishes();
            int totalPrice = bucketModel.getTotalPrice();
            return Column(
              children: [
                Expanded(
                  child: selectedDishes.isEmpty
                      ? Center(child: Text('Корзина пуста.'))
                      : ListView.builder(
                    itemCount: selectedDishes.length,
                    itemBuilder: (context, index) {
                      final dish = selectedDishes[index];
                      return ListTile(
                        leading:   Image(image: NetworkImage(dish['image_url']),),
                        title: Text(dish['name']),
                        subtitle: Row(
                          children: [
                            Text('${dish['price']}',style: TextStyle(color: Colors.black),),
                            Icon(Icons.currency_ruble_sharp, size: 15,color: Colors.black,),
                            Text('${dish['weight']}г'),
                          ],

                        ),
                        trailing: IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    selectedDishes.removeAt(index);
                                  });
                                },
                              ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ElevatedButton(

                          onPressed: (){},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Оплатить ${totalPrice}'),
                              Icon(Icons.currency_ruble_sharp, size: 15,)
                            ],
                          ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),

        bottomNavigationBar: BottomNavigationBar(

          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.black38,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _onBottomNavigationBarItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Поиск',

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket_outlined),
              label: 'Корзина',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Аккаунт',
            ),
          ],
        )

    );
  }
}