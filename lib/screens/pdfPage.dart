import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:mit_post/util/themes.dart';

class pdfPage extends StatefulWidget {
  final String pdfLink;
  final String title;
  pdfPage({this.title, this.pdfLink});
  @override
  _pdfPageState createState() => _pdfPageState();
}

class _pdfPageState extends State<pdfPage> {
  bool _isLoading = true;
  PDFDocument document;
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(widget.pdfLink);
    print('Await done');
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Center(
            child: _isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppTheme.mitPostOrange),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Downloading the magazine...",
                        style: theme.textTheme.bodyText2,
                      ),
                      Text(
                        "This may take a couple of seconds",
                        style: theme.textTheme.bodyText2,
                      )
                    ],
                  )
                : PDFViewer(
                    document: document,
                    zoomSteps: 1,
                    lazyLoad: false,
                    navigationBuilder:
                        (context, page, totalPages, jumpToPage, animateToPage) {
                      return BottomAppBar(
                        color: theme.cardColor,
                        notchMargin: 2,
                        elevation: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.first_page,
                                color: theme.colorScheme.primaryVariant,
                              ),
                              onPressed: () {
                                jumpToPage(page: 0);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                color: theme.colorScheme.primaryVariant,
                              ),
                              onPressed: () {
                                animateToPage(page: page - 2);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.title,
                                color: theme.cardColor,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.chevron_right,
                                color: theme.colorScheme.primaryVariant,
                              ),
                              onPressed: () {
                                animateToPage(page: page);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.last_page,
                                color: theme.colorScheme.primaryVariant,
                              ),
                              onPressed: () {
                                jumpToPage(page: totalPages - 1);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
