import 'package:flutter/material.dart';
import 'package:flutter/src/services/message_codec.dart';
import 'package:media_explorer/model/photo_provider.dart';
import 'package:media_explorer/widget/common_drawer.dart';
import 'package:media_explorer/widget/gallery_item_widget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class GalleryListPage extends StatefulWidget {
  const GalleryListPage({Key key}) : super(key: key);

  @override
  _GalleryListPageState createState() => _GalleryListPageState();
}

class _GalleryListPageState extends State<GalleryListPage> {

  PhotoProvider get provider => Provider.of<PhotoProvider>(context);

  @override
  void initState() {
    super.initState();
    //provider.refreshGalleryList();
    //PhotoManager.addChangeCallback(onChange);
    //PhotoManager.setLog(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Media Explorer"),
      ),
      drawer: Drawer(
        child: ListView.builder(
                itemBuilder: _buildItem,
                itemCount: provider.list.length,
              ),
            ),
      ///HomeDrawer(provider),
      ///
      /// ///Navigator.of(context).push(
      //          MaterialPageRoute(
      //            builder: (_) => GalleryContentListPage(
      //              path: item,
      //            ),
      //          ),
      //        );
      body: Container(
        /*child: Scrollbar(
          child: ListView.builder(
            itemBuilder: _buildItem,
            itemCount: provider.list.length,
          ),
        ),*/
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

  void onChange(call) {}

}
