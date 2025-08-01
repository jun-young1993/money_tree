import 'package:flutter/material.dart';
import 'package:flutter_common/constants/juny_constants.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_common/network/dio_client.dart';
import 'package:flutter_common/repositories/app_reward_repository.dart';
import 'package:flutter_common/state/app_reward/app_reward_bloc.dart';
import 'package:flutter_common/state/notice/notice_bloc.dart';
import 'package:flutter_common/state/notice/notice_page_bloc.dart';
import 'package:flutter_common/state/notice_group/notice_group_bloc.dart';
import 'package:flutter_common/state/notice_reply/notice_reply_bloc.dart';
import 'package:flutter_common/state/user/user_bloc.dart';
import 'package:flutter_common/state/verification/verification_bloc.dart';
import 'package:flutter_common/state/verification/verification_listener.dart';
import 'package:money_tree/app_layout.dart';
import 'package:money_tree/route.dart';

import 'package:shared_preferences/shared_preferences.dart';

///
Future<void> main() async {
  /**
   * Flutter 엔진 초기화
   * 
   * @description Flutter 프레임워크의 핵심 컴포넌트들을 초기화합니다.
   * 플랫폼 채널, 플러그인 사용 전에 반드시 호출해야 합니다.
   * 
   * @see https://api.flutter.dev/flutter/widgets/WidgetsFlutterBinding/ensureInitialized.html
   */
  WidgetsFlutterBinding.ensureInitialized();

  final adMaster = AdMaster();
  await adMaster.initialize(AdConfig());

  /**
   * 에러 처리 초기화
   * 
   * @description Flutter 에러를 콘솔에 출력하여 디버깅을 돕습니다.
   * 프로덕션에서는 적절한 에러 로깅 서비스로 대체해야 합니다.
   * 
   * @example
   * ```dart
   * FlutterError.onError = (FlutterErrorDetails details) {
   *   debugPrint('[FLUTTER ERROR] ${details.exception}');
   *   debugPrint('[STACKTRACE] ${details.stack}');
   * };
   * ```
   */
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('[FLUTTER ERROR] ${details.exception}');
    debugPrint('[STACKTRACE] ${details.stack}');
  };

  /**
   * Navigation 초기화
   * 
   * @description 앱의 라우팅 시스템을 초기화합니다.
   * AppNavigator를 통해 전역 네비게이션을 관리합니다.
   */
  AppNavigator.init<AppRoutes, AppPaths>(
    onGenerateRoute: AppPaths().onGenerateRoute,
    pathProvider: AppPaths(),
  );

  /**
   * 다국어 지원 초기화
   * 
   * @description EasyLocalization을 사용한 다국어 지원을 초기화합니다.
   * 
   * @requires easy_localization 패키지 설치
   * @shell flutter pub add easy_localization
   * 
   * @example MaterialApp 위에 EasyLocalization 추가
   * ```dart
   * EasyLocalization(
   *   supportedLocales: const [Locale('ko'), Locale('en')],
   *   path: 'packages/flutter_common/assets/translations',
   *   fallbackLocale: const Locale('ko'),
   *   child: MaterialApp(
   *     ...
   *     home: const Text('Demo'),
   *   )
   * )
   * ```
   */
  await EasyLocalization.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  DioClient dioClient = DioClient(
    baseUrl: JunyConstants.apiBaseUrl,
    debugBaseUrl: JunyConstants.apiBaseUrl,
    useLogInterceptor: true,
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppRepository>(
          create:
              (context) =>
                  AppDefaultRepository(sharedPreferences: sharedPreferences),
        ),
        RepositoryProvider<UserRepository>(
          create:
              (context) => UserDefaultRepository(
                dioClient: dioClient,
                sharedPreferences: sharedPreferences,
                appKey: AppKeys.moneyTree,
              ),
        ),
        RepositoryProvider<VerificationRepository>(
          create:
              (context) => VerificationDefaultRepository(
                dioClient: dioClient,
                appKey: AppKeys.moneyTree,
              ),
        ),
        RepositoryProvider<NoticeGroupRepository>(
          create:
              (context) => NoticeGroupDefaultRepository(dioClient: dioClient),
        ),
        RepositoryProvider<NoticeRepository>(
          create: (context) => NoticeDefaultRepository(dioClient: dioClient),
        ),
        RepositoryProvider<NoticeReplyRepository>(
          create:
              (context) => NoticeReplyDefaultRepository(dioClient: dioClient),
        ),
        RepositoryProvider<AppRewardRepository>(
          create: (context) => AppRewardDefaultRepository(dioClient: dioClient),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) =>
                    AppConfigBloc(appRepository: context.read<AppRepository>()),
          ),
          BlocProvider(
            create:
                (context) =>
                    UserBloc(userRepository: context.read<UserRepository>()),
          ),
          BlocProvider(
            create:
                (context) => VerificationBloc(
                  verificationRepository:
                      context.read<VerificationRepository>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => NoticeGroupBloc(
                  noticeGroupRepository: context.read<NoticeGroupRepository>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => NoticeBloc(
                  noticeRepository: context.read<NoticeRepository>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => NoticePageBloc(
                  noticeRepository: context.read<NoticeRepository>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => NoticeReplyBloc(
                  noticeReplyRepository: context.read<NoticeReplyRepository>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => AppRewardBloc(
                  appRewardRepository: context.read<AppRewardRepository>(),
                  userRepository: context.read<UserRepository>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => PointTransactionPagingBloc(
                  appRewardRepository: context.read<AppRewardRepository>(),
                  userRepository: context.read<UserRepository>(),
                ),
          ),
        ],
        child: Builder(
          builder: (context) {
            return EasyLocalization(
              supportedLocales: const [Locale('ko'), Locale('en')],
              path: 'packages/flutter_common/assets/translations',
              fallbackLocale: const Locale('en'),
              child: const MyApp(),
            );
          },
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${JunyConstants.appNames[AppKeys.moneyTree]!} 🌳💰',
      navigatorKey: AppNavigator.I.navigatorKey,
      onGenerateRoute: AppNavigator.I.onGenerateRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: MultiBlocListener(
        listeners: [VerificationListener(), NoticeListener()],
        child: const AppLayout(),
      ),
    );
  }
}
