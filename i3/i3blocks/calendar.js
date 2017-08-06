var moment = require('moment');
var fs = require('fs');
var readline = require('readline');
var google = require('googleapis');
var googleAuth = require('google-auth-library');

// If modifying these scopes, delete your previously saved credentials
// at ~/.credentials/calendar-nodejs-quickstart.json
var SCOPES = ['https://www.googleapis.com/auth/calendar.readonly'];
var TOKEN_DIR = (process.env.HOME || process.env.HOMEPATH ||
    process.env.USERPROFILE) + '/.credentials/';
var TOKEN_PATH = TOKEN_DIR + 'calendar-nodejs-quickstart.json';

// Load client secrets from a local file.
fs.readFile('/home/daniel/GIT/dotfiles/i3/i3blocks/client_secret.json', function processClientSecrets(err, content) {
  if (err) {
    console.log('Error loading client secret file: ' + err);
    return;
  }
  // Authorize a client with the loaded credentials, then call the
    // Google Calendar API.
    try{
        authorize(JSON.parse(content), listEvents);
    } catch (err) {
        console.log("");
        return;
    }
});

/**
 * Create an OAuth2 client with the given credentials, and then execute the
 * given callback function.
 *
 * @param {Object} credentials The authorization client credentials.
 * @param {function} callback The callback to call with the authorized client.
 */
function authorize(credentials, callback) {
  var clientSecret = credentials.installed.client_secret;
  var clientId = credentials.installed.client_id;
  var redirectUrl = credentials.installed.redirect_uris[0];
  var auth = new googleAuth();
  var oauth2Client = new auth.OAuth2(clientId, clientSecret, redirectUrl);

  // Check if we have previously stored a token.
  fs.readFile(TOKEN_PATH, function(err, token) {
    if (err) {
      getNewToken(oauth2Client, callback);
    } else {
      oauth2Client.credentials = JSON.parse(token);
      callback(oauth2Client);
    }
  });
}

/**
 * Get and store new token after prompting for user authorization, and then
 * execute the given callback with the authorized OAuth2 client.
 *
 * @param {google.auth.OAuth2} oauth2Client The OAuth2 client to get token for.
 * @param {getEventsCallback} callback The callback to call with the authorized
 *     client.
 */
function getNewToken(oauth2Client, callback) {
  var authUrl = oauth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: SCOPES
  });
  console.log('Authorize this app by visiting this url: ', authUrl);
  var rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });
  rl.question('Enter the code from that page here: ', function(code) {
    rl.close();
    oauth2Client.getToken(code, function(err, token) {
      if (err) {
        console.log('Error while trying to retrieve access token', err);
        return;
      }
      oauth2Client.credentials = token;
      storeToken(token);
      callback(oauth2Client);
    });
  });
}

/**
 * Store token to disk be used in later program executions.
 *
 * @param {Object} token The token to store to disk.
 */
function storeToken(token) {
  try {
    fs.mkdirSync(TOKEN_DIR);
  } catch (err) {
    if (err.code != 'EEXIST') {
      throw err;
    }
  }
  fs.writeFile(TOKEN_PATH, JSON.stringify(token));
  console.log('Token stored to ' + TOKEN_PATH);
}


function date_format(d1, nowa){
    if(nowa.getUTCDate() == d1.getUTCDate()){
        return moment(d1).format("h:mm");
    }
    return "".concat("+",
                     Math.floor(d1.getTime() / 86400000) - Math.floor(nowa.getTime() / 86400000)
                     ,"d ", moment(d1).format("H:mm"));
}

function duration(d1, d2){
    var time_in_mins = Math.floor((d2.getTime() - d1.getTime()) / 1000 / 60);
    if(time_in_mins < 90){
        return "(" + time_in_mins.toString() + "m)";
    }
    return "(" + Math.floor(time_in_mins / 60).toString() + "h" + (time_in_mins % 60).toString() + "m)";
}

/**
 * Lists the next 10 events on the user's primary calendar.
 *
 * @param {google.auth.OAuth2} auth An authorized OAuth2 client.
 */
function listEvents(auth) {
    var calendar = google.calendar('v3');
    today = new Date();
    today.setHours(0, 0, 0, 0);
  calendar.events.list({
    auth: auth,
    calendarId: 'primary',
      timeMin: today.toISOString(),
    maxResults: 20,
    singleEvents: true,
    orderBy: 'startTime'
  }, function(err, response) {
      if (err) {
          console.log('The API returned an error: ' + err);
          return;
      }
      var events = response.items;
      if (events.length == 0) {
          console.log('No upcoming events found.');
      } else {
          var current_event = [];
          var next_event = [];
          var next_event_start = null;
          
        var nowa = new Date();
          
          for (var i = 0; i < events.length; i++) {
              var event = events[i];
              var start = event.start.dateTime || event.start.date;
              var start_date = new Date(start);
              var end = event.end.dateTime || event.end.date;
              var end_date = new Date(end);
              if (start_date < nowa && end_date > nowa){
                  current_event.push([date_format(start_date, nowa),
                                      duration(start_date, end_date), event.summary].join(" "));
              }

            if (start_date > nowa){
                if (!next_event_start || start_date.getTime() == next_event_start.getTime()){
                    next_event.push([date_format(start_date, nowa),
                                     duration(start_date, end_date), event.summary].join(" "));
                    next_event_start = start_date;
                }
            }
        }

        if(current_event.length == 0){
            console.log(" %s", current_event, next_event.join(", ") );
        } else {
            console.log(" %s |  %s", current_event, next_event.join(", "));
        }

        if (next_event_start.getTime() - (new Date()).getTime() < 600000){
            process.exit(33);
    }
    }
  });
}
