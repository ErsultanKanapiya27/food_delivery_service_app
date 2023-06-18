import 'package:flutter/material.dart';
import 'package:testtask/widgets/circle_avatar.dart';
import 'package:testtask/forapi/api_category.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<Map<String, dynamic>> fetchedCategories = await fetchCategories();
      List<Category> categoryList = fetchedCategories
          .map((category) => Category(
        name: category['name'] as String,
        imageUrl: category['image_url'] as String,
      ))
          .toList();
      setState(() {
        categories = categoryList;
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }
  int _currentIndex = 0;

  void _onBottomNavigationBarItemTapped(int index) {
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else if (index == 2) {
      Navigator.pushNamedAndRemoveUntil(context, '/bucket', (route) => false);
    }
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
      body: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onTap: (){
                Navigator.pushReplacementNamed(context, '/asian');
              },
              child: CategoryItem(category: categories[index]),
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

class Category {
  final String name;
  final String imageUrl;

  Category({
    required this.name,
    required this.imageUrl,
  });
}

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 148,
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Stack(
          children: [
            Image(image: NetworkImage(category.imageUrl),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
