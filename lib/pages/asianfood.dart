import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testtask/widgets/circle_avatar.dart';
import 'package:testtask/forapi/api_dishes.dart';

import '../models/bucket_model.dart';

class AsianFood extends StatefulWidget {
  AsianFood({super.key});

  @override
  State<AsianFood> createState() => _AsianFoodState();
}

class _AsianFoodState extends State<AsianFood> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> dishes = [];
  List<String> asianCategories = ['Все меню', 'Салаты', 'С рисом', 'С рыбой'];


  Future<void> fetchAsianDishes(String asianCategory) async {
    try {
      List<Map<String, dynamic>> fetchedDishes = await fetchDishes();
      if (asianCategory == 'Все меню') {
        setState(() {
          dishes = fetchedDishes;
        });
      } else {
        List<Map<String, dynamic>> filteredDishes = fetchedDishes
            .where((dish) => dish['tegs'].contains(asianCategory))
            .toList();
        setState(() {
          dishes = filteredDishes;
        });
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAsianDishes('Все меню');
    _tabController = TabController(length: asianCategories.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        fetchAsianDishes(asianCategories[_tabController.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _currentIndex = 0;

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
          title: Text(
            'Азиатская Кухня',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(1, 1, 10, 1),
              child: CircleImage(),
            ),
          ],
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black,
            tabs: asianCategories
                .map((asianCategory) => Tab(text: asianCategory))
                .toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: asianCategories.map((asianCategory) {
            return  GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: List.generate(dishes.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 300,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(dishes[index]['image_url']),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 8.0,
                                            right: 12.0,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  color: Colors.black12,
                                                  child: IconButton(
                                                    icon: Icon(Icons.favorite_border),
                                                    onPressed: () {

                                                    },
                                                  ),
                                                ),
                                                SizedBox(width: 5,),
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  color: Colors.black12,
                                                  child: IconButton(
                                                    icon: Icon(Icons.close),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Text(dishes[index]['name'],),
                                  Row(
                                    children: [
                                      Text('${dishes[index]['price']}'),
                                      Icon(Icons.currency_ruble_sharp, size: 15,),
                                      Text(' ${dishes[index]['weight']} г', style: TextStyle(color: Colors.black38),),
                                    ],
                                  ),
                                  LimitedBox(
                                    maxHeight: 80,
                                    child: Text(
                                      '${dishes[index]['description']}',
                                      maxLines: 4,
                                      style: TextStyle(fontSize: 16,color: Colors.black38),
                                    ),
                                  ),

                                  Container(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _addToBucket(dishes[index], context);
                                        Navigator.of(context).pop();
                                        },

                                      child: Text('Добавить в корзину'),
                                    ),
                                  )
                                ],
                              ),
                            );
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          child: Image(
                            image: NetworkImage(dishes[index]['image_url']),
                            fit: BoxFit.cover,
                            height: 200,
                          ),
                        ),
                        Text(dishes[index]['name']),
                      ],
                    ),
                  );

              }),
            );
          }).toList(),
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
        ),
      ),
    );
  }
}
