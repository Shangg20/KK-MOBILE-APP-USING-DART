import 'package:flutter/material.dart';
import '../services/db_helper.dart';

class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({super.key});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Data Maps for Region VIII Cascading Dropdowns
  final List<String> provinces = [
    'Biliran', 'Leyte', 'Southern Leyte', 'Samar', 'Northern Samar', 'Eastern Samar'
  ];

  final Map<String, List<String>> municipalityMap = {
    'Biliran': ['Almeria', 'Biliran', 'Cabucgayan', 'Caibiran', 'Culaba', 'Kawayan', 'Maripipi', 'Naval'],
    'Leyte': ['Tacloban City', 'Ormoc City', 'Abuyog', 'Alangalang', 'Baybay City', 'Burauen', 'Carigara', 'Palo', 'Tanauan'],
    'Southern Leyte': ['Maasin City', 'Macrohon', 'Sogod', 'Liloan', 'Saint Bernard'],
    'Samar': ['Catbalogan City', 'Calbayog City', 'Basey', 'Gandara'],
    'Northern Samar': ['Catarman', 'Laoang', 'Allen'],
    'Eastern Samar': ['Borongan City', 'Guiuan', 'Llorente'],
  };

  // Controllers for TextFields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _religionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _attendanceController = TextEditingController();
  final TextEditingController _purokController = TextEditingController();
  final TextEditingController _barangayController = TextEditingController();

  // Dropdown Values
  String _selectedGender = 'Male';
  String _selectedRegion = 'Region VIII'; // Default
  String? _selectedProvince;
  String? _selectedMunicipality;
  String? _selectedCivilStatus;
  String? _selectedAgeGroup;
  String? _selectedEducation;
  String? _selectedClassification;
  String? _selectedWorkStatus;

  int _isSkVoter = 0;
  int _isRegularVoter = 0;

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> row = {
        'first_name': _firstNameController.text,
        'middle_name': _middleNameController.text,
        'last_name': _lastNameController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'purok': _purokController.text,
        'barangay': _barangayController.text,
        'municipality': _selectedMunicipality ?? "", // From Dropdown
        'province': _selectedProvince ?? "",         // From Dropdown
        'region': _selectedRegion,                   // Default value
        'religion': _religionController.text,
        'sex': _selectedGender,
        'civil_status': _selectedCivilStatus,
        'youth_age_group': _selectedAgeGroup,
        'educational_background': _selectedEducation,
        'youth_classification': _selectedClassification,
        'working_status': _selectedWorkStatus,
        'is_sk_voter': _isSkVoter,
        'is_regular_voter': _isRegularVoter,
        'times_attended': int.tryParse(_attendanceController.text) ?? 0,
        'email': _emailController.text,
        'contact_number': _contactController.text,
        'is_synced': 0,
        'date_added': DateTime.now().toIso8601String(),
      };

      await DBHelper().insertProfiling(row);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Saved Locally!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("New Youth Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("I. Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              _buildTextField("First Name *", _firstNameController),
              _buildTextField("Middle Name *", _middleNameController),
              _buildTextField("Last Name *", _lastNameController),

              Row(
                children: [
                  Expanded(child: _buildTextField("Age *", _ageController, isNumber: true)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildDropdown("Gender *", ['Male', 'Female'], (val) => setState(() => _selectedGender = val!))),
                ],
              ),

              _buildTextField("Religion", _religionController),
              _buildTextField("Email Address *", _emailController),
              _buildTextField("Contact Number *", _contactController, isNumber: true),

              const Divider(height: 40),
              const Text("Location Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // --- REGION DROPDOWN (Locked to Region VIII) ---
              _buildDropdown("Region", ['Region VIII'], (val) => setState(() => _selectedRegion = val!)),

              // --- PROVINCE DROPDOWN ---
              _buildDropdown("Province *", provinces, (val) {
                setState(() {
                  _selectedProvince = val;
                  _selectedMunicipality = null; // Reset municipality when province changes
                });
              }),

              // --- MUNICIPALITY DROPDOWN (Cascading) ---
              _buildDropdown(
                "Municipality *",
                _selectedProvince == null ? [] : municipalityMap[_selectedProvince]!,
                (val) => setState(() => _selectedMunicipality = val),
              ),

              _buildTextField("Barangay *", _barangayController),
              _buildTextField("Purok / Street / Zone", _purokController),

              const SizedBox(height: 30),
              const Text("II. Demographic Characteristic", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              _buildDropdown("Civil Status *", ['Single', 'Married', 'Widowed', 'Separated', 'Divorced', 'Unknown', 'Live-in'], (val) => setState(() => _selectedCivilStatus = val)),
              _buildDropdown("Youth Age Group", ['Child Youth (15-17)', 'Core Youth (18-24)', 'Young Adult (25-30)'], (val) => setState(() => _selectedAgeGroup = val)),
              _buildDropdown("Educational Background", ['No Formal Education', 'Elementary Graduate', 'High School Graduate', 'College Undergraduate', 'College Graduate', 'Masters Level', 'Masters Graduate', 'Doctorate Level', 'Doctorate Graduate'], (val) => setState(() => _selectedEducation = val)),
              _buildDropdown("Youth Classification", ['Out-of-School Youth', 'In-School Youth', 'Employed Youth', 'Unemployed Youth', 'Youth with Specific Needs'], (val) => setState(() => _selectedClassification = val)),
              _buildDropdown("Working Status", ['Employed', 'Unemployed', 'Self-employed', 'Currently Looking for a Job'], (val) => setState(() => _selectedWorkStatus = val)),

              const SizedBox(height: 15),
              const Text("Registered SK Voter?", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Checkbox(value: _isSkVoter == 1, onChanged: (val) => setState(() => _isSkVoter = val! ? 1 : 0)),
                  const Text("Yes"),
                  const SizedBox(width: 20),
                  Checkbox(value: _isSkVoter == 0, onChanged: (val) => setState(() => _isSkVoter = val! ? 0 : 1)),
                  const Text("No"),
                ],
              ),

              const Text("Registered National/Regular Voter?", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Checkbox(value: _isRegularVoter == 1, onChanged: (val) => setState(() => _isRegularVoter = val! ? 1 : 0)),
                  const Text("Yes"),
                  const SizedBox(width: 20),
                  Checkbox(value: _isRegularVoter == 0, onChanged: (val) => setState(() => _isRegularVoter = val! ? 0 : 1)),
                  const Text("No"),
                ],
              ),

              _buildTextField("No. of times attended the KK Assembly", _attendanceController, isNumber: true),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _saveData,
                  icon: const Icon(Icons.save),
                  label: const Text("Save Profile", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // UI Helper Builders remain the same
  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFE8F0FE),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
            validator: (value) => (value == null || value.isEmpty) ? "Required" : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged, {String? currentValue}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            initialValue: currentValue,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFE8F0FE),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
            validator: (value) => (value == null || value.isEmpty) ? "Required" : null,
          ),
        ],
      ),
    );
  }
}