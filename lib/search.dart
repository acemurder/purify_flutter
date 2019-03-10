import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purify_flutter/config.dart';
import 'package:purify_flutter/util.dart';

class SearchWidget extends StatefulWidget {
  SearchWidget({Key key}) : super(key: key);

  @override
  _SearchWidgetState createState() => new _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget>
    with WidgetsBindingObserver {
  final TextEditingController _controller = new TextEditingController();
  bool _loading = false;
  bool _downloading = false;
  String _imgUrl;
  String _videoDownloadUrl;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      new Row(
        children: <Widget>[
          new Expanded(
              child: new Container(
                height: 45,
                constraints: new BoxConstraints(
                  minHeight: 45.0,
                  maxHeight: 45.0,
                ),
                margin: EdgeInsets.only(top: 20, left: 5),
                padding: EdgeInsets.only(left: 5, right: 5),
                child: new TextField(
                  maxLines: 1,
                  cursorColor: colorPrimary,
                  controller: _controller,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.search,
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0x2F9E9E9E),
                    hintText: '输入url',
                    prefixIcon: Icon(Icons.insert_link),
                  ),
                ),
              ),
              flex: 8),
          new Expanded(
            child: new Container(
                height: 45,
                margin: EdgeInsets.only(top: 20, right: 5),
                constraints: new BoxConstraints(
                  minHeight: 45.0,
                  maxHeight: 45.0,
                ),
                child: new RaisedButton(
                  textColor: Color(0xFFFFFFFF),
                  color: colorPrimary,
                  onPressed: () {
                    if (_downloading) {
                      debugPrint("click:视频下载中");
                      return;
                    }
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      _loading = true;
                    });
                    _handleUrl(_controller.text);
                  },
                  child: new Center(child: new Text('搜索视频')),
                )),
            flex: 3,
          )
        ],
      ),
      new Container(alignment: Alignment.center, child: _buildResultWidget())
    ]);
  }

  Widget _buildResultWidget() {
    if (_loading)
      return new Container(
        height: 80,
        width: 80,
        margin: EdgeInsets.only(left: 15, right: 15, top: 40, bottom: 0),
        child: CircularProgressIndicator(),
      );
    else if (_imgUrl != null) {
      return new Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(left: 15, right: 15, top: 30),
          constraints: new BoxConstraints(
            minHeight: 300,
            minWidth: 200,
            maxHeight: 600,
            maxWidth: 400,
          ),
          child: new Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              new GestureDetector(
                onTap: () {
                  if (_downloading) {
                    debugPrint("click:视频下载中");
                    return;
                  }
                  showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                            content: new Text("下载视频"),
                            actions: <Widget>[
                              new FlatButton(
                                  onPressed: () {
                                    debugPrint("下载 click");
                                    _download(_videoDownloadUrl, context);
                                    Navigator.of(context).pop();
                                  },
                                  child: new Text("下载")),
                              new FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: new Text("取消"))
                            ],
                          ));
                },
                child: new Image.network(_imgUrl),
              ),
              new Positioned(
                child: new Offstage(
                  offstage: (!_downloading),
                  child: new Container(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(value: _progress),
                  ),
                ),
              )
            ],
          ));
    } else
      return Container();
  }

  _handleUrl(String shareUrl) async {
    try {
      dClient.interceptors.add(redirectUrlInterceptor);
      Response r = await dClient.get(Uri.parse(shareUrl).toString(),
          options: Options(followRedirects: false));
      String id = r.data;
      dClient.interceptors.remove(redirectUrlInterceptor);
      r = await dClient.get(dPath, queryParameters: generateDParam(id));
      String coverUrl = r.data["aweme_detail"]["video"]["cover"]["url_list"][0];
      String downloadUrl =
          r.data["aweme_detail"]["video"]["play_addr"]["url_list"][0];
      debugPrint("$coverUrl , $downloadUrl");
      setState(() {
        _loading = false;
        _imgUrl = coverUrl;
        _videoDownloadUrl = downloadUrl;
      });
    } catch (e) {
      debugPrint(e);
    }
  }

  void _download(String url, BuildContext context) async {
    bool permitted = await checkStoragePermission();
    if (!permitted) {
      permitted = await requestStoragePermission();
      if (!permitted) return;
    }
    String path = await getSavePath();
    setState(() {
      _downloading = true;
      _progress = 0;
    });

    try {
      Response r = await dClient.downloadUri(Uri.parse(url), path,
          options: new Options(receiveTimeout: 30 * 1000),
          onReceiveProgress: (count, total) => {
                debugPrint("progress:${count / total}"),
                setState(() {
                  _progress = count / total;
                })
              });
      if (r.statusCode == 200) {
        setState(() {
          _downloading = false;
        });
        _showDownloadMsgDialog(context, "视频已下载到 $path");
      }
    } catch (e) {
      setState(() {
        _downloading = false;
      });
      _showDownloadMsgDialog(context, "视频下载失败");
      debugPrint(e);
    }
  }

  void _showDownloadMsgDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("下载"),
              content: new Text(message),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: new Text("知道了"))
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debugPrint('initState');
  }

  @override
  void didUpdateWidget(SearchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      debugPrint("resumed");
      ClipboardData data = await Clipboard.getData("text/plain");
      if (data == null || data.text == null || data.text.isEmpty) {
        return;
      }
      debugPrint(data.text);
      var reg = new RegExp(r'[a-zA-z]+://[^\s]*');
      if (reg.hasMatch(data.text)) {
        String videoUrl = reg.firstMatch(data.text).group(0);
        debugPrint(videoUrl);
        setState(() {
          _controller.text = videoUrl;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    print('dispose');
  }
}
