import 'dart:async';

import 'package:flutter/material.dart';
import 'package:balloon/components/body_builder.dart';
import 'package:balloon/view_models/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:balloon/routes/router_tables.dart';
import 'package:bouncing_widget/bouncing_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  double _scaleFactor = 1.0;

  _onPressed(BuildContext context) {
    Timer(Duration(milliseconds: 500), () {
      Navigator.pushNamed(
        context,
        RouterTables.wordPath,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<HomeProvider>(
      builder: (BuildContext context, HomeProvider homeProvider, child) {
        return Scaffold(
          body: _buildBody(homeProvider),
        );
      },
    );
  }

  Widget _buildBody(HomeProvider homeProvider) {
    return BodyBuilder(
      apiRequestStatus: homeProvider.apiRequestStatus,
      child: _buildBodyList(homeProvider),
      reload: () => homeProvider.getFeeds(),
    );
  }

  Widget _buildBodyList(HomeProvider homeProvider) {
    homeProvider.changeScreenLoaded();

    return Container(
      child: _buildWordNavigator(),
    );
    // Stack(
    //   children: [
    //     ListView(
    //       children: <Widget>[
    //         Image.network(
    //           'https://img.wenjutv.net/questions/20190318/fd57630c3b3a20cba6e6bf6ce1057fad.jpg',
    //           height: 180,
    //           width: double.infinity,
    //           fit: BoxFit.cover,
    //         ),
    //         SizedBox(height: 30.0),
    //         Container(
    //           padding: EdgeInsets.symmetric(horizontal: 20),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 "It's about how hard you can get hit and keep moving forward, How much you can take and keep moving forward.",
    //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //               ),
    //               SizedBox(height: 15.0),
    //               Text(
    //                 "你能承受多少并且能一直向前",
    //                 style: TextStyle(
    //                   fontSize: 15,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }

  Widget _buildWordNavigator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              child: BouncingWidget(
                scaleFactor: _scaleFactor,
                onPressed: () => _onPressed(context),
                child: Container(
                  height: 60,
                  width: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      'Subscribe',
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: BouncingWidget(
            scaleFactor: _scaleFactor,
            onPressed: () {
              _onPressed(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
