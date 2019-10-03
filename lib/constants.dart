/// ENDPOINTS

const DEV_URL = 'https://api.hackru.org/dev';
const PROD_URL = 'https://api.hackru.org/prod';
const MISC_URL = 'http://hackru-misc.s3-website-us-west-2.amazonaws.com';

const WAIVER_URL = "https://hackru.org/resources/waiver.pdf";
const DEVPOST_URL = "http://hackru-s19.devpost.com";
const SLACKPAGE_URL = "http://bit.ly/hackru-s19";
const HELPQ_URL = "https://hackru-helpq.herokuapp.com";
const FOOD_MENU_URL = "https://s3-us-west-2.amazonaws.com/hackru-misc/menu.pdf";

const REPOSITORY_URL = "https://github.com/HackRU/OneAppFlutter";
const HACKRU_PAGE_URL = "https://hackru.org/";
const FACEBOOK_PAGE_URL = "https://www.facebook.com/theHackRU/";
const INSTAGRAM_PAGE_URL = "https://www.instagram.com/thehackru/";

/// STRINGS & OTHER CONSTANTS
const ABOUT_HACKRU =
    'The HackRU App is an open source effort made possible by the HackRU Research & Development Team. Hackers would be able to get announcements, a QR code for checking, food, etc. as well as see the schedule and map for the hackathon. Organizers would have an access to the QR Scanner.';

/// Old API endpoints
//  const DEV_URL = 'https://7c5l6v7ip3.execute-api.us-west-2.amazonaws.com/lcs-test';
//  const PROD_URL = 'https://m7cwj1fy7c.execute-api.us-west-2.amazonaws.com/mlhtest';

/// LCS API Calls

/**
 * Default login url
 * @params
 * {
 *     "headers": {
 *         "Content-Type": "application/json"
 *     },
 *     "body": {
 *         "email": "<EMAIL>",
 *         "password": "<PASSWORD>"
 *     }
 * }
 * @returns
 * {
 *     "statusCode": 200,
 *     "isBase64Encoded": false,
 *     "headers": {
 *         "Content-Type": "application/json",
 *         "Access-Control-Allow-Origin": [
 *             "*"
 *         ],
 *         "Access-Control-Allow-Headers": [
 *             "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token"
 *         ],
 *         "Access-Control-Allow-Credentials": [
 *             true
 *         ]
 *     },
 *     "body": "{\"auth\": {\"token\": \"a6390c07-3bef-4062-ae69-3a0e983af124\", \"valid_until\": \"2018-12-29T18:41:17.225329\", \"email\": \"TESTING123\"}}"
 * }
 */

/// Note: BASE = DEV_URL OR PROD_URL

/// Login
//  BASE + "/authorize"

/// Default SignUp url, expects
//  BASE + "/create"

/// Default user url, expects
//  BASE + "/read"

/// Default user update information, expects
//  BASE + "/update"

/// Day of event schedule
//  BASE + "/dayof-events"

/// Day of slack announcements
//  BASE + "/dayof-slack"

/// Get QR codes
//  BASE + "/qr",       for given email address get generated qr code
//  BASE + "/resume",   for scanned qr code get hacker's resume
