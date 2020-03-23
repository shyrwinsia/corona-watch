import 'package:covidwatch/data/model.dart';
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
          _buildSortByChoice('Total Cases', SortBy.total),
          _buildSortByChoice('Active', SortBy.active),
          _buildSortByChoice('Deaths', SortBy.deaths),
          _buildSortByChoice('New Active', SortBy.todayActive),
          _buildSortByChoice('New Deaths', SortBy.todayDeaths),
          _buildSortByChoice('Recovered', SortBy.recovered),
          _buildSortByChoice('Alphabetical', SortBy.alphabetical),
        ],
        save: () => print('Save action for sort by'));
  }

  Widget _buildSortByChoice(String title, SortBy value) {
    return RadioListTile<SortBy>(
      title: Text(title, style: TextStyle(fontSize: 12)),
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
  OrderBy _orderBy = OrderBy.desc;

  @override
  Widget build(BuildContext context) {
    return _SortDialog(
      title: 'Sort by',
      elements: [
        _buildOrderByChoice('Highest first', OrderBy.desc),
        _buildOrderByChoice('Lowest first', OrderBy.asc),
      ],
      save: () => print('Save action for order by'),
    );
  }

  Widget _buildOrderByChoice(String title, OrderBy value) {
    return RadioListTile<OrderBy>(
      title: Text(title, style: TextStyle(fontSize: 12)),
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
    return Dialog(
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
    );
  }
}
