import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_common/models/app-reward/user_point_balance.dart';
import 'package:flutter_common/state/app_reward/app_reward_bloc.dart';
import 'package:intl/intl.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  AppRewardBloc get appRewardBloc => context.read<AppRewardBloc>();
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();
  final _exchangeAmountController = TextEditingController();

  String? _selectedBank;

  int _minimumExchangeAmount = 10000;
  int _fee = 300;

  // 한국 은행 목록
  final List<String> _banks = [
    '신한은행',
    'KB국민은행',
    '우리은행',
    '하나은행',
    'NH농협은행',
    'IBK기업은행',
    '카카오뱅크',
    '토스뱅크',
    '케이뱅크',
    '새마을금고',
    '신협',
    '우체국',
    '기타',
  ];

  @override
  void dispose() {
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    _exchangeAmountController.dispose();
    super.dispose();
  }

  void _submitExchange() {
    if (_formKey.currentState!.validate()) {
      appRewardBloc.add(
        AppRewardEvent.createWithdrawal(
          _selectedBank!,
          _accountNumberController.text.trim(),
          _accountHolderController.text.trim(),
          int.parse(_exchangeAmountController.text.trim()),
        ),
      );
      AppNavigator.I.pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('환전 신청이 완료되었습니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('포인트 환전'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AppRewardUserPointBalanceSelector((userPointBalance) {
          if (userPointBalance == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 현재 포인트 표시
                _buildCurrentPoints(userPointBalance),
                const SizedBox(height: 24),

                // 환전 금액 입력
                _buildExchangeAmount(userPointBalance),
                const SizedBox(height: 24),

                // 은행 정보 입력
                _buildBankInfo(),
                const SizedBox(height: 24),

                // 안내 문구
                _buildNoticeInfo(),
                const SizedBox(height: 32),

                // 환전 버튼
                _buildExchangeButton(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentPoints(UserPointBalance userPointBalance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '현재 포인트',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '${NumberFormat('#,###').format(userPointBalance.currentPoints)} P',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeAmount(UserPointBalance userPointBalance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '환전할 포인트',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _exchangeAmountController,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: '환전할 포인트를 입력하세요',
            suffixText: 'P',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.green[600]!),
            ),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {}); // 환율 계산을 위해 rebuild
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '환전할 포인트를 입력해주세요';
            }
            final points = int.tryParse(value);
            if (points == null || points <= 0) {
              return '올바른 포인트를 입력해주세요';
            }
            if (points > userPointBalance.currentPoints) {
              return '보유 포인트보다 많은 금액을 환전할 수 없습니다';
            }
            if (points < _minimumExchangeAmount) {
              return '최소 환전 금액은 $_minimumExchangeAmount P입니다';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Text(
          '1P = ₩1로 환전됩니다',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        if (_exchangeAmountController.text.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.currency_exchange,
                  color: Colors.blue[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '예상 수령 금액: ₩${_calculateExchangeAmount()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _calculateExchangeAmount() {
    if (_exchangeAmountController.text.isEmpty) {
      return '0';
    }

    final points = int.tryParse(_exchangeAmountController.text);
    if (points == null) return '0';

    // 1P = 1원
    final amount = points - _fee;
    return amount.toString();
  }

  Widget _buildBankInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '은행 정보',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        // 은행 선택
        DropdownButtonFormField<String>(
          value: _selectedBank,
          decoration: InputDecoration(
            labelText: '은행 선택',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.green[600]!),
            ),
          ),
          items:
              _banks.map((bank) {
                return DropdownMenuItem(value: bank, child: Text(bank));
              }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedBank = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '은행을 선택해주세요';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // 계좌번호
        TextFormField(
          controller: _accountNumberController,
          decoration: InputDecoration(
            labelText: '계좌번호',
            hintText: '계좌번호를 입력하세요',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.green[600]!),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '계좌번호를 입력해주세요';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // 예금주
        TextFormField(
          controller: _accountHolderController,
          decoration: InputDecoration(
            labelText: '예금주',
            hintText: '예금주명을 입력하세요',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.green[600]!),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '예금주명을 입력해주세요';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNoticeInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              Text(
                '환전 안내',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• 환전 신청 후 매주 월요일에 송금됩니다\n'
            '• 최소 환전 금액: ${NumberFormat('#,###').format(_minimumExchangeAmount)} P\n'
            '• 수수료 ${NumberFormat('#,###').format(_fee)} P이 차감됩니다\n'
            '• 환전 신청 후 취소는 불가능합니다\n'
            '• 예금주명과 계좌번호가 정확히 일치하지 않으면 환전이 불가능합니다\n'
            '• 1P = ₩1로 환전됩니다',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitExchange,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          '환전 신청',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
