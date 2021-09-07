import 'package:flutter/material.dart';
import '../elements/SearchWidget.dart';
import '../../generated/l10n.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged onClickFilter;

  const SearchBarWidget({Key key, this.onClickFilter}) : super(key: key);
  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(SearchModal());
      },
      child: Container(
        padding: EdgeInsets.all(9),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Theme.of(context).focusColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 0),
              child: Icon(Icons.search, color: Theme.of(context).accentColor),
            ),
            Expanded(
              child: Text(
                S.of(context).what_are_you_looking_for,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 12)),
              ),
            ),
            SizedBox(width: 8),
            InkWell(
              onTap: () {
                Navigator.of(context).push(SearchModal());
              },
              child: Container(
                padding: const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
                child: Icon(
                  Icons.mic,
                  color: Theme.of(context).hintColor,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
