/**
 * Viewer for Model Results, Graphs, and other summary info
 */
public class ResultView extends CityView {
  
  private BarGraph compartment;
  private BarGraph hospitalized;
  
  private PGraphics compartmentAxes;
  private PGraphics hospitalizedAxes;
  
  public ResultView(CityModel model, ResultSeries outcome) {
    super(model);
    compartment = new BarGraph();
    hospitalized = new BarGraph();
  }
  
  public void initGraphs() {
    String yLabel = this.getName(ViewParameter.GRAPH_LABEL_Y);
    
    // Init Title and Labels
    String cTitle = this.getName(PersonMode.COMPARTMENT);
    String hTitle = this.getName(ViewParameter.HOSPITALIZED);
    compartment.setTitle(cTitle);
    compartment.setLabelY(yLabel);
    hospitalized.setTitle(hTitle);
    hospitalized.setLabelY(yLabel);
    
    // Init Dimensions
    int generalMargin = (int) this.getValue(ViewParameter.GENERAL_MARGIN);
    int rightPanelWidth = (int) this.getValue(ViewParameter.RIGHT_PANEL_WIDTH);
    int w = rightPanelWidth - 2*generalMargin;
    int h = (int) this.getValue(ViewParameter.GRAPH_HEIGHT);
    compartmentAxes   = createGraphics(w, h);
    hospitalizedAxes  = createGraphics(w, h);
    
    // Init background Axes Graphics
    this.renderAxes(compartmentAxes, compartment);
    this.renderAxes(hospitalizedAxes, hospitalized);
    
  }
  
  /**
   * draw Results to screen
   */
  public void drawResults(ResultSeries outcome) {
    int rightPanelWidth = (int) this.getValue(ViewParameter.RIGHT_PANEL_WIDTH);
    int generalMargin = (int) this.getValue(ViewParameter.GENERAL_MARGIN);
    int x = width - rightPanelWidth + generalMargin;
    int y = 0;
    
    y += generalMargin;
    image(compartmentAxes, x, y);
    
    y += compartmentAxes.height + generalMargin;
    image(hospitalizedAxes, x, y);
  }
  
  /**
   * Render Graph Axes and Labels
   */
  private void renderAxes(PGraphics axes, BarGraph results) {
    int textHeight = (int) this.getValue(ViewParameter.TEXT_HEIGHT);
    color textFill = (int) this.getColor(ViewParameter.TEXT_FILL);
    color axesStroke = (int) this.getColor(ViewParameter.AXES_STROKE);
    int w = axes.width;
    int h = axes.height;
    int margin = 2*textHeight;
    axes.beginDraw();
    axes.stroke(axesStroke);
    axes.line(margin, margin,     margin,     h - margin);
    axes.line(margin, h - margin, w, h - margin);
    axes.fill(textFill);
    axes.text(results.getTitle(), margin, textHeight);
    axes.pushMatrix();
    axes.translate(margin/2, h/2);
    axes.rotate((float) - Math.PI / 2);
    axes.textAlign(CENTER, CENTER);
    axes.text(results.getLabelY(), 0, 0);
    axes.popMatrix();
    axes.endDraw();
  }
}
