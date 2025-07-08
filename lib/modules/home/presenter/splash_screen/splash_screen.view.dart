part of 'splash_screen.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LoginUseCase loginUseCase = getIt<LoginUseCase>();

  final SpashBloc spashBloc = SpashBloc();

  @override
  void initState() {
    super.initState();
    loginUseCase.login(LoginRequest(
      userName: 'test',
      password: 'test',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SpashBloc, SpashState>(
        
        bloc: spashBloc,
        builder: (context, state) {
          return Center(
            child: InkWell(
              onTap: () {
                spashBloc.add(SpashStarted());
              },
              child: Text(
                'Splash Screen',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
