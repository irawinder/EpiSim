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
  adult.setAge(32, 18, 65);
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
  
  home.addHost(adult);
  
  println(home);
  for(Element e : home.getHosts()) {
    println("- " + e);
  }
  println("---");
    
  home.addHost(adult); // test redundancy
  println("---");
  
  home.removeHost(adult);
  
  println(home);
  for(Element e : home.getHosts()) {
    println("- " + e);
  }
  println("---");
  
  adult.addAgent(corona);
  work.addHost(adult);
  work.addAgent(corona);
  
  println(work);
  for(Element e : work.getHosts()) {
    println("- " + e);
  }
  println("---");
  
    println(adult);
  for(Element e : adult.getAgents()) {
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
  
  println("Expect: '7.0 DAY'; Returns: '" + f.getAmount() + " " + f.getUnit() + "'");
  println("Expect: '96.0 HOUR'; Returns: '" + duration.getAmount() + " " + duration.getUnit() + "'");
  
}
