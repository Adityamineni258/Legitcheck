import 'package:flutter/material.dart';
import 'package:legit_check/database_helper.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http; // <-- ADDED for API calls

// --- Modern Color Palette ---
const Color primaryColor = Color(0xFF0D47A1);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color successColor = Color(0xFF2E7D32);
const Color errorColor = Color(0xFFC62828);
const Color warningColor = Color(0xFFE65100);

// --- Helper function to assign colors to categories ---
Color _getColorForCategory(String category) {
  switch (category) {
    case 'Investment Adviser':
      return Colors.blue.shade800;
    case 'Merchant Bankers':
      return Colors.green.shade800;
    case 'Portfolio Managers':
      return Colors.orange.shade800;
    case 'Stock Brokers Equity Derivative':
      return Colors.purple.shade800;
    case 'Stock Brokers Equity':
      return Colors.teal.shade800;
    case 'Research Analyst':
      return Colors.brown.shade800;
    default:
      return Colors.grey.shade700;
  }
}

String _getLocalizedDisplayName(BuildContext context, String category) {
  final l10n = AppLocalizations.of(context)!;
  switch (category) {
    case 'All':
      return l10n.categoryAll;
    case 'Investment Adviser':
      return l10n.categoryInvestmentAdviser;
    case 'Merchant Bankers':
      return l10n.categoryMerchantBankers;
    case 'Portfolio Managers':
      return l10n.categoryPortfolioManagers;
    case 'Stock Brokers Equity Derivative':
      return l10n.categoryEquityDerivative;
    case 'Stock Brokers Equity':
      return l10n.categoryEquityBroker;
    case 'Research Analyst':
      return l10n.categoryResearchAnalyst;
    default:
      return category;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? languageCode = prefs.getString('language_code');
  
  runApp(LegitCheckApp(savedLanguageCode: languageCode));
}

class LegitCheckApp extends StatefulWidget {
  final String? savedLanguageCode;
  const LegitCheckApp({super.key, this.savedLanguageCode});

  @override
  State<LegitCheckApp> createState() => _LegitCheckAppState();
}

class _LegitCheckAppState extends State<LegitCheckApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    if (widget.savedLanguageCode != null) {
      _locale = Locale(widget.savedLanguageCode!);
    }
  }

  void _changeLanguage(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LegitCheck',
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('hi', ''), // Hindi
        Locale('ta', ''), // Tamil
        Locale('te', ''), // Telugu
        Locale('kn', ''), // Kannada
        Locale('mr', ''), // Marathi
      ],
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
           style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.grey),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
        ),
      ),
      home: _locale == null 
        ? LanguageSelectionScreen(onLocaleChanged: _changeLanguage)
        : VerificationScreen(onLocaleChanged: _changeLanguage),
    );
  }
}

class LanguageSelectionScreen extends StatelessWidget {
  final Function(Locale) onLocaleChanged;
  const LanguageSelectionScreen({super.key, required this.onLocaleChanged});

  void _selectLanguage(BuildContext context, Locale locale) {
    onLocaleChanged(locale);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => VerificationScreen(onLocaleChanged: onLocaleChanged),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.language, size: 80, color: primaryColor),
                const SizedBox(height: 24),
                const Text(
                  'Select a Language',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please choose your preferred language to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => _selectLanguage(context, const Locale('en')),
                  child: const Text('English'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _selectLanguage(context, const Locale('hi')),
                  child: const Text('हिंदी (Hindi)'),
                ),
                const SizedBox(height: 16),
                 ElevatedButton(
                  onPressed: () => _selectLanguage(context, const Locale('ta')),
                  child: const Text('தமிழ் (Tamil)'),
                ),
                const SizedBox(height: 16),
                 ElevatedButton(
                  onPressed: () => _selectLanguage(context, const Locale('te')),
                  child: const Text('తెలుగు (Telugu)'),
                ),
                const SizedBox(height: 16),
                 ElevatedButton(
                  onPressed: () => _selectLanguage(context, const Locale('kn')),
                  child: const Text('ಕನ್ನಡ (Kannada)'),
                ),
                const SizedBox(height: 16),
                 ElevatedButton(
                  onPressed: () => _selectLanguage(context, const Locale('mr')),
                  child: const Text('मराठी (Marathi)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VerificationScreen extends StatefulWidget {
  final Function(Locale) onLocaleChanged;
  const VerificationScreen({super.key, required this.onLocaleChanged});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Map<String, dynamic>>>? _searchFuture;
  
  final List<String> _categories = DatabaseHelper.categories;
  String _selectedCategory = 'All';
  bool _searchPerformed = false;

  @override
  void initState() {
    super.initState();
    _searchFuture = Future.value([]);
  }

  void _performSearch() {
    setState(() {
      _searchPerformed = true;
      if (_searchController.text.isEmpty) {
        _searchFuture = Future.value([]);
      } else {
        _searchFuture = DatabaseHelper().searchAllTables(_searchController.text);
      }
    });
  }

  void _showFilterModal() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                l10n.selectCategoryTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            LimitedBox(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return ListTile(
                    title: Text(_getLocalizedDisplayName(context, category), style: const TextStyle(fontWeight: FontWeight.w500)),
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                      Navigator.pop(context);
                    },
                    trailing: _selectedCategory == category
                        ? const Icon(Icons.check_circle, color: primaryColor)
                        : const Icon(Icons.circle_outlined, color: Colors.grey),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLanguagePicker() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Language'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                widget.onLocaleChanged(const Locale('en', ''));
                Navigator.pop(context);
              },
              child: const Text('English'),
            ),
            SimpleDialogOption(
              onPressed: () {
                widget.onLocaleChanged(const Locale('hi', ''));
                Navigator.pop(context);
              },
              child: const Text('हिंदी (Hindi)'),
            ),
             SimpleDialogOption(
              onPressed: () {
                widget.onLocaleChanged(const Locale('ta', ''));
                Navigator.pop(context);
              },
              child: const Text('தமிழ் (Tamil)'),
            ),
             SimpleDialogOption(
              onPressed: () {
                widget.onLocaleChanged(const Locale('te', ''));
                Navigator.pop(context);
              },
              child: const Text('తెలుగు (Telugu)'),
            ),
             SimpleDialogOption(
              onPressed: () {
                widget.onLocaleChanged(const Locale('kn', ''));
                Navigator.pop(context);
              },
              child: const Text('ಕನ್ನಡ (Kannada)'),
            ),
             SimpleDialogOption(
              onPressed: () {
                widget.onLocaleChanged(const Locale('mr', ''));
                Navigator.pop(context);
              },
              child: const Text('मराठी (Marathi)'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.article_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CredibilityScreen()),
              );
            },
            tooltip: 'Verify Announcement',
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _showLanguagePicker,
            tooltip: 'Change Language',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.searchHintText,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                ),
                onSubmitted: (value) => _performSearch(),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _performSearch,
                      child: Text(l10n.verifyButtonText),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.filter_list),
                    label: Text(_getLocalizedDisplayName(context, _selectedCategory)),
                    onPressed: _showFilterModal,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _searchFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final allResults = snapshot.data!;
                      final filteredResults = _selectedCategory == 'All'
                          ? allResults
                          : allResults.where((item) => item['category'] == _selectedCategory).toList();
                      
                      if (filteredResults.isNotEmpty) {
                        return ListView.builder(
                          itemCount: filteredResults.length,
                          itemBuilder: (context, index) {
                            return VerifiedCard(item: filteredResults[index]);
                          },
                        );
                      } else if (_searchPerformed && _searchController.text.isNotEmpty) {
                        return const NotFoundCard();
                      } else {
                        return const WelcomeMessage();
                      }
                    } else {
                      return const WelcomeMessage();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerifiedCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const VerifiedCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final category = item['category']?.toString() ?? 'N/A';
    final categoryColor = _getColorForCategory(category);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: const Border(left: BorderSide(color: successColor, width: 5)),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12), 
            bottomRight: Radius.circular(12)
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified_user, color: successColor),
                  const SizedBox(width: 8),
                  Text(
                    l10n.statusVerified,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: successColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(
                  _getLocalizedDisplayName(context, category),
                  overflow: TextOverflow.ellipsis,
                ),
                backgroundColor: categoryColor.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: categoryColor,
                  fontWeight: FontWeight.bold
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              const Divider(height: 24),
              _buildInfoRow(l10n.labelName, item['Name']?.toString() ?? 'N/A'),
              _buildInfoRow(l10n.labelRegNo, item['Registration No.']?.toString() ?? 'N/A'),
              if (item.containsKey('Address') && item['Address'] != null)
                _buildInfoRow(l10n.labelAddress, item['Address']?.toString() ?? 'N/A'),
              if (item.containsKey('Contact Person') && item['Contact Person'] != null)
                _buildInfoRow(l10n.labelContactPerson, item['Contact Person']?.toString() ?? 'N/A'),
              if (item.containsKey('Email-Id') && item['Email-Id'] != null)
                _buildInfoRow(l10n.labelEmail, item['Email-Id']?.toString() ?? 'N/A'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 16, height: 1.5),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class NotFoundCard extends StatelessWidget {
  const NotFoundCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: errorColor.withOpacity(0.05),
      child: Container(
        decoration: BoxDecoration(
          border: const Border(left: BorderSide(color: errorColor, width: 5)),
           borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12), 
            bottomRight: Radius.circular(12)
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: errorColor, size: 32),
                const SizedBox(width: 12),
                Text(
                  l10n.statusNotFound,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: errorColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.notFoundMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16, 
                color: Color(0xFF424242),
                fontWeight: FontWeight.w500,
                height: 1.5
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shield_outlined, size: 100, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            l10n.welcomeTitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.welcomeMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class CredibilityScreen extends StatefulWidget {
  const CredibilityScreen({super.key});

  @override
  State<CredibilityScreen> createState() => _CredibilityScreenState();
}

class _CredibilityScreenState extends State<CredibilityScreen> {
  final TextEditingController _announcementController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _result;

  // --- UPDATED to call the LIVE back-end URL ---
  Future<void> _verifyAnnouncement() async {
    final l10n = AppLocalizations.of(context)!;
    final announcementText = _announcementController.text;
    if (announcementText.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      final url = Uri.parse('https://legitcheck-backend-224224635857.asia-south1.run.app/verify_announcement');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'announcement_text': announcementText}),
      );

      if (response.statusCode == 200) {
        final backendResponse = json.decode(response.body);
        
        // The Gemini API returns a JSON string, which needs to be cleaned and decoded
        String aiResponseString = backendResponse['ai_response'];
        aiResponseString = aiResponseString.replaceAll('```json', '').replaceAll('```', '').trim();
        
        _result = json.decode(aiResponseString);
      } else {
        // Handle server errors
        _result = {
          "credibility_score": l10n.credibilityScoreUnverifiable, // Default to unverifiable
          "justification": ["Failed to connect to the verification server."]
        };
      }
    } catch (e) {
      // Handle network or other errors
      _result = {
        "credibility_score": l10n.credibilityScoreUnverifiable, // Default to unverifiable
        "justification": ["A network error occurred. Please check your connection."]
      };
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.credibilityCheckTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _announcementController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: l10n.credibilityHintText,
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyAnnouncement,
                child: Text(l10n.credibilityVerifyButton),
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator()),
              if (_result != null)
                CredibilityResultCard(result: _result!),
            ],
          ),
        ),
      ),
    );
  }
}

class CredibilityResultCard extends StatelessWidget {
  final Map<String, dynamic> result;
  const CredibilityResultCard({super.key, required this.result});

  // Helper to get translated score
  String _getTranslatedScore(BuildContext context, String score) {
    final l10n = AppLocalizations.of(context)!;
    switch (score) {
      case 'High Credibility':
        return l10n.credibilityScoreHigh;
      case 'Low Credibility':
        return l10n.credibilityScoreLow;
      case 'Unverifiable':
        return l10n.credibilityScoreUnverifiable;
      default:
        return score;
    }
  }

  @override
  Widget build(BuildContext context) {
    final score = result['credibility_score'];
    final justifications = result['justification'] as List<dynamic>;
    
    Color cardColor;
    IconData cardIcon;

    switch (score) {
      case 'High Credibility':
        cardColor = successColor;
        cardIcon = Icons.check_circle;
        break;
      case 'Low Credibility':
        cardColor = errorColor;
        cardIcon = Icons.cancel;
        break;
      case 'Unverifiable':
      default:
        cardColor = warningColor;
        cardIcon = Icons.warning_amber_rounded;
        break;
    }

    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: cardColor, width: 5)),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12)
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(cardIcon, color: cardColor),
                  const SizedBox(width: 8),
                  Text(
                    _getTranslatedScore(context, score),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cardColor,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              ...justifications.map((reason) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ', style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                      Expanded(
                        child: Text(
                          reason.toString(),
                          style: const TextStyle(fontSize: 16, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

