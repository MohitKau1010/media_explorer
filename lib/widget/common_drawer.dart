import 'package:flutter/material.dart';
import 'package:media_explorer/model/photo_provider.dart';
import 'package:media_explorer/utils/navigators.dart';
import 'package:media_explorer/widget/gallery_item_widget.dart';
import 'package:provider/provider.dart';


class HomeDrawer extends StatefulWidget {

  final PhotoProvider provider;

  const HomeDrawer(this.provider, {Key key}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  PhotoProvider get provider => widget.provider;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              image: new DecorationImage(
                image: NetworkImage('https://static.vecteezy.com/system/resources/previews/000/257/814/non_2x/vector-vintage-background.jpg'),
                fit: BoxFit.cover,
              ),

              color: Colors.black,
            ),
            accountName: Text(
              "Mohit Kaushik",
              style: TextStyle(fontFamily: "Bal"),
            ),
            accountEmail: Text(
              "mohit@infostride.com",
              style: TextStyle(fontFamily: "Bal"),
            ),
            currentAccountPicture: new CircleAvatar(
              backgroundImage: new NetworkImage(
                  'https://scontent-del1-1.xx.fbcdn.net/v/t1.0-9/95240835_3691097090965455_5920649517463502848_o.jpg?_nc_cat=100&_nc_sid=dd9801&_nc_ohc=TloDY4q6fK8AX9zt0jn&_nc_ht=scontent-del1-1.xx&oh=baa08a0f6a7580d01ba3991b6c4fed45&oe=5EFDC4A5'),
            ),
          ),
          /*Container(
            child: Scrollbar(
              child: ListView.builder(
                itemBuilder: _buildItem,
                itemCount: provider.list.length,
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = provider.list[index];
    return GalleryItemWidget(
      path: item,
      setState: setState,
    );
  }
}
