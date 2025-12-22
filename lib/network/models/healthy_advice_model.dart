import 'dart:convert';
/// status : "Thừa cân"
/// label : "Cần chú ý"
/// description : "Chỉ số BMI 24.5 của bạn nằm ở mức thừa cân nhẹ theo tiêu chuẩn WHO dành cho người châu Á, tăng nguy cơ mắc các bệnh tim mạch và tiểu đường type 2. Bạn nên duy trì chế độ ăn giảm tinh bột tinh chế, tăng rau củ và protein nạc, đồng thời tập cardio như đi bộ nhanh 30 phút mỗi ngày 5 ngày/tuần để hướng tới mức bình thường."
/// percent : 75
/// bmi_input : 24.5

HealthyAdviceModel healthyAdviceModelFromJson(String str) => HealthyAdviceModel.fromJson(json.decode(str));
String healthyAdviceModelToJson(HealthyAdviceModel data) => json.encode(data.toJson());
class HealthyAdviceModel {
  HealthyAdviceModel({
      String? status, 
      String? label, 
      String? description, 
      num? percent, 
      num? bmiInput,}){
    _status = status;
    _label = label;
    _description = description;
    _percent = percent;
    _bmiInput = bmiInput;
}

  HealthyAdviceModel.fromJson(dynamic json) {
    _status = json['status'];
    _label = json['label'];
    _description = json['description'];
    _percent = json['percent'];
    _bmiInput = json['bmi_input'];
  }
  String? _status;
  String? _label;
  String? _description;
  num? _percent;
  num? _bmiInput;
HealthyAdviceModel copyWith({  String? status,
  String? label,
  String? description,
  num? percent,
  num? bmiInput,
}) => HealthyAdviceModel(  status: status ?? _status,
  label: label ?? _label,
  description: description ?? _description,
  percent: percent ?? _percent,
  bmiInput: bmiInput ?? _bmiInput,
);
  String? get status => _status;
  String? get label => _label;
  String? get description => _description;
  num? get percent => _percent;
  num? get bmiInput => _bmiInput;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['label'] = _label;
    map['description'] = _description;
    map['percent'] = _percent;
    map['bmi_input'] = _bmiInput;
    return map;
  }

}