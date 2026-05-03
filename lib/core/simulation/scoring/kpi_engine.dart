import '../../../data/models/company/company.dart';
import '../../../data/models/company/kpi.dart';

/// Computes derived KPIs not stored on Company directly.
class KpiEngine {
  const KpiEngine();

  List<Kpi> compute(Company co) {
    return [
      Kpi(
        id: 'revenue_per_unit',
        label: 'Revenue / Unit',
        value: co.unitPrice,
        unit: '\$',
      ),
      Kpi(
        id: 'gross_margin_per_unit',
        label: 'Gross Margin / Unit',
        value: co.unitPrice - 35,
        unit: '\$',
      ),
    ];
  }
}
