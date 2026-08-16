import 'models/agenda_slot_model.dart';

/// TODO(api): mock data until `ApiEndpoints.agenda` exists.
class AgendaRepo {
  Future<List<AgendaSlotModel>> getToday() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      AgendaSlotModel(
        id: 'a-1',
        time: '09:15',
        patientName: 'رهف الدسري',
        patientInitial: 'ر',
        mrn: '',
        subtitle: 'كشف باطنة',
        status: AgendaSlotStatus.done,
      ),
      AgendaSlotModel(
        id: 'a-2',
        time: '09:40',
        patientName: 'ماجد الغامدي',
        patientInitial: 'م',
        mrn: '',
        subtitle: 'متابعة',
        status: AgendaSlotStatus.done,
      ),
      AgendaSlotModel(
        id: 'a-3',
        time: '10:30',
        patientName: 'منيرة العتيبي',
        patientInitial: 'م',
        mrn: '30412',
        subtitle: 'كشف باطنة',
        status: AgendaSlotStatus.arrived,
      ),
      AgendaSlotModel(
        id: 'a-4',
        time: '10:45',
        patientName: 'عبدالله العتيبي',
        patientInitial: 'ع',
        mrn: '30415',
        subtitle: 'متابعة',
        status: AgendaSlotStatus.arrived,
      ),
      AgendaSlotModel(
        id: 'a-5',
        time: '11:00',
        patientName: 'سعد المطيري',
        patientInitial: 'س',
        mrn: '29881',
        subtitle: 'كشف باطنة',
        status: AgendaSlotStatus.notArrived,
      ),
      AgendaSlotModel(
        id: 'a-6',
        time: '11:30',
        patientName: 'وليد الحربي',
        patientInitial: 'و',
        mrn: '',
        subtitle: 'استشارة فيديو',
        status: AgendaSlotStatus.paid,
      ),
      AgendaSlotModel(
        id: 'a-7',
        time: '12:00',
        patientName: 'نوف عبدالله',
        patientInitial: 'ن',
        mrn: '30480',
        subtitle: 'تطعيم · د. وليد',
        status: AgendaSlotStatus.confirmed,
      ),
    ];
  }
}
