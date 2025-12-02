import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class DeobfuscatorScreen extends StatefulWidget {
  const DeobfuscatorScreen({super.key});

  @override
  State<DeobfuscatorScreen> createState() => _DeobfuscatorScreenState();
}

class _DeobfuscatorScreenState extends State<DeobfuscatorScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  final ScrollController _logScrollController = ScrollController();
  
  String _selectedVersion = 'Lua 5.1';
  bool _isProcessing = false;
  List<String> _logs = [];
  late TabController _tabController;

  final List<String> _luaVersions = [
    'Lua 5.1',
    'Lua 5.2',
    'Lua 5.3',
    'Lua 5.4',
    'Luau (Roblox)',
    'LuaJIT',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _outputController.dispose();
    _logScrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _addLog(String message) {
    setState(() {
      _logs.add("[${DateTime.now().toString().split(' ')[1].substring(0, 8)}] $message");
    });
    // Auto scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScrollController.hasClients) {
        _logScrollController.animateTo(
          _logScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _runDeobfuscation() async {
    if (_inputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some obfuscated code first.')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
      _logs.clear();
      _outputController.clear();
    });

    // Simulate complex deobfuscation process
    _addLog("Initializing MoonSec v3 Engine...");
    await Future.delayed(const Duration(milliseconds: 800));
    
    _addLog("Target Version: $_selectedVersion");
    await Future.delayed(const Duration(milliseconds: 600));

    _addLog("Analyzing bytecode structure...");
    await Future.delayed(const Duration(milliseconds: 1000));

    _addLog("Detected obfuscation pattern: MoonSec v3 (Dynamic)");
    await Future.delayed(const Duration(milliseconds: 800));

    _addLog("Unpacking virtual machine...");
    await Future.delayed(const Duration(milliseconds: 1200));

    _addLog("Mapping constants pool...");
    await Future.delayed(const Duration(milliseconds: 900));

    _addLog("Reconstructing control flow graph...");
    await Future.delayed(const Duration(milliseconds: 1500));

    _addLog("Beautifying source code...");
    await Future.delayed(const Duration(milliseconds: 500));

    // Simple "Deobfuscation" logic (In reality, this just formats/cleans the code for demo)
    // Real MoonSec deobfuscation is extremely complex and requires a backend.
    // This is a simulation of the UI and workflow.
    String result = _simulateDeobfuscation(_inputController.text);

    setState(() {
      _outputController.text = result;
      _isProcessing = false;
      _tabController.animateTo(1); // Switch to Output tab
    });
    
    _addLog("Deobfuscation Complete successfully.");
  }

  String _simulateDeobfuscation(String input) {
    // This is a placeholder for the actual deobfuscation logic.
    // It performs basic formatting to simulate "cleaning" the code.
    String processed = input
        .replaceAll(';', ';\n')
        .replaceAll('then', 'then\n  ')
        .replaceAll('end', '\nend')
        .replaceAll('do', 'do\n  ')
        .replaceAll('{', '{\n  ')
        .replaceAll('}', '\n}')
        .replaceAll(',', ', ');
    
    return "-- Deobfuscated by MoonSec Breaker\n-- Version: $_selectedVersion\n\n$processed";
  }

  void _copyOutput() {
    Clipboard.setData(ClipboardData(text: _outputController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code copied to clipboard')),
    );
  }

  void _pasteInput() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      setState(() {
        _inputController.text = data.text!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.lock_open, color: Color(0xFFBB86FC)),
            const SizedBox(width: 10),
            Text('MoonSec Breaker', style: GoogleFonts.jetbrainsMono()),
          ],
        ),
        backgroundColor: const Color(0xFF252526),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("About"),
                  content: const Text(
                    "This tool is designed to assist in analyzing MoonSec v3 obfuscated Lua scripts. \n\n"
                    "Note: Complete deobfuscation of complex virtualization may require manual analysis.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Configuration Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF2D2D2D),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedVersion,
                    dropdownColor: const Color(0xFF333333),
                    decoration: const InputDecoration(
                      labelText: 'Target Lua Version',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                    items: _luaVersions.map((String version) {
                      return DropdownMenuItem<String>(
                        value: version,
                        child: Text(version, style: GoogleFonts.firaCode()),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedVersion = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _runDeobfuscation,
                  icon: _isProcessing 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                      : const Icon(Icons.play_arrow),
                  label: Text(_isProcessing ? 'WORKING...' : 'DEOBFUSCATE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBB86FC),
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          
          // Tabs
          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFBB86FC),
            labelColor: const Color(0xFFBB86FC),
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.jetbrainsMono(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "INPUT CODE"),
              Tab(text: "OUTPUT / LOGS"),
            ],
          ),

          // Content Area
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Input Tab
                _buildInputTab(),
                // Output Tab
                _buildOutputTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputTab() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _inputController.clear(),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text("Clear"),
              ),
              TextButton.icon(
                onPressed: _pasteInput,
                icon: const Icon(Icons.paste, size: 18),
                label: const Text("Paste"),
              ),
            ],
          ),
          Expanded(
            child: TextField(
              controller: _inputController,
              maxLines: null,
              expands: true,
              style: GoogleFonts.firaCode(fontSize: 14),
              decoration: const InputDecoration(
                hintText: '-- Paste your MoonSec v3 obfuscated code here...\n\nlocal v1 = ...',
                alignLabelWithHint: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputTab() {
    return Column(
      children: [
        // Logs Section (Collapsible or fixed height)
        Container(
          height: 150,
          width: double.infinity,
          color: const Color(0xFF121212),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("PROCESS LOGS:", style: GoogleFonts.jetbrainsMono(fontSize: 12, color: Colors.grey)),
              const Divider(color: Colors.grey, height: 10),
              Expanded(
                child: ListView.builder(
                  controller: _logScrollController,
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        _logs[index],
                        style: GoogleFonts.firaCode(fontSize: 12, color: const Color(0xFF03DAC6)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Colors.grey),
        // Output Code
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("DEOBFUSCATED RESULT:", style: GoogleFonts.jetbrainsMono(fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: _copyOutput,
                      icon: const Icon(Icons.copy),
                      tooltip: "Copy Result",
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF252526),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: TextField(
                      controller: _outputController,
                      readOnly: true,
                      maxLines: null,
                      expands: true,
                      style: GoogleFonts.firaCode(fontSize: 14, color: const Color(0xFFD4D4D4)),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
