import 'package:ChineseAppRemover/appsList.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:uninstall_apps/uninstall_apps.dart';
import 'package:flutter_install_app_plugin/flutter_install_app_plugin.dart';

import 'constants.dart';

class Body extends StatefulWidget {
  final Function(String text) onChangeText;
  Body({this.onChangeText});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with WidgetsBindingObserver {
  List<Application> appsList;

  List currAppDetails = ['', -1];

 

  getApps() async {
    print('getting apps data....');
    var appsListFetch = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: false,
        includeAppIcons: true);
    appsListFetch.removeWhere(
        (item) => !appsToRemove.contains(item.packageName));
    setState(() {
      appsList = appsListFetch;
    });
  }

  Future<void> initPlatformState(app, index) async {
    await UninstallApps.uninstall(app);
    currAppDetails[0] = app;
    currAppDetails[1] = index;
  }

  appRemover(appPackageName, index) {
    Future.delayed(const Duration(seconds: 4)).then((value) async {
      print('Times up Executing on index $index named $appPackageName');

      if (index != -1) {
        bool isInstalled = await DeviceApps.isAppInstalled(appPackageName);
        if (!isInstalled) {
          try {Application itemToRemove = appsList[index];

          _listKey.currentState.removeItem(
            index,
            (BuildContext context, Animation<double> animation) =>
                _buildItem(context, itemToRemove, animation, index),
            duration: const Duration(milliseconds: 500),
          );

          appsList.removeAt(index);
          currAppDetails[0] = '';
          currAppDetails[1] = -1;
          setState(() {
            appsList.length;
          });} catch(e){print(e);}
        }
      }
    });
  }

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getApps();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        appRemover(currAppDetails[0], currAppDetails[1]);
        break;
      case AppLifecycleState.detached:
        print('Detached');
        break;
      case AppLifecycleState.inactive:
        print('inactive');
        break;
      case AppLifecycleState.paused:
        print('Paused');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (reget) {
      setState(() {
        appsList = null;
        reget = false;
      });
      getApps();
    }

    return appsList != null
        ? (appsList.length != 0
            ? SizedBox(
                height: 330,
                child: AnimatedList(
                  physics: BouncingScrollPhysics(),
                  key: _listKey,
                  initialItemCount: appsList.length,
                  itemBuilder: (context, index, animation) =>
                      _buildItem(context, appsList[index], animation, index),
                ),
              )
            : Center(
                child: Text('You just killed the Dragon.', style: listText)))
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget _buildItem(
      BuildContext context, app, Animation<double> animation, index) {
    String packageName = app.packageName;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: ScaleTransition(
        scale: animation,
        // axis: Axis.vertical,
        child: Container(
          height: 65.0,
          decoration: BoxDecoration(
            color: white8,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: ListTile(
              leading: app is ApplicationWithIcon
                  ? CircleAvatar(
                      radius: 18,
                      backgroundImage: MemoryImage(app.icon),
                      backgroundColor: Colors.transparent,
                    )
                  : null,
              title: Text(
                '${app.appName}',
                style: listText,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: white70,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.all(15),
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                backgroundColor: canvas,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Alternatives',
                                      style: listText,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount:
                                              alternatives[packageName]!=null ? alternatives[packageName].length: 0,
                                          itemBuilder:
                                              (BuildContext ctxt, int index) {
                                            String altName =
                                                alternatives[packageName]
                                                    [index];
                                                    
                                            String link =
                                                downloadLinks[altName.toLowerCase()] ?? 'http://google.com';
                                                print('altname: $altName and link: $link');

                                                
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 60.0,
                                                decoration: BoxDecoration(
                                                    color: white8,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: ListTile(
                                                  title: Text(
                                                    altName,
                                                    style: listText,
                                                  ),
                                                  trailing: IconButton(
                                                    icon: Icon(
                                                      Icons.file_download,
                                                      color: white70,
                                                    ),
                                                    onPressed: () {
                                                      var playStoreLink = AppSet()
                                                        ..androidPackageName =
                                                            link;
                                                      FlutterInstallAppPlugin
                                                          .installApp(
                                                              playStoreLink);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          //  <Widget>[
                                          //   for (var value in alternatives[
                                          //       name.toLowerCase()])
                                          //     Padding(
                                          //       padding: const EdgeInsets.all(8.0),
                                          //       child: Container(
                                          //         height: 60.0,
                                          //         decoration: BoxDecoration(
                                          //             color: white8,
                                          //             borderRadius:
                                          //                 BorderRadius.all(
                                          //                     Radius.circular(10))),
                                          //         child: ListTile(
                                          //           title: Text(
                                          //             value,
                                          //             style: listText,
                                          //           ),
                                          //           trailing: IconButton(
                                          //             icon: Icon(
                                          //               Icons.file_download,
                                          //               color: white70,
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     )
                                          // ],
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: white70,
                    ),
                    onPressed: () {
                      initPlatformState(app.packageName, index);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
