// ignore_for_file: non_constant_identifier_names

class VcardParser {
  
  final VCARD_BEGIN_SIGN      = 'BEGIN:VCARD';
  final VCARD_END_SIGN        = 'END:VCARD';
  final VCARD_FIELD_SEPARATORS = [';', '='];
  final VCARD_TAG_SEPARATOR = '\n';
  final VCARD_TAG_KE_VALUE_SEPARATOR = ':';
  final List<String> VCARD_TAG_VALUE_IGONE_SEPARATOR = [',', ' '];
  final VCARD_TAGS = [
    'ADR',
    'AGENT',
    'BDAY',
    'CATEGORIES',
    'CLASS',
    'EMAIL',
    'FN',
    'GEO',
    'IMPP',
    'KEY',
    'LABEL',
    'LOGO',
    'MAILER',
    'N',
    'NAME',
    'NICKNAME',
    'NOTE',
    'ORG',
    'PHOTO',
    'PRODID',
    'PROFILE',
    'REV',
    'ROLE',
    'SORT-STRING'
    'SOUND',
    'SOURCE',
    'TEL',
    'TITLE',
    'TZ',
    'UID',
    'URL',
    'VERSION',
  ];

  String content;
  Map<String, Object> tags = <String,Object>{};
  VcardParser(this.content);

  Map<String, Object> parse() {
    Map<String,Object>? tags = <String, Object>{};

    List<String?> lines = content.replaceAll(";;", "").split(VCARD_TAG_SEPARATOR);
    for (var field in lines) {
      String? key;
      Object? value;

      List<String>? tagAndValue = field?.split(VCARD_TAG_KE_VALUE_SEPARATOR);
      if (tagAndValue?.length != 2) {
        continue;
      }

      key = tagAndValue?[0].trim();
      value = tagAndValue?[1].trim().replaceAll(VCARD_TAG_VALUE_IGONE_SEPARATOR[0], VCARD_TAG_VALUE_IGONE_SEPARATOR[1]);

      if (key?.contains(VCARD_FIELD_SEPARATORS[0]) ?? false) {
        value = parseFields(field?.trim());
      }

      if(tags.containsKey(key)) {
        List<Map<String,String>?> oldValues =  [];
        if(tags[key] is Map) {
          Map<String,String>? oldValue = tags[key] as Map<String, String>?;
          oldValues.add(oldValue!);
          oldValues.add(value as Map<String, String>?);
          value = oldValues;
        } else {
          oldValues = tags[key] as List<Map<String,String>?>;
          oldValues.add(value as Map<String, String>?);
          value = oldValues;
        }
      }
      tags[key!] = value!;
    }

    print("tags : $tags");

    this.tags = tags;
    return tags;
  }

  Object parseFields(String? line) {
    Object field = Object();
    List<String>? rawFields = line?.split(VCARD_FIELD_SEPARATORS[0]);

    rawFields?.getRange(1, rawFields.length).forEach((rawField) {
        List<String> items = [];
        List<String> rawItems = rawField.split(VCARD_FIELD_SEPARATORS[0]);
        if(rawItems.length == 1) {
          rawItems = rawField.split(VCARD_FIELD_SEPARATORS[1]);
        }

        if(rawItems.isNotEmpty) {
          for (var itemValue in rawItems) {
            items = itemValue.split(VCARD_TAG_KE_VALUE_SEPARATOR);
          }
        }

        if (items.length == 2) {
          field = {'name': items.elementAt(0), 'value': items.elementAt(1).replaceAll(VCARD_TAG_VALUE_IGONE_SEPARATOR[0], VCARD_TAG_VALUE_IGONE_SEPARATOR[1])};
        }
      });
      return field;
  }
}