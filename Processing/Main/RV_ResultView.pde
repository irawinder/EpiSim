/**
 * Viewer for Model Results, Graphs, and other summary info
 */
public class ResultView extends CityView {
  
  private HashMap<TimePlot, Axes> plotLabels;
  private HashMap<TimePlot, PGraphics> plotAxes;
  
  // Should the simulation automatically stopp?
  private boolean autoStop;
  
  public ResultView(CityModel model) {
    super(model);
    plotLabels = new HashMap<TimePlot, Axes>();
    plotAxes   = new HashMap<TimePlot, PGraphics>();
    for(TimePlot tP : TimePlot.values()) {
      plotLabels.put(tP, new Axes());
    }
    
    this.autoStop = true;
  }
  
  public void initGraphs() {
    String yLabel = this.getName(ViewParameter.GRAPH_LABEL_Y);
    
    // Init Title and Labels
    for(TimePlot tP : TimePlot.values()) {
      String title = this.getName(tP);
      if(tP == TimePlot.COMPARTMENT) title += ": " + this.getCurrentPathogen().getName();
      plotLabels.get(tP).setTitle(title);
      plotLabels.get(tP).setLabelY(yLabel);
    }
    
    // Init Dimensions
    int generalMargin = (int) this.getValue(ViewParameter.GENERAL_MARGIN);
    int rightPanelWidth = (int) this.getValue(ViewParameter.RIGHT_PANEL_WIDTH);
    int w = rightPanelWidth - 2*generalMargin;
    int h = (int) this.getValue(ViewParameter.GRAPH_HEIGHT);
    for(TimePlot tP : TimePlot.values()) {
      plotAxes.put(tP, createGraphics(w, h));
      this.renderAxes(plotAxes.get(tP), plotLabels.get(tP));
    }
  }
  
  /**
   * draw Results to screen
   *
   * @param outcome ResultSeries
   */
  public void drawResults(ResultSeries outcome) {
    int rightPanelWidth = (int) this.getValue(ViewParameter.RIGHT_PANEL_WIDTH);
    int generalMargin = (int) this.getValue(ViewParameter.GENERAL_MARGIN);
    int x = width - rightPanelWidth + generalMargin;
    int y = 0;
    
    pushMatrix();
    translate(x, y);
    
    // Draw Compartment Graph
    translate(0, generalMargin);
    PGraphics cAxes = plotAxes.get(TimePlot.COMPARTMENT);
    image(cAxes, 0, 0);
    this.drawGraph(outcome, TimePlot.COMPARTMENT);
    translate(0, cAxes.height + generalMargin);
    
    // Draw Hospitalization Graph
    PGraphics hAxes = plotAxes.get(TimePlot.HOSPITALIZED);
    image(hAxes, 0, 0);
    this.drawGraph(outcome, TimePlot.HOSPITALIZED);
    translate(0, hAxes.height + generalMargin);
    
    popMatrix();
    
    // Draw Other Numerical Stats
    if(outcome.getTimes().size() > 0 && height > 850) {
      Time lastTime = outcome.getTimes().get(outcome.getTimes().size()-1);
      Result r = outcome.getResult(lastTime);
      Pathogen p = getCurrentPathogen();
      
      int population = r.getPeopleTally();
      int hospitalized = 0;
      int hospitalCapacity = r.getHospitalBeds();
      Rate hospitalPerCapita = new Rate((float) hospitalCapacity / population);
      int infected = 0;
      int deaths = 0;
      int deathsSurvivable = 0;
      int recovered = 0;
      for(Demographic d : Demographic.values()) {
        hospitalized     += r.getHospitalizedTally(d);
        infected         += r.getCompartmentTally(d, p, Compartment.INCUBATING);
        infected         += r.getCompartmentTally(d, p, Compartment.INFECTIOUS);
        infected         += r.getCompartmentTally(d, p, Compartment.RECOVERED);
        infected         += r.getCompartmentTally(d, p, Compartment.DEAD_TREATED);
        infected         += r.getCompartmentTally(d, p, Compartment.DEAD_UNTREATED);
        recovered        += r.getCompartmentTally(d, p, Compartment.RECOVERED);
        deaths           += r.getCompartmentTally(d, p, Compartment.DEAD_TREATED);
        deaths           += r.getCompartmentTally(d, p, Compartment.DEAD_UNTREATED);
        deathsSurvivable += r.getCompartmentTally(d, p, Compartment.DEAD_UNTREATED);
      }
      
      Rate deathRate = new Rate((double) deaths / (recovered + deaths));
      
      String otherStats = "";
      otherStats += "Total Population: " + population + "\n";
      otherStats += "Hospital Capacity: " + hospitalPerCapita + " of population (" + hospitalCapacity + " beds)\n";
      otherStats += "Currently Hospitalized: " + hospitalized + "\n\n";
      otherStats += "Pathogen: " + p.getName() + "\n";
      otherStats += "Total Infected: " + infected + "\n";
      otherStats += "Total Recovered: " + recovered + "\n";
      otherStats += "Total Deaths: " + deaths + "\n";
      otherStats += "Death Rate: " + deathRate + "\n\n";
      otherStats += "Survivable* Deaths: " + deathsSurvivable + "\n\n";
      otherStats += "*Survivable deaths are deaths that could have been\n prevented if hospitals had not been overburdened.";
      
      int textHeight = (int) this.getValue(ViewParameter.TEXT_HEIGHT);
      color textFill = (int) this.getColor(ViewParameter.TEXT_FILL);
      
      fill(textFill);
      textAlign(LEFT, BOTTOM);
      text(otherStats, x + 2*textHeight, height - generalMargin);
      textAlign(LEFT);
    }
  }
  
  /**
   * Render Graph Axes and Labels
   *
   * @param axes PGraphics
   * @param resultAxes Axes
   */
  private void renderAxes(PGraphics axes, Axes resultAxes) {
    int textHeight = (int) this.getValue(ViewParameter.TEXT_HEIGHT);
    color textFill = (int) this.getColor(ViewParameter.TEXT_FILL);
    color axesStroke = (int) this.getColor(ViewParameter.AXES_STROKE);
    int w = axes.width;
    int h = axes.height;
    int margin = 2*textHeight;
    
    axes.beginDraw();
    
        // Axes LInes
        axes.stroke(axesStroke);
        axes.line(margin,     margin, margin, h - margin);
        axes.line(margin, h - margin,      w, h - margin);
        
        // Title
        axes.fill(textFill);
        axes.text(resultAxes.getTitle(), margin, textHeight);
        
        // Y-Axis Label
        axes.pushMatrix();
        axes.translate(margin/2, h/2);
        axes.rotate((float) - Math.PI / 2);
        axes.textAlign(CENTER, CENTER);
        axes.text(resultAxes.getLabelY(), 0, 0);
        axes.popMatrix();
    
    axes.endDraw();
  }
  
  /**
   * Render Graph
   */
  protected void drawGraph(ResultSeries outcome, TimePlot plotType) {
    
    // Calculate Number of events in series to show in graph
    int textHeight = (int) this.getValue(ViewParameter.TEXT_HEIGHT);
    int margin = 2*textHeight;
    int w = plotAxes.get(plotType).width;
    int barWidth = (int) this.getValue(ViewParameter.GRAPH_BAR_WIDTH);
    int numFields = (w - margin) / barWidth;
    
    pushMatrix();
    translate(margin, margin);
    noStroke();
    
    // Cycle through last n fields
    if (outcome.getTimes().size() == numFields && this.autoStop) {
      this.setAutoRun(false);
      this.autoStop = false;
    }
    int initialIndex = Math.max(0, outcome.getTimes().size() - numFields);
    int xPos = 1;
    for(int i = initialIndex; i<outcome.getTimes().size(); i++) {
      Time time = outcome.getTimes().get(i);
      Result r = outcome.getResult(time);
      switch(plotType) {
        case COMPARTMENT:
          this.drawCompartmentResult(xPos, r);
          break;
        case HOSPITALIZED:
          this.drawHospitalizedResult(xPos, r);
          break;
        case SYMPTOM:
          // TBA
          break;
        case ENCOUNTER:
          // TBA
          break;
        case TRIP:
          // TBA
          break;
      }
      xPos += barWidth;
      
      // Draw Indicator of last moment of time
      if(i == outcome.getTimes().size() - 1) {
        
        int h = plotAxes.get(TimePlot.COMPARTMENT).height - 2*margin;
        color textFill = (int) this.getColor(ViewParameter.TEXT_FILL);
        color axesStroke = (int) this.getColor(ViewParameter.AXES_STROKE);
        
        Time lastTime = r.getTime();
        String day = "Day " + (int)lastTime.convert(TimeUnit.DAY).getAmount();
        String clock = lastTime.toClock();
        int timeX = xPos;
        int timeY = h + textHeight/2;
        
        fill(textFill);
        textAlign(RIGHT, TOP);
        text(day + "\n" + clock, timeX, timeY);
        textAlign(LEFT);
        
        stroke(axesStroke);
        line(timeX, 0, timeX, timeY);
        
        // Draw Hospital Legend
        if(plotType == TimePlot.HOSPITALIZED) {
          int amount = r.getHospitalBeds();
          int scaler = (int) this.getValue(TimePlot.HOSPITALIZED);
          float dotHeight = scaler * (float) h * (float) amount / (float) r.getPeopleTally();
          
          fill(textFill);
          textAlign(LEFT, BOTTOM);
          text("Capacity", textHeight/4, h - dotHeight - textHeight/4);
          textAlign(LEFT);
        }
      }
    }
      
    popMatrix();
  }
  
  // Draw Compartment Graph Bar Unit
  protected void drawCompartmentResult(int xPos, Result r) {
    int barWidth = (int) this.getValue(ViewParameter.GRAPH_BAR_WIDTH);
    Pathogen p = this.getCurrentPathogen();
    int textHeight = (int) this.getValue(ViewParameter.TEXT_HEIGHT);
    int margin = 2*textHeight;
    int h = plotAxes.get(TimePlot.COMPARTMENT).height - 2*margin;
    int barAlpha = (int) this.getValue(ViewParameter.GRAPH_ALPHA);
    
    float yPos = 0;
    for(Compartment c : Compartment.values()) {
      
      color barFill = this.getColor(c);
      float barHeight = 0;
      for(Demographic d : Demographic.values()) {
        int amount = r.getCompartmentTally(d, p, c);
        barHeight += (float) h * (float) amount / (float) r.getPeopleTally();
      }
      
      fill(barFill, barAlpha);
      rect(xPos, yPos, barWidth, barHeight);
      
      yPos += barHeight;
    }
  }
  
  // Draw Hospitalized Graph Unit
  protected void drawHospitalizedResult(int xPos, Result r) {
    int barWidth = (int) this.getValue(ViewParameter.GRAPH_BAR_WIDTH);
    int textHeight = (int) this.getValue(ViewParameter.TEXT_HEIGHT);
    int margin = 2*textHeight;
    int h = plotAxes.get(TimePlot.HOSPITALIZED).height - 2*margin;
    int scaler = (int) this.getValue(TimePlot.HOSPITALIZED);
    int barAlpha = (int) this.getValue(ViewParameter.GRAPH_ALPHA);
    
    float yPos = h;
    for(Demographic d : Demographic.values()) {
      color barFill = this.getColor(TimePlot.HOSPITALIZED);
      int amount = r.getHospitalizedTally(d);
      float barHeight = scaler * (float) h * (float) amount / (float) r.getPeopleTally();
      yPos -= barHeight;
      
      fill(barFill, barAlpha);
      rect(xPos, yPos, barWidth, barHeight);
    }
    
    // Hospital Capacity
    color textFill = (int) this.getColor(ViewParameter.TEXT_FILL);
    int amount = r.getHospitalBeds();
    float dotHeight = scaler * (float) h * (float) amount / (float) r.getPeopleTally();
    stroke(textFill);
    point(xPos, h - dotHeight);
    noStroke(); 
  }
}
