import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:media_explorer/model/photo_provider.dart';
import 'package:media_explorer/screen/detail_page.dart';
import 'package:media_explorer/widget/change_notifier_builder.dart';
import 'package:media_explorer/widget/gallery_item_widget.dart';
import 'package:media_explorer/widget/image_item_widget.dart';
import 'package:media_explorer/widget/list_dialog.dart';
import 'package:media_explorer/widget/loading_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class GalleryContentListPage extends StatefulWidget {
  final AssetPathEntity path;

  ///default 0

  const GalleryContentListPage({Key key, this.path}) : super(key: key);

  @override
  _GalleryContentListPageState createState() => _GalleryContentListPageState();
}

class _GalleryContentListPageState extends State<GalleryContentListPage> {
  AssetPathEntity get path => widget.path;

  bool _isEditMode = false;

  PhotoProvider get providers => Provider.of<PhotoProvider>(context);

  PhotoProvider get photoProvider => Provider.of<PhotoProvider>(context);

  AssetPathProvider get provider =>
      Provider.of<PhotoProvider>(context).getOrCreatePathProvider(path);

  List<AssetEntity> checked = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierBuilder(
      value: provider,
      builder: (_, __) {
        var length = path.assetCount;
        return Scaffold(
          appBar: AppBar(
            title: Text("${path.name}"),
            actions: <Widget>[
              toolbarEditMode(),
              ChangeNotifierBuilder(
                builder: (context, provider) {
                  final formatType =
                      provider.thumbFormat == ThumbFormat.jpeg ? ThumbFormat.png : ThumbFormat.jpeg;
                  return IconButton(
                    icon: Icon(Icons.settings),
                    iconSize: 22,
                    tooltip: "Use another format.",
                    onPressed: () {
                      provider.thumbFormat = formatType;

                      ///toggle editmode...
                      if (_isEditMode) {
                        _isEditMode = false;
                      } else {
                        _isEditMode = true;
                      }
                    },
                  );
                },
                value: photoProvider,
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView.builder(
              itemBuilder: _buildDrawerItem,
              itemCount: provider.list.length,
            ),
          ),
          body: buildRefreshIndicator(length),
        );
      },
    );
  }

  Widget toolbarEditMode() {
    if (_isEditMode) {
      return IconButton(
        icon: Icon(
          Icons.delete,
        ),
        tooltip: 'Delete selected',
        onPressed: () {
          provider.deleteSelectedAssets(checked);
        },
      );
    } else {
      return Container();
    }
  }

  Widget buildRefreshIndicator(int length) {
    if (!provider.isInit) {
      provider.onRefresh();
      return Center(
        child: Text("loading"),
      );
    }
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scrollbar(
        child: GridView.builder(
          itemBuilder: _buildItem,
          itemCount: provider.showItemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final list = provider.list;
    if (list.length == index) {
      onLoadMore();
      return loadWidget;
    }

    if (index > list.length) {
      return Container();
    }

    final entity = list[index];

    Widget previewOriginBytesWidget;

    ///  jkdckjwc;lkjdwckljdl;kcjsdl;kcj;lsdkjc;lksdjckl;jsdl;ckjsl
    ///  jkdckjwc;lkjdwckljdl;kcjsdl;kcj;lsdkjc;lksdjckl;jsdl;ckjsl
    ///  jkdckjwc;lkjdwckljdl;kcjsdl;kcj;lsdkjc;lksdjckl;jsdl;ckjsl
    ///  jkdckjwc;lkjdwckljdl;kcjsdl;kcj;lsdkjc;lksdjckl;jsdl;ckjsl
    ///  jkdckjwc;lkjdwckljdl;kcjsdl;kcj;lsdkjc;lksdjckl;jsdl;ckjsl
    ///  jkdckjwc;lkjdwckljdl;kcjsdl;kcj;lsdkjc;lksdjckl;jsdl;ckjsl
    ///  jkdckjwc;lkjdwckljdl;kcjsdl;kcj;lsdkjc;lksdjckl;jsdl;ckjsl
    if (entity.type != AssetType.image) {
      previewOriginBytesWidget = Container();
    } else {
      previewOriginBytesWidget = RaisedButton(
        child: Text("Show origin bytes image in dialog"),
        onPressed: () => showOriginBytes(entity),
      );
    }
    return GestureDetector(
      onTap: () {
        routeToDetailPage(entity);
      },

      /*onTap: () async {
        showDialog(
          context: context,
          builder: (_) => ListDialog(
            children: <Widget>[
              previewOriginBytesWidget,
              RaisedButton(
                child: Text("Show detail page"),
                onPressed: () => routeToDetailPage(entity),
              ),
              RaisedButton(
                child: Text("show 500 size thumb "),
                onPressed: () => showThumb(entity, 500),
              ),
              RaisedButton(
                child: Text("Delete item"),
                onPressed: () => _deleteCurrent(entity),
              ),
              RaisedButton(
                child: Text("Upload to my test server."),
                //onPressed: () => UploadToDevServer().upload(entity),
              ),
              RaisedButton(
                child: Text("Copy to another path"),
                //onPressed: () => copyToAnotherPath(entity),
              ),
              //_buildMoveAnotherPath(entity),
              _buildRemoveInAlbumWidget(entity),
            ],
          ),
        );
      },*/
      onLongPress: () {
        if (checked.contains(entity)) {
          checked.remove(entity);
        } else {
          checked.add(entity);
        }
        setState(() {
          //_isEditMode=true;
        });
      },
      child: Stack(
        children: [
          ImageItemWidget(
            key: ValueKey(entity),
            entity: entity,
          ),

          ///checkBox
          _checkBox(entity),
        ],
      ),
    );
  }

  Widget _checkBox(AssetEntity entity) {
    if (_isEditMode) {
      return Align(
        alignment: Alignment.topRight,
        child: Checkbox(
          value: checked.contains(entity),
          onChanged: (value) {
            if (checked.contains(entity)) {
              checked.remove(entity);
            } else {
              checked.add(entity);
            }
            setState(() {
              /// _isEditMode=false;
            });
          },
        ),
      );
    } else {
      return Container();
    }
  }

  void routeToDetailPage(AssetEntity entity) async {
    final mediaUrl = await entity.getMediaUrl();
    final page = DetailPage(
      entity: entity,
      mediaUrl: mediaUrl,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }

  Future<void> onLoadMore() async {
    if (!mounted) {
      return;
    }
    await provider.onLoadMore();
  }

  Future<void> _onRefresh() async {
    if (!mounted) {
      return;
    }
    await provider.onRefresh();
  }

  void _deleteCurrent(AssetEntity entity) async {
    if (Platform.isAndroid) {
      final dialog = AlertDialog(
        title: Text("Delete the asset"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "delete",
              style: const TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              provider.delete(entity);
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text("cancel"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
      showDialog(context: context, builder: (_) => dialog);
    } else {
      provider.delete(entity);
    }
  }

  Future<void> showOriginBytes(AssetEntity entity) async {
    var title = entity.title;
    if (entity.title == null || entity.title.isEmpty) {
      title = await entity.titleAsync;
    }
    print("entity.title = $title");
    if (title.toLowerCase().endsWith(".heic")) {
      showToast("Heic no support by Flutter. Try to use entity.thumbDataWithSize to get thumb.");
      return;
    }
    showDialog(
        context: context,
        builder: (_) {
          return FutureBuilder<Uint8List>(
            future: entity.originBytes,
            builder: (BuildContext context, snapshot) {
              Widget w;
              if (snapshot.hasError) {
                return ErrorWidget(snapshot.error);
              } else if (snapshot.hasData) {
                w = Image.memory(snapshot.data);
              } else {
                w = Center(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return GestureDetector(
                child: w,
                onTap: () => Navigator.pop(context),
              );
            },
          );
        });
  }

  /*void copyToAnotherPath(AssetEntity entity) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CopyToAnotherGalleryPage(
          assetEntity: entity,
        ),
      ),
    );
  }*/

  Widget _buildRemoveInAlbumWidget(AssetEntity entity) {
    if (!(Platform.isIOS || Platform.isMacOS)) {
      return Container();
    }

    return RaisedButton(
      child: Text("Remove in album"),
      onPressed: () => deleteAssetInAlbum(entity),
    );
  }

  void deleteAssetInAlbum(entity) {
    provider.removeInAlbum(entity);
  }

  Widget _buildDrawerItem(BuildContext context, int index) {
    final item = providers.list[index];
    _isEditMode = false;
    return GalleryItemWidget(
      path: item,
      setState: setState,
    );
  }

  /* Widget _buildMoveAnotherPath(AssetEntity entity) {
    if (!Platform.isAndroid) {
      return Container();
    }
    return RaisedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return MoveToAnotherExample(entity: entity);
        }));
      },
      child: Text("Move to another gallery."),
    );
  }*/

  showThumb(AssetEntity entity, int size) async {
    var title = entity.title;
    if (entity.title == null || entity.title.isEmpty) {
      title = await entity.titleAsync;
    }
    print("entity.title = $title");
    if (title.toLowerCase().endsWith(".heic")) {
      showToast("Heic no support by Flutter. Try to use entity.thumbDataWithSize to get thumb.");
      return;
    }
    showDialog(
        context: context,
        builder: (_) {
          return FutureBuilder<Uint8List>(
            future: entity.thumbDataWithSize(size, size),
            builder: (BuildContext context, snapshot) {
              Widget w;
              if (snapshot.hasError) {
                return ErrorWidget(snapshot.error);
              } else if (snapshot.hasData) {
                w = Image.memory(snapshot.data);
              } else {
                w = Center(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return GestureDetector(
                child: w,
                onTap: () => Navigator.pop(context),
              );
            },
          );
        });
  }
}
