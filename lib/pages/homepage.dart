import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:glorify_news/pages/widgets/appTitle.dart';
import 'package:glorify_news/services/apimanager.dart';
import 'package:glorify_news/services/models/newsInfo.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsHome extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<NewsHome> {
  Future <void> _launched;
  
  Future<void> _launchInBrowser(String url) async{
    if (await canLaunch(url)){
      await launch(url,forceSafariVC:false,forceWebView:false,);
    }
  }
  Future<NewsModel> _newsModel;
  @override
  void initState() {
    _newsModel = ApiManager().getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width,
        _screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title:Apptitle("Glorify", "News", 24, 28),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.blue),
        actions: [
          IconButton(icon: Icon(Icons.account_circle), onPressed: () {})
        ],
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
      ),
      body: Container(
        child: FutureBuilder<NewsModel>(
          future: _newsModel,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount:  snapshot.data.articles.length==null ? 0 : snapshot.data.articles.length,
                  itemBuilder: (context, index) {
                    var article = snapshot.data.articles[index];
                    return Container(
                      margin: const EdgeInsets.all(8),
                      height: _screenheight*0.15,
                      child: GestureDetector(onTap: (){

                        _launchInBrowser(article.url);
                      },
                                              child: Row(
                          children: <Widget>[
                            Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                                child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Image.network(
                                      article.urlToImage,
                                      fit: BoxFit.cover,
                                    ))),
                            SizedBox(width: 16),
                            Flexible(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.title,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical:8.0),
                                      child: Text(
                                        article.description,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    ),
                                    article.author != null
                                        ? Column(mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(article.author,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    
                                                    fontSize: 12)),
                                          ],
                                        )
                                        : Container(),
                                         article.publishedAt != null
                                        ? Row(mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(article.publishedAt.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    
                                                    fontSize: 15)),
                                          ],
                                        )
                                        : Container(),
                                  ]),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else
              return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

}
