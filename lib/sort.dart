import 'dart:async';

import 'package:covidwatch/model.dart';
import 'package:flutter/material.dart';

enum SortBy {
  alphabetical,
  total,
  todayActive,
  todayDeaths,
  active,
  deaths,
  recovered
}
enum OrderBy { asc, desc }

class SortbyDialog extends StatefulWidget {
  final StreamController<CountryList> controller;
  final List<CountryStats> list;
  final SortBy sortBy;
  final OrderBy orderBy;
  final Function stateSetter;

  SortbyDialog(
      {this.controller,
      this.list,
      this.sortBy,
      this.orderBy,
      this.stateSetter});

  @override
  State<StatefulWidget> createState() => _SortbyDialogState();
}

class _SortbyDialogState extends State<SortbyDialog> {
  SortBy _sortBy;
  OrderBy _orderBy;

  @override
  void initState() {
    super.initState();
    this._sortBy = this.widget.sortBy;
    this._orderBy = this.widget.orderBy;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Sort by',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                _buildSortByChoice('Total Cases', SortBy.total),
                _buildSortByChoice('Active', SortBy.active),
                _buildSortByChoice('Deaths', SortBy.deaths),
                _buildSortByChoice('New Active', SortBy.todayActive),
                _buildSortByChoice('New Deaths', SortBy.todayDeaths),
                _buildSortByChoice('Recovered', SortBy.recovered),
                _buildSortByChoice('Alphabetical', SortBy.alphabetical),
              ],
            ),
            SizedBox(height: 24),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Order by',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                _buildOrderByChoice('Highest first', OrderBy.desc),
                _buildOrderByChoice('Lowest  first', OrderBy.asc),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text('Cancel', style: TextStyle(fontSize: 12)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                SizedBox(width: 12),
                FlatButton(
                  color: Color(0xff8fa7f4),
                  child: Text('Sort', style: TextStyle(fontSize: 12)),
                  onPressed: () {
                    // do sort with params
                    this.widget.stateSetter(_sortBy, _orderBy);
                    _sort();
                    Navigator.of(context).pop();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _sort() {
    if (SortBy.total == _sortBy) {
      if (OrderBy.asc == _orderBy)
        widget.list.sort((a, b) => a.cases - b.cases);
      else
        widget.list.sort((a, b) => b.cases - a.cases);
    } else if (SortBy.active == _sortBy) {
      if (OrderBy.asc == _orderBy)
        widget.list.sort((a, b) => a.active - b.active);
      else
        widget.list.sort((a, b) => b.active - a.active);
    } else if (SortBy.deaths == _sortBy) {
      if (OrderBy.asc == _orderBy)
        widget.list.sort((a, b) => a.deaths - b.deaths);
      else
        widget.list.sort((a, b) => b.deaths - a.deaths);
    } else if (SortBy.todayActive == _sortBy) {
      if (OrderBy.asc == _orderBy)
        widget.list.sort((a, b) => a.todayCases - b.todayCases);
      else
        widget.list.sort((a, b) => b.todayCases - a.todayCases);
    } else if (SortBy.todayDeaths == _sortBy) {
      if (OrderBy.asc == _orderBy)
        widget.list.sort((a, b) => a.todayDeaths - b.todayDeaths);
      else
        widget.list.sort((a, b) => b.todayDeaths - a.todayDeaths);
    } else if (SortBy.recovered == _sortBy) {
      if (OrderBy.asc == _orderBy)
        widget.list.sort((a, b) => a.recovered - b.recovered);
      else
        widget.list.sort((a, b) => b.recovered - a.recovered);
    } else if (SortBy.alphabetical == _sortBy) {
      if (OrderBy.asc == _orderBy)
        widget.list.sort((a, b) => b.country.compareTo(a.country));
      else
        widget.list.sort((a, b) => a.country.compareTo(b.country));
    }

    widget.controller.add(CountryList(list: widget.list));
  }

  void _setOrderChoice(value) {
    setState(() => _orderBy = value);
  }

  void _setSortChoice(value) {
    setState(() => _sortBy = value);
  }

  Widget _buildOrderByChoice(String title, OrderBy value) {
    return RadioListTile<OrderBy>(
      title: Text(title, style: TextStyle(fontSize: 12)),
      value: value,
      groupValue: _orderBy,
      onChanged: _setOrderChoice,
      activeColor: Color(0xff8fa7f4),
    );
  }

  Widget _buildSortByChoice(String title, SortBy value) {
    return RadioListTile<SortBy>(
      title: Text(title, style: TextStyle(fontSize: 12)),
      value: value,
      groupValue: _sortBy,
      onChanged: _setSortChoice,
      activeColor: Color(0xff8fa7f4),
    );
  }
}
