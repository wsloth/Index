import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:index/models/article-details-model.dart';
import 'package:index/services/article-service.dart';
import 'package:index/views/pages/article/comment-section.dart';
import 'package:index/widgets/error.dart';
import 'package:index/widgets/separator.dart';
import 'package:index/widgets/shimmer.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'package:index/models/article-model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'article/slider-header.dart';

class ArticlePage extends StatefulWidget {
  final ArticleModel article;

  ArticlePage({this.article});

  @override
  _ArticlePageState createState() => _ArticlePageState(article);
}

class _ArticlePageState extends State<ArticlePage> {
  final ArticleModel article;
  Stream<List<ArticleCommentModel>> commentSectionStream;
  StreamController<List<ArticleCommentModel>> commentStreamController;
  List<ArticleCommentModel> currentCommentsList = [];
  StreamSubscription commentSteamSubscription;
  bool webviewIsLoading = false;
  bool startedLoadingComments = false;

  _ArticlePageState(this.article);

  @override
  void initState() {
    super.initState();
    _fetchArticleDetails();
  }

  _fetchArticleDetails() async {
    final service = ArticleService();
    commentStreamController = StreamController();
    commentSectionStream = service.streamCommentSectionAsync(article);
    commentSteamSubscription = commentSectionStream.listen((commentsList) {
      currentCommentsList = commentsList;
      commentStreamController.add(commentsList);
      commentSteamSubscription.pause();
    });
    commentSteamSubscription.pause();
  }

  _startLoadingComments() {
    if (!startedLoadingComments) {
      commentSteamSubscription.resume();
    }
  }

  _loadNextComment() {
    if (startedLoadingComments) {
      List<ArticleCommentModel> commentsList = currentCommentsList.map((x) => x).toList();
      commentsList.add(ArticleCommentModel());
      commentStreamController.add(commentsList);
      commentSteamSubscription.resume();
    }
  }

  /// Constructs the page body, which is shown "below" the sliding panel
  Widget _constructPageBody() {
    // TODO: Default padding on the bottom where the slider overlaps
    if (article.url != null) {
      return Container(
        padding: EdgeInsets.only(bottom: 44),
        child: WebView(
          initialUrl: article.url,
          onPageStarted: (url) {
            setState(() {
              webviewIsLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              webviewIsLoading = false;
            });
          },
          javascriptMode: JavascriptMode.unrestricted,
        ),
      );
    }

    return Html(data: article.text);
  }

  Widget _constructSlidingSheet() {
    final articleHasBody = article.text != null;
    return Container(
      color: Get.isDarkMode ? Colors.black : Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
      child: Column(
        children: [
          // Title
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(article.title,
                maxLines: 3,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 40)),
          ),
          const SizedBox(height: 12),

          // Infobar
          Container(
            child: Row(children: [
              Container(
                  child: Text("Submitted by ${article.author}"),
                  margin: EdgeInsets.only(right: 8)),
            ]),
          ),

          // Optional text content
          // TODO: Place sliding sheet title + body in page, hide in sheet?
          // TODO: Or, render the sliding sheet content in the full page!
          articleHasBody ? SizedBox(height: 24) : Container(),
          articleHasBody
              ? Html(
                  data: article.text,
                  style: {
                    "body": Style(margin: EdgeInsets.all(0)),
                  },
                )
              : Container(),
          SizedBox(height: 24),

          IndexCommentSection(commentSectionStream: commentStreamController.stream),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Article"),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
        actions: [
          // TODO: Share button
          // IconButton(
          //   icon: const Icon(Icons.share),
          //   tooltip: 'Share',
          //   onPressed: () async {
          //     Get.snackbar('Sorry...', 'Sharing is not supported yet.');
          //   },
          // ),
          // Open in browser
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            tooltip: 'Open in browser',
            onPressed: () async {
              if (await canLaunch(article.url)) {
                await launch(article.url);
              } else {
                Get.snackbar('Error',
                    'Unable to open url. Please try again later or contact the developer.');
              }
            },
          ),
        ],
      ),
      body: SlidingSheet(
        elevation: 20,
        liftOnScrollHeaderElevation: 8,
        cornerRadius: 24,
        cornerRadiusOnFullscreen: 0,
        // Configure snapping the overlay to the bottom of the screen
        snapSpec: SnapSpec(
          snap: true,
          snappings: [SnapSpec.headerSnap, SnapSpec.expanded],
          positioning: SnapPositioning.relativeToAvailableSpace,
          onSnap: (state, snap) {
            if (snap == 1) 
              _startLoadingComments();
          },
        ),
        listener: (SheetState state) {
          if (state.scrollOffset+300 > state.maxScrollExtent) 
            _loadNextComment();
        },
        // The widget "below" the sliding sheet
        body: _constructPageBody(),
        // Sliding sheet header
        headerBuilder: (_, __) => IndexSlidingSheetHeader(article: article),

        // Sliding sheet content
        builder: (context, state) {
          return _constructSlidingSheet();
        },
      ),
    );
  }
}
