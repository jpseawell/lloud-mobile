// import 'package:flutter/material.dart';

// import 'package:lloud_mobile/config/lloud_theme.dart';
// import 'package:lloud_mobile/models/store_item.dart';
// import 'package:lloud_mobile/views/_common/cost_badge.dart';

// class StoreItemWidget extends StatefulWidget {
//   final StoreItem storeItem;

//   StoreItemWidget(this.storeItem);

//   @override
//   _StoreItemWidgetState createState() => _StoreItemWidgetState(this.storeItem);
// }

// class _StoreItemWidgetState extends State<StoreItemWidget> {
//   final StoreItem _storeItem;

//   _StoreItemWidgetState(this._storeItem);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//               flex: 1,
//               child: Card(
//                   color: LloudTheme.black,
//                   elevation: 5,
//                   semanticContainer: true,
//                   clipBehavior: Clip.antiAliasWithSaveLayer,
//                   margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
//                   child: InkWell(
//                     splashColor: LloudTheme.red.withAlpha(30),
//                     onTap: () {
//                       return Navigator.pushNamed(context, '/store-item',
//                           arguments: this._storeItem);
//                     },
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         AspectRatio(
//                             aspectRatio: 1 / 1,
//                             child: Image.network(this._storeItem.imageUrl,
//                                 fit: BoxFit.cover)),
//                         Container(
//                           padding: EdgeInsets.all(16.0),
//                           child: Row(
//                             children: <Widget>[
//                               Expanded(
//                                   flex: 3,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Text(
//                                         this._storeItem.name,
//                                         style: TextStyle(
//                                             color: LloudTheme.white,
//                                             fontSize: 24,
//                                             fontWeight: FontWeight.bold,
//                                             fontFamily: 'Raleway'),
//                                       ),
//                                       Text(
//                                         this._storeItem.type,
//                                         style: TextStyle(
//                                             color: LloudTheme.white,
//                                             fontSize: 16),
//                                       ),
//                                     ],
//                                   )),
//                               Expanded(
//                                   flex: 1,
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: <Widget>[
//                                       Container(
//                                         decoration: BoxDecoration(
//                                             color: LloudTheme.red,
//                                             shape: BoxShape.rectangle,
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(4.0))),
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 4.0, horizontal: 16.0),
//                                         child: CostBadge(this._storeItem.cost,
//                                             this._storeItem.qty),
//                                       )
//                                     ],
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )))
//         ],
//       ),
//     );
//   }
// }
