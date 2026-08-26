import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tteomer/core/theme/app_colors.dart';
import 'package:tteomer/features/main/presentation/pages/setting_screen.dart';
import 'package:tteomer/l10n/app_localizations.dart';
import '../../../auth/presentation/provider/providers.dart';
import '../state/main_state.dart';
import 'news_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final PageController _newsPageController;
  int _currentNewsPage = 0;
  String? _lastLocaleCode;

  @override
  void initState() {
    super.initState();
    _newsPageController = PageController(viewportFraction: 1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mainNotifierProvider.notifier).fetchNews();
      ref.read(mainNotifierProvider.notifier).checkRegistrationStatus();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localeCode = Localizations.localeOf(context).languageCode;
    if (_lastLocaleCode == localeCode) return;
    _lastLocaleCode = localeCode;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(mainNotifierProvider.notifier)
          .fetchDailyLearning(localeCode: localeCode);
    });
  }

  @override
  void dispose() {
    _newsPageController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final newsState = ref.watch(mainNotifierProvider);
    final roleAsync = ref.watch(userRoleProvider);
    final role = roleAsync.valueOrNull?.trim().toUpperCase();
    final isTeacher = role == 'TEACHER';

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          title: Text(
            l10n.tabHome,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            // Welcome banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF8E7BFF)],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.school,
                      color: Color(0xFF6C63FF),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.welcomeTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.welcomeSubtitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (!isTeacher) ...[
              _DailyLearningSection(state: newsState),
              const SizedBox(height: 20),
            ],
            // Шиммер пока грузятся новости
            if (newsState.status == NewsStatus.loading) ...[
              _SectionTitle(l10n.sectionNews),
              const SizedBox(height: 12),
              const _NewsShimmer(),
              const SizedBox(height: 20),
            ],

            if (newsState.status == NewsStatus.success &&
                newsState.news.isNotEmpty) ...[
              _SectionTitle(l10n.sectionNews),
              const SizedBox(height: 12),

              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _newsPageController,
                  itemCount: newsState.news.length,
                  onPageChanged: (index) {
                    setState(() => _currentNewsPage = index);
                  },
                  itemBuilder: (context, index) {
                    final news = newsState.news[index];

                    return AnimatedScale(
                      scale: _currentNewsPage == index ? 1.0 : 0.95,
                      duration: const Duration(milliseconds: 300),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewsDetailScreen(
                                title: news.title,
                                description: news.description,
                                image: news.image,
                                tag: news.tag,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: DecorationImage(
                              image: NetworkImage(news.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.7),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (news.tag.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      news.tag,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  news.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  newsState.news.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentNewsPage == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentNewsPage == index
                          ? AppColors.accent
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],

            if (!isTeacher && newsState.isRegistrationOpen == true) ...[
              GestureDetector(
                onTap: () => _openUrl('https://biskektomer.com/#'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.accent,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      l10n.registerButton,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            _SectionTitle(l10n.sectionContacts),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3.2,
              children: [
                _ContactTile(
                  title: l10n.contactSite,
                  icon: Icons.language,
                  color: const Color(0xFF6C63FF),
                  onTap: () => _openUrl('https://biskektomer.com/'),
                ),
                _ContactTile(
                  title: l10n.contactInstagram,
                  icon: Icons.camera_alt_outlined,
                  color: const Color(0xFFE1306C),
                  onTap: () =>
                      _openUrl('https://www.instagram.com/tteomer_bishkek'),
                ),
                _ContactTile(
                  title: l10n.contactFacebook,
                  icon: Icons.facebook,
                  color: const Color(0xFF1877F2),
                  onTap: () => _openUrl('https://facebook.com/yourpage'),
                ),
                _ContactTile(
                  title: l10n.contactYoutube,
                  icon: Icons.play_circle_outline,
                  color: const Color(0xFFFF0000),
                  onTap: () =>
                      _openUrl('https://youtube.com/@biskektteomer2887'),
                ),
              ],
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _DailyLearningSection extends StatelessWidget {
  final NewsState state;

  const _DailyLearningSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.dailyPracticeTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 10),
            if (state.userLevel != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.levelBadge(state.userLevel!),
                  style: const TextStyle(
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: switch (state.dailyLearningStatus) {
            DailyLearningStatus.loading => const _DailyLearningSkeleton(),
            DailyLearningStatus.success
                when state.dailyLearningContent != null =>
              _DailyLearningCard(state: state),
            DailyLearningStatus.error => _DailyLearningFallbackMessage(
              title: l10n.dailyPracticeUnavailable,
              subtitle: l10n.dailyPracticeUnavailableSubtitle,
            ),
            _ => _DailyLearningFallbackMessage(
              title: l10n.dailyPracticePreparing,
              subtitle: l10n.dailyPracticePreparingSubtitle,
            ),
          },
        ),
      ],
    );
  }
}

class _DailyLearningCard extends StatelessWidget {
  final NewsState state;

  const _DailyLearningCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = state.dailyLearningContent!;

    return Container(
      key: ValueKey(
        '${state.contentLocaleCode}-${content.level}-${content.word}-${content.sentence}',
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF7C3AED)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _DailyLearningTile(
            icon: Icons.auto_awesome_rounded,
            eyebrow: l10n.wordOfTheDay,
            title: content.word,
            subtitle: content.wordTranslation,
            accent: const Color(0xFFFFD166),
          ),
          const SizedBox(height: 12),
          _DailyLearningTile(
            icon: Icons.chat_bubble_outline_rounded,
            eyebrow: l10n.sentenceOfTheDay,
            title: content.sentence,
            subtitle: content.sentenceTranslation,
            accent: const Color(0xFF7DD3FC),
          ),
        ],
      ),
    );
  }
}

class _DailyLearningTile extends StatelessWidget {
  final IconData icon;
  final String eyebrow;
  final String title;
  final String subtitle;
  final Color accent;

  const _DailyLearningTile({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyLearningSkeleton extends StatelessWidget {
  const _DailyLearningSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('daily-learning-skeleton'),
      height: 232,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _DailyLearningFallbackMessage extends StatelessWidget {
  final String title;
  final String subtitle;

  const _DailyLearningFallbackMessage({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(title),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.bolt_rounded, color: Color(0xFF6C63FF)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── SHIMMER ───────────────────────────

class _NewsShimmer extends StatefulWidget {
  const _NewsShimmer();

  @override
  State<_NewsShimmer> createState() => _NewsShimmerState();
}

class _NewsShimmerState extends State<_NewsShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _animation = Tween<double>(
      begin: -1.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShimmerBox(
              width: double.infinity,
              height: 200,
              borderRadius: 24,
              shimmerValue: _animation.value,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => _ShimmerBox(
                  width: i == 0 ? 20 : 8,
                  height: 8,
                  borderRadius: 4,
                  shimmerValue: _animation.value,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final double shimmerValue;
  final EdgeInsets? margin;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.shimmerValue,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.0, 0.5, 1.0],
          colors: const [
            Color(0xFFE0E0E0),
            Color(0xFFF5F5F5),
            Color(0xFFE0E0E0),
          ],
          transform: _SlideGradient(shimmerValue),
        ),
      ),
    );
  }
}

class _SlideGradient extends GradientTransform {
  final double value;
  const _SlideGradient(this.value);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * value, 0, 0);
  }
}

// ─────────────────────────── WIDGETS ───────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ContactTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 18),
          ],
        ),
      ),
    );
  }
}
