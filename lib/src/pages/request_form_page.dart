import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_widgets.dart';

class RequestFormPage extends StatefulWidget {
  static const routeName = '/request-form';

  const RequestFormPage({super.key});

  @override
  State<RequestFormPage> createState() => _RequestFormPageState();
}

class _RequestFormPageState extends State<RequestFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _sectorController = TextEditingController();

  String selectedPlan = consultationPlans.first.id;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String && consultationPlans.any((plan) => plan.id == arg)) {
      selectedPlan = arg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('فرم درخواست مشاوره'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionTitle(title: 'درخواست مشاوره', subtitle: 'لطفاً اطلاعات تماس خود را وارد کنید'),
                const SizedBox(height: 18),
                ..._buildPersonalSection(),
                const SizedBox(height: 24),
                PremiumActionButton(
                  label: 'پیش نمایش اطلاعات',
                  onPressed: _nextStep,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPersonalSection() {
    return [
      _buildInputField(label: 'نام و نام خانوادگی', controller: _nameController, validator: _requiredValidator),
      _buildInputField(label: 'شماره موبایل', controller: _phoneController, keyboardType: TextInputType.phone, validator: _requiredValidator),
      _buildInputField(label: 'ایمیل', controller: _emailController, keyboardType: TextInputType.emailAddress, validator: _emailValidator),
      _buildInputField(label: 'نام شرکت / مجموعه', controller: _companyController),
      _buildInputField(label: 'حوزه فعالیت', controller: _sectorController),
    ];
  }

  Widget _buildInputField({required String label, required TextEditingController controller, TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.secondary),
          filled: true,
          fillColor: AppColors.surfaceVariant,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      final request = ConsultationRequest(
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        company: _companyController.text.trim(),
        sector: _sectorController.text.trim(),
        subject: '',
        details: '',
        planId: selectedPlan,
        contactMethod: '',
        agreed: true,
      );
      Navigator.pushNamed(context, '/payment', arguments: request);
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'این فیلد الزامی است';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'این فیلد الزامی است';
    }
    if (!value.contains('@')) {
      return 'ایمیل معتبر نیست';
    }
    return null;
  }
}
