import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/services/likes_service.dart';
import 'package:lloud_mobile/views/components/h2.dart';

class PortfolioHeader extends StatefulWidget {
  final int userId;
  final bool isMyProfile;

  PortfolioHeader(this.userId, {this.isMyProfile = false});

  @override
  _PortfolioHeaderState createState() =>
      _PortfolioHeaderState(this.userId, isMyProfile: this.isMyProfile);
}

class _PortfolioHeaderState extends State<PortfolioHeader> {
  final int userId;
  final bool isMyProfile;

  _PortfolioHeaderState(this.userId, {this.isMyProfile = false});

  Future<Map<String, dynamic>> _profile;

  @override
  void initState() {
    final authToken = Provider.of<Auth>(context, listen: false).token;
    _profile = LikesService.fetchLikesProfile(authToken, userId);
    super.initState();
  }

  String pronoun() {
    return widget.isMyProfile ? 'You\'ve' : 'This user';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H2('Portfolio'),
          SizedBox(
            height: 4,
          ),
          FutureBuilder<Map<String, dynamic>>(
              future: _profile,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();

                return Text(
                  '${pronoun()} liked ${snapshot.data['songIds'].length} songs and earned a total of ${snapshot.data['totalPoints']} points!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                );
              }),
        ],
      ),
    );
  }
}
