import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Nav extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NavState();
  }
}

class NavState extends State<Nav> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Main navigator'),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                color: const Color.fromARGB(255, 227, 207, 207),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => CupertinoTabsExample(),
                    ),
                  );
                },
                child: const Text('Cupertino tabs example'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PageV()),
                );
              },
              child: Text('PageView example'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TabsExample()),
                );
              },
              child: Text('Material tabs example test'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              width: MediaQuery.of(context).size.width / 1.2,
              child: Row(
                children: [
                  NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    labelType: NavigationRailLabelType
                        .selected, // Показывать подпись только для выбранного
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Главная'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Избранное'),
                        indicatorColor: Colors.amber,
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text('Настройки'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: DefaultTextStyle(
                        style: CupertinoTheme.of(context).textTheme.textStyle,
                        child: Text('Выбран пункт $_selectedIndex'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Hero(
              tag: 'profile-pic',
              child: Icon(Icons.help_rounded, size: 100),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline_outlined, size: 30),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Подтверждение"),
                      content: Text("Вы точно хотите удалить элемент?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("Отмена"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text("Удалить"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => Container(
                    height: 200,
                    child: Center(child: Text("Выбор действия")),
                  ),
                );
              },
              icon: Icon(Icons.move_down),
            ),
          ],
        ),
      ),
    );
  }
}

class FakePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // 👈 вот здесь Drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              // верхняя часть меню
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Меню",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Главная"),
              onTap: () {
                Navigator.pop(context); // закрыть Drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Настройки"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(),
      body: Text('Test page', style: TextStyle(fontSize: 30)),
    );
  }
}

class TabsExample extends StatefulWidget {
  @override
  _TabsExampleState createState() => _TabsExampleState();
}

class _TabsExampleState extends State<TabsExample>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (dipPop, result) async {
        if (dipPop) return;
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Выход'),
            content: Text('Точно выйти из приложения?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Нет'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text('Да'),
              ),
            ],
          ),
        );

        if (shouldExit ?? false) {
          Navigator.of(context).pop();
          print(result);
          // вручную выходим
        }
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text("TabBar Example"),
          bottom: TabBar(
            indicatorColor: Colors.amber,
            controller: _tabController,
            tabs: [
              Tab(
                icon: Icon(Icons.home, color: Colors.amber),
                text: "Главная",
              ),
              Tab(icon: Icon(Icons.favorite), text: "Избранное"),
              Tab(icon: Icon(Icons.settings), text: "Настройки"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Column(
              children: [
                Text('any context'),
                Text('any way'),
                Hero(
                  tag: 'profile-pic',
                  child: Icon(Icons.help_rounded, size: 100),
                ),
              ],
            ),
            Center(child: Text("Избранное")),
            Center(child: Text("Настройки")),
          ],
        ),
      ),
    );
  }
}

class CupertinoTabsExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoTabScaffold(
        // 1️⃣ Вкладки внизу
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.heart),
              label: 'Избранное',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: 'Настройки',
            ),
          ],
        ),
        // 2️⃣ Контент вкладок
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(middle: Text('Главная')),
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    Text('Это главная вкладка', style: TextStyle(fontSize: 24)),
                    Hero(
                      tag: 'profile-pic',
                      child: Icon(Icons.help_rounded, size: 150),
                    ),
                  ],
                ),
              );
            case 1:
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: Text('Избранное'),
                ),
                child: Center(
                  child: Text('Избранное', style: TextStyle(fontSize: 24)),
                ),
              );
            case 2:
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: Text('Настройки'),
                ),
                child: Center(
                  child: Text('Настройки', style: TextStyle(fontSize: 24)),
                ),
              );
            default:
              return Container();
          }
        },
      ),
    );
  }
}

class PageV extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SPageV();
  }
}

class SPageV extends State<PageV> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(parent: animController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    animController.dispose();
    super.dispose();
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageView(
      onPageChanged: (int index) {
        setState(() {
          _currentIndex = index;
          animController.forward(from: 0);
        });
      },
      controller: _pageController,
      children: [
        Container(
          color: Colors.blue,
          child: Center(child: Text('Page 1')),
        ),
        Container(
          color: const Color.fromARGB(255, 237, 217, 216),
          child: Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Text('Popping text!'),
            ),
          ),
        ),

        Container(
          color: Colors.yellow,
          child: Center(child: Text('Page 3')),
        ),
      ],
    );
  }
}
