void test() {
  
  int counter = 0;
  
  Place home = new Place();
  home.setUID(counter); counter++;
  home.setName("Ira' House");
  home.setUse(LandUse.DWELLING);
  home.setSize(100);
  
  Place work = new Place();
  work.setUID(counter); counter++;
  work.setName("EDGEof");
  work.setUse(LandUse.OFFICE);
  work.setSize(1000);
  
  Person adult = new Person();
  adult.setUID(counter); counter++;
  adult.setName("Ira");
  adult.setAge(32);
  adult.setPrimaryPlace(home);
  adult.setSecondaryPlace(work);
  
  Agent corona = new Agent();
  corona.setUID(counter); counter++;
  corona.setName("COVID-19");
  
  println(home);
  println(work);
  println("---");
  
  println(adult);
  println("- Primary Loc: " + adult.getPrimaryPlace());
  println("- Secondary Loc: " + adult.getSecondaryPlace());
  println("---");
  
  println(corona);
  println("---");
  
  home.addElement(adult);
  
  println(home);
  for(Element e : home.getElements()) {
    println("- " + e);
  }
  println("---");
    
  home.addElement(adult); // test redundancy
  println("---");
  
  home.removeElement(adult);
  
  println(home);
  for(Element e : home.getElements()) {
    println("- " + e);
  }
  println("---");
  
  adult.addElement(corona);
  work.addElement(adult);
  work.addElement(corona);
  
  println(work);
  for(Element e : work.getElements()) {
    println("- " + e);
  }
  println("---");
  
    println(adult);
  for(Element e : adult.getElements()) {
    println("- " + e);
  }
  println("---");
}

public void testTime() {
  Time i = new Time(72, TimeUnit.HOUR);
  Time f = new Time(7, TimeUnit.DAY);
  TimeInterval step = new TimeInterval(i, f);
  Time duration = step.getDuration();
  
  println(i);
  println(f);
  println(step);
  
  println("Expect: '168.0 HOUR'; Returns: '" + f.getAmount() + " " + f.getUnit() + "'");
  println("Expect: '96.0 HOUR'; Returns: '" + duration.getAmount() + " " + duration.getUnit() + "'");
  
}
