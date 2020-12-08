class Info {
  final String title;
  final String link;
  Info(this.title, this.link);
}

class Infos {
  List<Info> _infos = [
    Info('Telangana Covid Wesbite', 'https://covid19.telangana.gov.in/'),
    Info('Testing Centers in Telangana',
        'https://covid19.telangana.gov.in/health-facilities/testing-centres/'),
    Info('Treatment Facilities in Telangana',
        'https://covid19.telangana.gov.in/health-facilities/treatment-facilities/'),
    Info('COVID related contacts',
        'https://covid19.telangana.gov.in/control-rooms/'),
    Info('Important instruction to fight COVID',
        'https://covid19.telangana.gov.in/resources/'),
    Info('Telangana Government Plasma Donation and Request',
        'https://donateplasma.scsc.in/'),
    Info('Givered - Plasma Donation and request', 'https://www.givered.in/')
  ];

  List<Info> get getInfo => _infos;
}
