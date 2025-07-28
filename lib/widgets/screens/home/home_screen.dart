import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_common/models/app-reward/point_transaction.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' hide AdError;
import 'package:money_tree/models/tree_model.dart';
import 'package:money_tree/route.dart';
import 'package:money_tree/widgets/screens/home/sections/user_info_section.dart';
import 'package:money_tree/widgets/screens/home/sections/user_point_balance_section.dart';
import 'package:money_tree/widgets/tree_widget.dart';

class MainShakeAdCallBack extends AdCallback {
  final Function(RewardItem) onUserEarnedReward;

  MainShakeAdCallBack({required this.onUserEarnedReward});

  @override
  void onAdLoaded() {
    print('광고가 성공적으로 로드되었습니다!');
    // 사용자에게 알림 표시
  }

  @override
  void onRewardedAdLoaded(RewardedAd ad) {
    print('광고가 로드되었습니다! 리워드');
    ad.show(
      onUserEarnedReward: (ad, reward) {
        print('rewarded: ${reward.type} ${reward.amount}');

        onUserEarnedReward(reward);
      },
    );
    // 에러 처리 로직
  }

  @override
  void onAdFailedToLoad(AdError error) {
    print('광고 로드 실패: ${error.message}');
    // 에러 처리 로직
  }

  @override
  void onAdShown() {
    print('광고가 표시되었습니다');
    // 분석 이벤트 전송
  }

  @override
  void onAdClosed() {
    print('광고가 닫혔습니다');
    // 다음 광고 미리 로드
  }

  @override
  void onAdClicked() {
    print('광고가 클릭되었습니다');
  }

  @override
  void onRewardedAdUserEarnedReward(RewardItem reward) {
    print('보상 획득: ${reward.amount} ${reward.type}');
    // 보상 지급 로직
  }
}

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool _isShaking = false;
  final AdMaster _adMaster = AdMaster();
  AppRewardBloc get _appRewardBloc => context.read<AppRewardBloc>();

  @override
  void initState() {
    super.initState();
    _appRewardBloc.add(
      AppRewardEvent.getDailyUserReward(PointTransactionSource.admob_reward),
    );
  }

  Future<void> _showRewardedAd() async {
    await _adMaster.createRewardedAd(
      adUnitId: 'ca-app-pub-4656262305566191/9055227275',
      callback: MainShakeAdCallBack(
        onUserEarnedReward: (reward) {
          _appRewardBloc.add(
            AppRewardEvent.getDailyUserReward(
              PointTransactionSource.admob_reward,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 상단 앱바
            SliverAppBar(
              expandedHeight: 20,
              floating: false,
              pinned: true,
              backgroundColor: Colors.green[600],
              title: Text('돈 나무', style: TextStyle(color: Colors.white)),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    // 알림 화면으로 이동
                    AppNavigator.I.push(AppRoutes.notification);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    // 프로필 화면으로 이동
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: AdMasterWidget(
                  adType: AdType.banner,
                  adUnitId: 'ca-app-pub-4656262305566191/8144604315',
                  androidAdUnitId: 'ca-app-pub-4656262305566191/8550732762',
                  builder: (state, ad) {
                    return state.isLoaded && ad != null
                        ? AdWidget(ad: ad)
                        : CircularProgressIndicator();
                  },
                ),
              ),
            ),
            // 나무 섹션
            SliverToBoxAdapter(
              child: Container(
                height: 400,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue[100]!, Colors.green[100]!],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 사용자 정보
                    UserInfoSection(user: widget.user),
                    SizedBox(height: 20),

                    // 나무 위젯
                    Expanded(
                      child: Center(
                        child: AppRewardDailyUserRewardSelector((
                          dailyUserReward,
                        ) {
                          return TreeWidget(
                            transactions: dailyUserReward ?? [],
                            onShake: _showRewardedAd,
                            isShaking: _isShaking,
                          );
                        }),
                      ),
                    ),

                    // 흔들기 안내
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '🌳 나무를 터치해서 포인트를 받으세요!',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppRewardUserPointBalanceSelector((userPointBalance) {
              return SliverToBoxAdapter(child: UserPointBalanceSection());
            }),
          ],
        ),
      ),
    );
  }
}
