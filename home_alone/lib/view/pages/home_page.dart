import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:home_alone/dependency_injection/locator.dart';
import 'package:home_alone/service/challenge/challenge_api.dart';
import 'package:home_alone/service/challenge_search_delegate.dart';
import 'package:home_alone/view/pages/dashboard_page.dart';
import 'package:home_alone/view/pages/settings_page.dart';
import 'package:home_alone/view/theme/border.dart';
import 'package:home_alone/view/theme/colors.dart';
import 'package:home_alone/view/theme/icons.dart';
import 'package:home_alone/view/widgets/themed_app_bar.dart';
import 'package:home_alone/viewmodel/app_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'challenge_list_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  TabController _tabController;
  int currentTabIndex;

  @override
  void initState() {
    _tabController =
        TabController(vsync: this, length: _navigationItems.length);
    _tabController.addListener(_onIndexChanged);
    super.initState();
  }

  void _onIndexChanged() {
    setState(() {
      if (!_tabController.indexIsChanging) {
        currentTabIndex = _tabController.index;
        Provider.of<AppModel>(context, listen: false).tab =
            Tabs.values[currentTabIndex];
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  _onRefresh() async {
    // final weatherStore = locator.get<WeatherStore>();
    // await weatherStore.loadWeatherForecast("Darmstadt");
    // await weatherStore.loadCurrentWeather("Darmstadt");
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    // var model = Provider.of<WeatherModel>(context);
    return Scaffold(
        appBar: _buildAppBar(context),
        body: _buildContent(context),
        bottomNavigationBar: _buildTabBar(context));
  }

  AppBar _buildAppBar(
    BuildContext context,
  ) {
    return ThemedAppBar(
      title: Provider.of<AppModel>(context).currentTabTitle,
      showLogo: true,
      actions: currentTabIndex != 2
          ? _buildSearchAction(context)
          : _buildLogoutAction(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: TabBarView(controller: _tabController, children: [
        DashboardPage(),
        ChallengeListPage(),
        SettingsPage(),
      ]),
    );
  }

  static Widget loadTabIcon(String imageName) {
    return Image.asset(
      "assets/image/$imageName.png",
      width: 28,
      height: 28,
    );
  }

  Widget _buildTabBar(BuildContext context) => Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: TabBar(
          controller: _tabController,
          indicator: ShapeDecoration(
              shape: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 0,
                      style: BorderStyle.solid)),
              gradient: LinearGradient(
                colors: [
                  HomeAloneColors.primaryButtonGradientStartColor,
                  HomeAloneColors.primaryButtonGradientEndColor,
                ],
              )),
          unselectedLabelColor: Colors.white,
          labelColor: Theme.of(context).hintColor,
          tabs: _navigationItems,
        ),
      );

  final _navigationItems = <Widget>[
    Tab(icon: loadTabIcon("home"), text: "Entdecken"),
    Tab(icon: loadTabIcon("challenges"), text: "Meine Challenges"),
    Tab(icon: loadTabIcon("settings"), text: "Einstellungen"),
  ];

  List<Widget> _buildSearchAction(
    BuildContext context,
  ) {
    return <Widget>[
      IconButton(
        icon: Icon(HomeAloneIcons.search, size: 20),
        onPressed: () {
          showSearch(
            context: context,
            delegate: ChallengeSearchDelegate(
              // model,
              locator.get<ChallengeApi>(),
              keyboardType: TextInputType.text,
              searchFieldLabel: "Name der Challenge ...",
            ),
          );
        },
      )
    ];
  }

  List<Widget> _buildLogoutAction(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Image.asset("assets/image/log_out.png"),
        onPressed: () {
          locator.get<FlutterSecureStorage>().delete(key: "token");
          locator.get<FlutterSecureStorage>().delete(key: "user");
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/login", (route) => false);
        },
      )
    ];
  }
}
