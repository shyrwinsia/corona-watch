import 'package:covidwatch/data/model.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

class SortByDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SortByDialogState();
}

class _SortByDialogState extends State<SortByDialog> {
  SortBy _sortBy = SortBy.alphabetical;

  @override
  Widget build(BuildContext context) {
    return _SortDialog(
        title: 'Sort by',
        elements: [
          _buildSortByChoice(SortBy.totalCases),
          _buildSortByChoice(SortBy.active),
          _buildSortByChoice(SortBy.deaths),
          _buildSortByChoice(SortBy.newActive),
          _buildSortByChoice(SortBy.newDeaths),
          _buildSortByChoice(SortBy.recovered),
          _buildSortByChoice(SortBy.alphabetical),
        ],
        save: () => print('Save action for sort by $_sortBy'));
  }

  Widget _buildSortByChoice(SortBy value) {
    return RadioListTile<SortBy>(
      title: Text(EnumToString.parseCamelCase(value),
          style: TextStyle(fontSize: 12)),
      value: value,
      groupValue: _sortBy,
      onChanged: (value) => setState(() => _sortBy = value),
      activeColor: Color(0xff8fa7f4),
    );
  }
}

class OrderByDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderByDialogState();
}

class _OrderByDialogState extends State<OrderByDialog> {
  OrderBy _orderBy = OrderBy.highestFirst;

  @override
  Widget build(BuildContext context) {
    return _SortDialog(
        title: 'Sort by',
        elements: [
          _buildOrderByChoice(OrderBy.highestFirst),
          _buildOrderByChoice(OrderBy.lowestFirst),
        ],
        save: () => print('Save action for order by $_orderBy'));
  }

  Widget _buildOrderByChoice(OrderBy value) {
    return RadioListTile<OrderBy>(
      title: Text(EnumToString.parseCamelCase(value),
          style: TextStyle(fontSize: 12)),
      value: value,
      groupValue: _orderBy,
      onChanged: (value) => setState(() => _orderBy = value),
      activeColor: Color(0xff8fa7f4),
    );
  }
}

class _SortDialog extends StatelessWidget {
  final String title;
  final List<Widget> elements;
  final Function save;

  _SortDialog({this.title, this.elements, this.save});

  Widget build(BuildContext context) {
    return Theme(
      data:
          Theme.of(context).copyWith(dialogBackgroundColor: Color(0xFF1A1A1A)),
      child: Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: EdgeInsets.fromLTRB(32, 32, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 24),
              Column(children: elements),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text('Cancel',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff8fa7f4),
                        )),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  FlatButton(
                      child: Text('OK',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff8fa7f4),
                          )),
                      onPressed: () {
                        save();
                        Navigator.pop(context);
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
