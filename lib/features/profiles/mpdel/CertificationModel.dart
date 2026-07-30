class CertificationModel {

  final int? id;

  final String? name;

  final String? issuer;

  final String? issuedAt;

  final String? expiresAt;

  final String? credentialId;

  CertificationModel({

    this.id,
    this.name,
    this.issuer,
    this.issuedAt,
    this.expiresAt,
    this.credentialId,
  });

  factory CertificationModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return CertificationModel(

      id: json["id"],

      name: json["name"],

      issuer: json["issuer"],

      issuedAt: json["issued_at"],

      expiresAt: json["expires_at"],

      credentialId:
          json["credential_id"],
    );
  }
}