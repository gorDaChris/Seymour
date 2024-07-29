import 'package:seymour_app/Common/Models/tag.dart';

class FilteredTags {
  static final Map<String, Tag> tags = {
    'sculpture': Tag( displayName: 'Sculpture', artwork: true, filtered: true),
    'statue': Tag(displayName: 'Statue', artwork: true, filtered: true),
    'mural': Tag(displayName: 'Mural', artwork: true, filtered: true),
    'graffiti': Tag(displayName: 'Graffiti', artwork: true, filtered: true),
    'installation': Tag(displayName: 'Installation', artwork: true, filtered: true),
    'bust': Tag(displayName: 'Bust', artwork: true, filtered: true),
    'stone': Tag(displayName: 'Stone', artwork: true, filtered: true),
    'painting': Tag(displayName: 'Painting', artwork: true, filtered: true),
    'architecture': Tag(displayName: 'Architecture', artwork: true, filtered: true),
    'mosaic': Tag(displayName: 'Mosaic', artwork: true, filtered: true),
    'relief': Tag(displayName: 'Relief', artwork: true, filtered: true),
    'fountain': Tag(displayName: 'Fountain', artwork: true, filtered: true),
    'street_art': Tag(displayName: 'Street Art', artwork: true, filtered: true),
    'azulejo': Tag(displayName: 'Azulejo', artwork: true, filtered: true),
    'land_art': Tag(displayName: 'Land Art', artwork: true, filtered: true),
    'alpine_hut': Tag(displayName: 'Alpine Hut', artwork: false, filtered: true),
    'apartment': Tag(displayName: 'Apartment', artwork: false, filtered: true),
    'aquarium': Tag(displayName: 'Aquarium', artwork: false, filtered: true),
    'attraction': Tag(displayName: 'Attraction', artwork: false, filtered: true),
    'camp_pitch': Tag(displayName: 'Camp Pitch', artwork: false, filtered: true),
    'camp_site': Tag(displayName: 'Camp Site', artwork: false, filtered: true),
    'caravan_site': Tag(displayName: 'Caravan Site', artwork: false, filtered: true),
    'chalet': Tag(displayName: 'Chalet', artwork: false, filtered: true),
    'gallery': Tag(displayName: 'Gallery', artwork: false, filtered: true),
    'guest_house': Tag(displayName: 'Guest House', artwork: false, filtered: true),
    'hostel': Tag(displayName: 'Hostel', artwork: false, filtered: true),
    'information': Tag(displayName: 'Information', artwork: false, filtered: true),
    'motel': Tag(displayName: 'Motel', artwork: false, filtered: true),
    'museum': Tag(displayName: 'Museum', artwork: false, filtered: true),
    'picnic_site': Tag(displayName: 'Picnic Site', artwork: false, filtered: true),
    'theme_park': Tag(displayName: 'Theme Park', artwork: false, filtered: true),
    'viewpoint': Tag(displayName: 'Viewpoint', artwork: false, filtered: true),
    'wildnerness_hut': Tag(displayName: 'Wilderness Hut', artwork: false, filtered: true),
  };

  FilteredTags._();
}