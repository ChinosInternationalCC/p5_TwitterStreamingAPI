// Chinos Twitter streaming API for processing
// based on https://github.com/neufuture/SimpleTwitterStream (by neufuture)

PFont font;

///////////////////////////// Config your setup here! ////////////////////////////
// You need to add your Consumer Keys and Access Tokens from Twitter.
// You must create an app at dev.twitter.com to receive them.

// This is where you enter your Oauth info
static String OAuthConsumerKey = "";
static String OAuthConsumerSecret = "";
// This is where you enter your Access Token info
static String AccessToken = "";
static String AccessTokenSecret = "";

String keywords[] = { "#chinostest" };

///////////////////////////// End Variable Config ////////////////////////////

TwitterStream twitter = new TwitterStreamFactory().getInstance();

int x;

void setup() {
  size(1000, 600);
  noStroke();
  font = createFont("Helvetica-bold", 22);
  background(0);

  connectTwitter();
  twitter.addListener(listener);
  if (keywords.length==0) twitter.sample();
  else twitter.filter(new FilterQuery().track(keywords));
}

void draw() {

  fill(0);
  noStroke();
  rect(0, 0, width, 50);
  x = (x + 10)% width;
  for(int i = 0; i< 6; i++) { // draws throbbing ballie thing
    fill(255-i*30);
    ellipse(x-i*10, 20, 10, 10);
  }
}

// Initial connection
void connectTwitter() {
  twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
  AccessToken accessToken = loadAccessToken();
  twitter.setOAuthAccessToken(accessToken);
}

// Loading up the access token
private static AccessToken loadAccessToken() {
  return new AccessToken(AccessToken, AccessTokenSecret);
}

// This listens for new tweet
StatusListener listener = new StatusListener() {
  
  public void onStatus(Status status) {
    println("-"+x+" @" + status.getUser().getScreenName() + " - " + status.getText());
    displayTw(status);
  }

  public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
    System.out.println("Got a status deletion notice id:" + statusDeletionNotice.getStatusId());
  }
  public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
    System.out.println("Got track limitation notice:" + numberOfLimitedStatuses);
  }
  public void onScrubGeo(long userId, long upToStatusId) {
    System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
  }

  public void onException(Exception ex) {
    ex.printStackTrace();
  }
};

/// my dirt test method for displaying tweets
void displayTw (Status s) {
  String who = "";
  String time = "";
  String txt = "";
  String where = "";
  who = s.getUser().getScreenName();
  time = s.getCreatedAt().toString();
  txt = s.getText();
  GeoLocation g =s.getGeoLocation();
  if (g!=null)where = g.toString();

  fill(0);
  noStroke();
  rect(0, 50, width, height);
  fill(255, 255, 255);
  textFont(font, 40);
  text("from: @"+ who, 10, 100);
  textSize(20);
  text("said: "+ txt, 10, 200);
  text("when: "+ time, 10, 300);
  text("where: "+ where, 10, 350);
}
