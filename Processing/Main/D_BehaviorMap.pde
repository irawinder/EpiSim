/**
 * Land Use Category Map by Person Demographic
 */ 
public class BehaviorMap {
  
  // List of Land Uses categorized by whether a specific demographic considers it primary, secondary, or tertiary
  private HashMap<Demographic, HashMap<PlaceCategory, ArrayList<LandUse>>> activityMap;
  
  /**
   * Construct Empty Activity Map
   */ 
  public BehaviorMap() {
    activityMap = new HashMap<Demographic, HashMap<PlaceCategory, ArrayList<LandUse>>>();
    for(Demographic d : Demographic.values()) {
      HashMap<PlaceCategory, ArrayList<LandUse>> useMap = new HashMap<PlaceCategory, ArrayList<LandUse>>();
      for(PlaceCategory c : PlaceCategory.values()) {
        useMap.put(c, new ArrayList<LandUse>());
      }
      activityMap.put(d, useMap);
    }
  }
  
  /**
   * Set a list of uses for a specified category in a specified demographic
   *
   * @param d Demographic
   * @param c PlaceCategory
   * @param useList
   */
  public void setMap(Demographic d, PlaceCategory c, ArrayList<LandUse> useList) {
    activityMap.get(d).put(c, useList);
  }
  
 /**
   * Set a list of uses for a specified category in a specified demographic
   *
   * @param d Demographic
   * @param c PlaceCategory
   * @param use LandUse
   */
  public void setMap(Demographic d, PlaceCategory c, LandUse use) {
    ArrayList<LandUse> placeList = this.activityMap.get(d).get(c);
    if(placeList.contains(use)) {
      println(use + " already exists in map");
    } else {
      placeList.add(use);
    }
  }
  
 /**
   * Check if specified Place is activity for a specified category in a specified demographic
   *
   * @param d Demographic
   * @param c PlaceCategory
   * @param use LandUse
   *
   * @return true if use is valid activity
   */
  public boolean isActivity(Demographic d, PlaceCategory c, LandUse use) {
    ArrayList useList = activityMap.get(d).get(c);
    if(useList.contains(use)) {
      return true;
    } else {
      return false;
    }
  }
}
