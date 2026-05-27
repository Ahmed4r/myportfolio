import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myportfolio/dark_veil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  static final Uri _githubUrl = Uri.parse('https://github.com/Ahmed4r');
  static final Uri _linkedinUrl = Uri.parse(
    'https://www.linkedin.com/in/ahmedradyhegazy/',
  );
  static final Uri _emailUrl = Uri.parse('mailto:ahmedrady03@gmail.com');
  static final Uri _resumeUrl = Uri.parse('assets/assets/resume/myResume.pdf');

  Future<void> _launch(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: 550.ms,
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 760;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xff030712),
      drawer: isMobile ? _buildDrawer() : null,
      body: DarkVeil(
        // color1: const Color.fromARGB(255, 255, 255, 255).withValues(alpha: 0.5),
        // color2: const Color.fromARGB(255, 11, 34, 233).withValues(alpha: 0.14),
        // color3: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.1),
        child: SelectionArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildNavBar(isMobile),
                _buildHeroSection(isMobile),
                _buildStatsSection(isMobile),
                _buildProjectsSection(isMobile),
                _buildSkillsSection(isMobile),
                _buildExperienceSection(isMobile),
                _buildContactSection(isMobile),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xff030712),
      child: SafeArea(
        child: Column(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text(
                  'Ahmed Hegazy',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            _drawerItem('Projects', _projectsKey),
            _drawerItem('Skills', _skillsKey),
            _drawerItem('Experience', _experienceKey),
            _drawerItem('Contact', _contactKey),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: _buildPrimaryButton(
                'Resume',
                icon: Icons.description_outlined,
                fullWidth: true,
                onPressed: () => _launch(_resumeUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(String title, GlobalKey key) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Future<void>.delayed(180.ms, () => _scrollTo(key));
      },
    );
  }

  Widget _buildNavBar(bool isMobile) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 12 : 24,
        18,
        isMobile ? 12 : 24,
        0,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1180),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10 : 24,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff08111F),
          border: Border.all(color: Colors.grey.shade800),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(
                255,
                72,
                72,
                78,
              ).withValues(alpha: 0.18),
              blurRadius: 30,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          children: [
            if (isMobile)
              IconButton(
                tooltip: 'Menu',
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            const Text(
              'Ahmed Hegazy',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            if (!isMobile) ...[
              _navItem('Projects', _projectsKey),
              _navItem('Skills', _skillsKey),
              _navItem('Experience', _experienceKey),
              _navItem('Contact', _contactKey),
              const SizedBox(width: 18),
            ],
            _buildPrimaryButton(
              'GitHub',
              icon: Icons.open_in_new,
              small: true,
              onPressed: () => _launch(_githubUrl),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _navItem(String title, GlobalKey key) {
    return _HoverMotion(
      lift: 2,
      scale: 1.02,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          hoverColor: const Color(0xff1D4ED8).withValues(alpha: 0.18),
          onTap: () => _scrollTo(key),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.82),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    return Center(
      // Center the entire container inside wide web viewports
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1180),
        padding: EdgeInsets.fromLTRB(
          isMobile ? 20 : 32,
          isMobile ? 64 : 116,
          isMobile ? 20 : 32,
          isMobile ? 44 : 90,
        ),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeroContent(isMobile),
                  const SizedBox(height: 42),
                  _buildProfilePanel(isMobile),
                ],
              )
            : Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align to top for better spacing
                children: [
                  Expanded(flex: 6, child: _buildHeroContent(isMobile)),
                  const SizedBox(
                    width: 48,
                  ), // Use a standard fixed spacer instead of conditional logic
                  Expanded(flex: 4, child: _buildProfilePanel(isMobile)),
                ],
              ),
      ),
    );
  }

  // Helper method to keep your layout code clean and maintainable
  Widget _buildHeroContent(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // _buildPill('Available for Flutter roles'),
        // const SizedBox(height: 28),
        ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.white, Color(0xff93C5FD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                'Flutter developer building polished mobile experiences.',
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
                style: TextStyle(
                  fontSize: isMobile
                      ? 42
                      : 64, // Dropped slightly from 76 to avoid severe wrapping issues
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  color: Colors.white,
                ),
              ),
            )
            .animate()
            .fadeIn(delay: 200.ms, duration: 800.ms)
            .slideY(begin: 0.08, end: 0),
        const SizedBox(height: 28),
        Text(
          'Computer Science student at Pharos University Alexandria with 1+ year of Flutter experience across Firebase, REST APIs, Bloc, Provider, and responsive cross-platform apps.',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            color: Colors.white.withValues(alpha: 0.68),
            height: 1.55,
          ),
        ).animate().fadeIn(delay: 360.ms, duration: 700.ms),
        const SizedBox(height: 36),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _buildPrimaryButton(
              'View Projects',
              icon: Icons.work_outline,
              onPressed: () => _scrollTo(_projectsKey),
            ),
            _buildSecondaryButton(
              'Contact Me',
              icon: Icons.mail_outline,
              onPressed: () => _scrollTo(_contactKey),
            ),
          ],
        ).animate().fadeIn(delay: 520.ms, duration: 700.ms),
      ],
    );
  }

  Widget _buildPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xff0B22E9).withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xff60A5FA).withValues(alpha: 0.45),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xffDBEAFE),
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.92, 0.92));
  }

  Widget _buildProfilePanel(bool isMobile) {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xff08111F),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color.fromARGB(255, 32, 46, 75)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'AH',
                        style: TextStyle(
                          color: const Color(0xff0B22E9),
                          fontWeight: FontWeight.w900,
                          fontSize: 21,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ahmed Hegazy',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Baltim, Kafr Elsheikh, Egypt',
                          style: TextStyle(
                            color: Color(0xffA1A1AA),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              _profileLine(
                Icons.school_outlined,
                'B.Sc. Computer Science, 2026',
              ),
              _profileLine(Icons.code_outlined, 'Flutter, Firebase, REST APIs'),
              _profileLine(
                Icons.emoji_events_outlined,
                'ECPC Qualifications rank 95/146',
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _iconButton('GitHub', Icons.code, () => _launch(_githubUrl)),
                  _iconButton('LinkedIn', Icons.business_center_outlined, () {
                    _launch(_linkedinUrl);
                  }),
                  _iconButton(
                    'Email',
                    Icons.mail_outline,
                    () => _launch(_emailUrl),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 420.ms, duration: 800.ms)
        .slideX(begin: 0.08, end: 0);
  }

  Widget _profileLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xff93C5FD), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(String tooltip, IconData icon, VoidCallback onPressed) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xff0B1220),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildStatsSection(bool isMobile) {
    final stats = [
      ('5+', 'apps shipped'),
      ('1,000+', 'API records handled'),
      ('99%', 'Firebase uptime target'),
      ('1+ year', 'Flutter experience'),
    ];

    return Container(
      constraints: const BoxConstraints(maxWidth: 1060),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 32,
        vertical: isMobile ? 22 : 36,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final int crossAxisCount = isMobile ? 2 : 4;
          final double itemWidth =
              (width - ((crossAxisCount - 1) * 12)) / crossAxisCount;
          // Forces a strict fixed height for stat cards regardless of screen width
          const double itemHeight = 100.0;
          final double calculatedRatio = itemWidth / itemHeight;

          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: calculatedRatio,
            children: [for (final stat in stats) _statItem(stat.$1, stat.$2)],
          );
        },
      ),
    ).animate().fadeIn(delay: 700.ms);
  }

  Widget _statItem(String value, String label) {
    return _HoverMotion(
      lift: 8,
      scale: 1.015,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xff08111F),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade800),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(
                255,
                249,
                249,
                250,
              ).withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.48),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsSection(bool isMobile) {
    final projects = [
      _Project(
        title: 'BioSync AI',
        tags: 'Flutter, Firebase, BLE, AI',
        description:
            'Smart healthcare app with AI-based risk prediction, personalized recommendations, and smart-band data collection.',
        points: [
          '500+ health data points',
          'Firestore, Storage, Cloud Functions',
        ],
        icon: Icons.monitor_heart_outlined,
      ),
      _Project(
        title: 'E-Commerce App',
        tags: 'Flutter, Firebase, REST API',
        description:
            'Online store with authentication, product browsing, cart, checkout, theming, and an admin dashboard.',
        points: ['Dark and light mode', 'Realtime product and order updates'],
        icon: Icons.shopping_bag_outlined,
      ),
      _Project(
        title: 'Movies App',
        tags: 'Flutter, REST API',
        description:
            'Team-built movies app fetching 1,000+ titles with search, filtering, paging, caching, and responsive layouts.',
        points: ['Reduced API calls by 40%', 'Route Training team project'],
        icon: Icons.movie_filter_outlined,
      ),
      _Project(
        title: 'Quran MP3 App',
        tags: 'Flutter, Firebase, Audio Streaming',
        description:
            'Audio app for streaming and downloading 200+ surahs with Google Sign-In, favorites, and offline playback.',
        points: ['200+ audio surahs', 'Offline playback support'],
        icon: Icons.headphones_outlined,
      ),
      _Project(
        title: 'Weather App',
        tags: 'Flutter, REST API, Bloc',
        description:
            'Weather app using OpenWeather API, Cubit/Bloc states, search, pull-to-refresh, charts, and Lottie animations.',
        points: ['5-day forecast', 'Dynamic day/night UI'],
        icon: Icons.cloud_outlined,
      ),
    ];

    return _section(
      key: _projectsKey,
      title: 'Highlighted Projects',
      subtitle:
          'Mobile apps that pair practical product features with clean Flutter implementation.',
      isMobile: isMobile,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          int crossAxisCount = 1;
          if (width > 980) {
            crossAxisCount = 3;
          } else if (width > 650) {
            crossAxisCount = 2;
          }

          final double itemWidth =
              (width - ((crossAxisCount - 1) * 18)) / crossAxisCount;
          // Dynamically scales layout height requirements based on mobile vs desktop layouts
          final double itemHeight = isMobile ? 280.0 : 290.0;
          final double calculatedRatio = itemWidth / itemHeight;

          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            childAspectRatio: calculatedRatio,
            children: [for (final project in projects) _projectCard(project)],
          );
        },
      ),
    );
  }

  Widget _projectCard(_Project project) {
    return _HoverMotion(
      lift: 10,
      scale: 1.018,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xff08111F),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade800),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff0B22E9).withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(project.icon, color: const Color(0xff93C5FD), size: 30),
            const SizedBox(height: 18),
            Text(
              project.title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              project.tags,
              style: const TextStyle(
                color: Color(0xffBFDBFE),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              project.description,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.62),
                height: 1.42,
                fontSize: 13.5,
              ),
            ),
            const Spacer(),
            for (final point in project.points)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check, size: 16, color: Color(0xffFFFFFF)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        point,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.72),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.06, end: 0);
  }

  Widget _buildSkillsSection(bool isMobile) {
    final skills = {
      'Languages': ['Dart', 'Python', 'Java', 'C#'],
      'Flutter': ['Bloc', 'Cubit', 'Provider', 'Responsive UI'],
      'Backend': ['Firebase Auth', 'Firestore', 'Realtime DB', 'REST APIs'],
      'Tools': ['VS Code', 'Android Studio', 'Git', 'GitHub'],
    };

    return _section(
      key: _skillsKey,
      title: 'Technical Skills',
      subtitle:
          'A practical stack for shipping mobile apps from UI to backend integration.',
      isMobile: isMobile,
      verticalPadding: isMobile ? 42 : 56,
      contentGap: 22,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          int crossAxisCount = 1;
          if (width > 980) {
            crossAxisCount = 4;
          } else if (width > 650) {
            crossAxisCount = 2;
          }

          final double itemWidth =
              (width - ((crossAxisCount - 1) * 14)) / crossAxisCount;
          const double itemHeight = 135.0;
          final double calculatedRatio = itemWidth / itemHeight;

          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: calculatedRatio,
            children: [
              for (final entry in skills.entries)
                _skillGroup(entry.key, entry.value),
            ],
          );
        },
      ),
    );
  }

  Widget _skillGroup(String title, List<String> skills) {
    return _HoverMotion(
      lift: 7,
      scale: 1.012,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xff08111F),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 7,
              children: [
                for (final skill in skills)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff0B22E9).withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(
                        color: Color(0xffDBEAFE),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceSection(bool isMobile) {
    return _section(
      key: _experienceKey,
      title: 'Experience & Education',
      subtitle:
          'Focused on Flutter development, API integration, Firebase backends, and team delivery.',
      isMobile: isMobile,
      child: Column(
        children: [
          _timelineItem(
            title: 'Flutter Developer Intern',
            meta: 'Route IT Training Center, Alexandria | Jul 2024 - Oct 2024',
            body:
                'Developed 5+ cross-platform apps, integrated REST APIs, applied Bloc and Provider patterns, implemented Firebase Authentication and Realtime Database, and tested across Android and iOS.',
          ),
          const SizedBox(height: 14),
          _timelineItem(
            title: 'B.Sc. Computer Science',
            meta: 'Pharos University Alexandria | Expected Jun 2026',
            body:
                'Building a foundation in software engineering, mobile development, algorithms, and practical application design.',
          ),
        ],
      ),
    );
  }

  Widget _timelineItem({
    required String title,
    required String meta,
    required String body,
  }) {
    return _HoverMotion(
      lift: 6,
      scale: 1.006,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xff08111F),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: const Color(0xffFFFFFF),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    meta,
                    style: const TextStyle(
                      color: Color(0xff93C5FD),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    body,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.64),
                      height: 1.48,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(bool isMobile) {
    return _section(
      key: _contactKey,
      title: 'Let\'s Build',
      subtitle:
          'Open to Flutter internships, junior roles, collaborations, and mobile app projects.',
      isMobile: isMobile,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 22 : 30),
        decoration: BoxDecoration(
          color: const Color(0xff08111F),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Wrap(
          spacing: 14,
          runSpacing: 14,
          alignment: isMobile
              ? WrapAlignment.center
              : WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: isMobile ? double.infinity : 470,
              child: Text(
                'Email: ahmedrady03@gmail.com\nPhone: +20 1091541856',
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  height: 1.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildPrimaryButton(
                  'Email',
                  icon: Icons.mail_outline,
                  onPressed: () => _launch(_emailUrl),
                ),
                _buildSecondaryButton(
                  'LinkedIn',
                  icon: Icons.business_center_outlined,
                  onPressed: () => _launch(_linkedinUrl),
                ),
                _buildSecondaryButton(
                  'Resume',
                  icon: Icons.description_outlined,
                  onPressed: () => _launch(_resumeUrl),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required GlobalKey key,
    required String title,
    required String subtitle,
    required bool isMobile,
    required Widget child,
    double? verticalPadding,
    double contentGap = 34,
  }) {
    return Container(
      key: key,
      constraints: const BoxConstraints(maxWidth: 1180),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 32,
        vertical: verticalPadding ?? (isMobile ? 58 : 82),
      ),
      child: Column(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 32 : 42,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 13),
          SizedBox(
            width: 690,
            child: Text(
              subtitle,
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.58),
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: contentGap),
          child,
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(
    String text, {
    required IconData icon,
    bool small = false,
    bool fullWidth = false,
    required VoidCallback onPressed,
  }) {
    return _HoverMotion(
      lift: small ? 3 : 7,
      scale: small ? 1.02 : 1.025,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        hoverColor: Colors.transparent,
        onTap: onPressed,
        child: AnimatedContainer(
          duration: 180.ms,
          curve: Curves.easeOutCubic,
          width: fullWidth ? double.infinity : null,
          padding: EdgeInsets.symmetric(
            horizontal: small ? 16 : 22,
            vertical: small ? 10 : 15,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              if (!small)
                BoxShadow(
                  color: const Color(0xff0B22E9).withValues(alpha: 0.28),
                  blurRadius: 34,
                  offset: const Offset(0, 12),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: small ? 16 : 18, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: small ? 13 : 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(
    String text, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return _HoverMotion(
      lift: 6,
      scale: 1.02,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        hoverColor: const Color.fromARGB(
          255,
          9,
          41,
          224,
        ).withValues(alpha: 0.18),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xff0B1220),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.40)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1180),
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 50),
      child: Column(
        children: [
          Divider(color: Colors.white.withValues(alpha: 0.06)),
          const SizedBox(height: 26),
          Text(
            'Ahmed Hegazy | Flutter Developer',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.58),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _Project {
  const _Project({
    required this.title,
    required this.tags,
    required this.description,
    required this.points,
    required this.icon,
  });

  final String title;
  final String tags;
  final String description;
  final List<String> points;
  final IconData icon;
}

class _HoverMotion extends StatefulWidget {
  const _HoverMotion({required this.child, this.lift = 8, this.scale = 1.01});

  final Widget child;
  final double lift;
  final double scale;

  @override
  State<_HoverMotion> createState() => _HoverMotionState();
}

class _HoverMotionState extends State<_HoverMotion> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? widget.scale : 1,
        duration: 180.ms,
        curve: Curves.easeOutCubic,
        child: AnimatedSlide(
          offset: _hovering ? Offset(0, -widget.lift / 120) : Offset.zero,
          duration: 180.ms,
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}
