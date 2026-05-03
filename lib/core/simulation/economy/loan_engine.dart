/// Loan & debt math helpers.
class LoanEngine {
  const LoanEngine();

  /// Annualised interest rate scaled by debt-to-equity stress.
  double computeRate({required double debt, required double equity}) {
    final ratio = equity == 0 ? double.infinity : debt / equity;
    if (ratio < 0.5) return 0.04;
    if (ratio < 1.0) return 0.07;
    if (ratio < 2.0) return 0.10;
    return 0.14;
  }

  /// Per-tick interest accrual.
  double tickInterest({required double debt, required double rate}) {
    // rate annualised → per-minute → per-tick equivalent.
    return debt * rate / (365 * 24 * 60) * 6 / 60;
  }
}
