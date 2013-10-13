import './client/spaces.dart';

const spaces = ".spaces" ;
const spaceElements = ".space" ;
const spaceNW = ".space-north-west" ;
const spaceNE = ".space-north-east" ;
const spaceSW = ".space-south-west" ;
const spaceSE = ".space-south-east" ;
const spaceCenter = ".space-center" ;

void main() {
  SpacesLayout layout = new SpacesLayout(spaces,spaceElements,spaceNW,spaceNE,spaceSW,spaceSE,spaceCenter,180);
}

