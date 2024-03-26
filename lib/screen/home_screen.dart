import 'package:dusty_dust/component/category_card.dart';
import 'package:dusty_dust/component/hourly_card.dart';
import 'package:dusty_dust/component/main_app_bar.dart';
import 'package:dusty_dust/component/main_drawer.dart';
import 'package:dusty_dust/const/colors.dart';
import 'package:dusty_dust/const/status_level.dart';
import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/repository/stat_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<StatModel>> fetchData() async {
    final statModels = await StatRepository.fetchData();

    return statModels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      drawer: MainDrawer(),
      body: FutureBuilder<List<StatModel>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // 에러가 있을때
            return Center(
              child: Text('에러가 있습니다.'),
            );
          }
          if (!snapshot.hasData) {
            // 로딩 상태
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<StatModel> stats = snapshot.data!;
          StatModel recentStat = stats[0];

          // 1 - 5, 6 - 10, 11 - 15
          // 7
          final status = statusLevel
              .where(
                (element) => element.minFineDust < recentStat.seoul,
              )
              .last;

          return CustomScrollView(
            slivers: [
              MainAppBar(
                stat: recentStat,
                status: status,
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CategoryCard(),
                    SizedBox(height: 16.0),
                    HourlyCard(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
