import 'package:flutter/material.dart';
import 'package:flutterbook/api/book_api.dart';
import 'package:flutterbook/notifiers/auth_notifier.dart';
import 'package:flutterbook/screens/authenticate/product_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          decoration: BoxDecoration(color: Colors.brown[400]),
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          child: Container(),
        );
      });
    }

    return DefaultTabController(
          length: 4,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.coffee, color: Colors.white, size: 18,),
                    onPressed: () {
                      _showSettingsPanel();
                    },
                  ),
                  IconButton(
                      onPressed: () {
                        signOut(authNotifier);
                      },
                      icon: Icon(FontAwesomeIcons.user, color: Colors.white, size: 18,),
                      ),

                ],
                title: Text(authNotifier.user != null ? 'Catálogo de ${authNotifier.user.displayName}' : 'Catálogo', style: TextStyle(fontFamily: 'Aladin', fontSize: 30, color: Colors.yellow[300]),),
                bottom: TabBar(
                  labelColor: Colors.white,
                  isScrollable: false,
                  labelStyle: TextStyle(fontFamily: 'Roboto', fontSize: 14),
                  indicatorColor: Colors.yellow[200],
                  tabs: <Widget>[
                    Tab(icon: Icon(FontAwesomeIcons.shoppingBag,), text: 'Catalog',),
                      Tab(icon: Icon(FontAwesomeIcons.solidAddressBook), text: 'Clients'),
                    Tab(icon: Icon(FontAwesomeIcons.solidStickyNote), text: 'Notes'),
                    Tab(icon: Icon(FontAwesomeIcons.tasks), text: 'Tasks'),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  ProductList(),
                  Container(),
//                  decoration: BoxDecoration(
//                    image: DecorationImage(image: AssetImage('images/coffee2.jpg'), fit: BoxFit.cover),
//                  ),),
                  Container(),
                  Container(),
                ],
              ),
            ),
        );
  }
}
