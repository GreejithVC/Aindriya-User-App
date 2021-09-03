import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/product_controller.dart';
import '../models/auto_suggestion.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import '../../generated/l10n.dart';
import 'custom_clipper.dart';

class SearchResultWidget extends StatefulWidget {
  final String heroTag;

  SearchResultWidget({Key key, this.heroTag}) : super(key: key);

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends StateMVC<SearchResultWidget> {
  ProductController _con;

  _SearchResultWidgetState() : super(ProductController()) {
    _con = controller;
  }

  stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                onSubmitted: (text) {
                  _con.saveSearch(text);
                },
                onChanged: (e) {
                  _con.listenGetSuggestion(e);
                },
                autofocus: true,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  hintText: S.of(context).what_are_you_looking_for,
                  hintStyle: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 14)),
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).accentColor),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.mic),
                    color: Theme.of(context).hintColor,
                    onPressed: () {
                      _isListening = false;
                      ShowClipper();
                    },
                  ),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.3))),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con.auto_suggestion.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      AutoSuggestion _suggestion = _con.auto_suggestion.elementAt(index);
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                print(1);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).dividerColor,
                                ))),
                                child: ListTile(
                                  leading: const Icon(Icons.search),
                                  title: Text(
                                    _suggestion.text,
                                    style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w600)),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.call_made,
                                      textDirection: TextDirection.rtl,
                                    ),
                                    color: Theme.of(context).hintColor,
                                    onPressed: () {
                                      _con.saveSearch(_suggestion.text);
                                    },
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  void ShowClipper() {
    String _text = S.of(context).press_the_button_and_start_speaking;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.35,
              color: Color(0xff737373),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                    color: Theme.of(context).primaryColorLight,
                  ),
                  Expanded(
                    child: ClipPath(
                      clipper: CustomShape(), // this is my own class which extendsCustomClipper
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                    SizedBox(height: 10),
                                    Text(
                                      _text,
                                      style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.w400)),
                                      textAlign: TextAlign.center,
                                    )
                                  ]),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 5),
                                child: AvatarGlow(
                                  animate: _isListening,
                                  glowColor: Colors.green,
                                  endRadius: 75.0,
                                  duration: const Duration(milliseconds: 2000),
                                  repeatPauseDuration: const Duration(milliseconds: 100),
                                  repeat: true,
                                  child: FloatingActionButton(
                                    onPressed: () async {
                                      if (!_isListening) {
                                        bool available = await _speech.initialize(
                                          onStatus: (val) {

                                          },
                                          onError: (val) => print('onError: $val'),
                                        );
                                        if (available) {
                                          setState(() => _isListening = true);
                                          _speech.listen(
                                            onResult: (val) => setState(() {
                                              _text = val.recognizedWords;
                                              print(_text);
                                              if (val.hasConfidenceRating && val.confidence > 0) {
                                                print('complete');
                                                setState(() => _isListening = false);
                                                _speech.stop();
                                                _con.saveSearch(_text);
                                              }
                                            }),
                                          );
                                        }
                                      } else {
                                        setState(() => _isListening = false);
                                        _speech.stop();
                                      }
                                    },
                                    child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }
}
