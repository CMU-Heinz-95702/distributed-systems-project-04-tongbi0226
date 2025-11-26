# Project 4 Task 2 – Inspirational Quotes Mobile-to-Cloud App
**by Tong Bi (Andrew ID: tongbi)**

---

## Description:

My application allows users to search for inspirational quotes by keyword. The mobile app sends the user's keyword to a web service, which fetches a quote from the ZenQuotes API, logs the request to MongoDB Atlas, and returns the quote to display on the mobile device.

The system supports 28 specific keywords (anxiety, change, choice, confidence, courage, death, dreams, excellence, failure, fairness, fear, forgiveness, freedom, future, happiness, inspiration, kindness, leadership, life, living, love, pain, past, success, time, today, truth, work) that are validated against ZenQuotes' supported topics. For unsupported keywords, the system returns a random inspirational quote with an apologetic message.

---

## Here is how my application meets the task requirements:

### 1. Implement a native Android application

**The name of my native Android application project in Android Studio is:** `QuoteAndroidApp`

**a. Has at least three different kinds of views in your Layout (TextView, EditText, ImageView, etc.)**

My application uses **7 different types of views** in the LinearLayout:
1. **EditText** - `keywordInput` for user to enter search keyword
2. **Button** - `searchButton` to trigger quote search
3. **TextView** - `quoteText` to display the quote content
4. **TextView** - `authorText` to display the quote author
5. **TextView** - `noteText` to show keyword validation messages
6. **ImageView** - `quoteIcon` to display a decorative quote icon
7. **ProgressBar** - `loadingBar` to show loading state during API calls

See `activity_main.xml` for details of how they are incorporated into the LinearLayout.

---

**Here is a screenshot of the layout before the quote has been fetched:**

![Initial Screen](docs/android-screenshot-1.png)
*Figure 1: Initial app screen with welcome message*

---

**b. Requires input from the user**

Here is a screenshot of the user searching for a quote with the keyword "success":

![User Input - Success](docs/android-screenshot-2.png)
*Figure 2: User entered "success" as keyword*

---

**c. Makes an HTTP request (using an appropriate HTTP method) to your web service**

My application does an HTTP GET request in `MainActivity.java`. The HTTP request is:

```
https://fictional-meme-4jvv999q4jwwhjw6q-8080.app.github.dev/getQuote?keyword=success
```

The `fetchQuote()` method makes this request to my web application, parses the returned JSON response to extract the quote, author, and optional note, then displays them on the mobile interface.

---

**d. Receives and parses an XML or JSON formatted reply from the web service**

An example of the JSON reply is:

```json
{
  "success": true,
  "quote": "We need never be ashamed of our tears.",
  "author": "Charles Dickens",
  "note": "Inspirational quote about: success",
  "keyword": "success"
}
```

The JSON response is parsed using Gson library in `MainActivity.java`:

```java
JsonObject jsonResponse = JsonParser.parseString(response.toString())
    .getAsJsonObject();
boolean success = jsonResponse.get("success").getAsBoolean();
String quote = jsonResponse.get("quote").getAsString();
String author = jsonResponse.get("author").getAsString();
String note = jsonResponse.has("note") ? 
    jsonResponse.get("note").getAsString() : "";
```

---

**e. Displays new information to the user**

Here is the screenshot after the quote has been returned:

![Quote Display - Success](docs/android-screenshot-2.png)
*Figure 3: Quote about "success" displayed with author and note*

The quote is displayed in italic text with quotation marks, the author is shown with an em dash prefix, and the note appears in an orange-bordered box to inform the user about the keyword validation.

---

**f. Is repeatable (i.e. the user can repeatedly reuse the application without restarting it.)**

The user can type in another search term and hit the "GET QUOTE" button. Here is an example of having searched for "confidence":

![Quote Display - Confidence](docs/android-screenshot-3.png)
*Figure 4: Quote about "confidence" displayed after second search*

The application maintains state across multiple searches without requiring restart. The ExecutorService handles background network requests efficiently for repeated use.

---

## 2. Implement a web application, deployed to GitHub Codespaces

**The URL of my web service deployed to GitHub Codespaces is:**

```
https://fictional-meme-4jvv999q4jwwhjw6q-8080.app.github.dev/
```

**The project directory name is:** `QuoteWebService`---

**a. Using an HttpServlet to implement a simple (can be a single path) API**

In my web app project:

- **Model:** `QuoteService.java` - Handles ZenQuotes API interaction and keyword validation
- **View:** `dashboard.jsp` - Displays analytics and logs (separate from API response)
- **Controller:** `QuoteServlet.java` - Main REST API servlet

The servlet mapping in `web.xml`:

```xml
<servlet>
    <servlet-name>QuoteServlet</servlet-name>
    <servlet-class>edu.cmu.andrew.tongbi.QuoteServlet</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>QuoteServlet</servlet-name>
    <url-pattern>/getQuote</url-pattern>
</servlet-mapping>
```

---

**b. Receives an HTTP request from the native Android application**

`QuoteServlet.java` receives the HTTP GET request with the parameter "keyword". It passes this keyword to the business logic layer.

```java
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String keyword = request.getParameter("keyword");
    userAgent = request.getHeader("User-Agent");
    
    // Sanitize input to prevent injection attacks
    keyword = sanitizeInput(keyword);
    
    // Fetch quote from ZenQuotes API
    JsonObject quoteObj = QuoteService.fetchQuoteByKeyword(keyword);
    // ... process and return response
}
```

---

**c. Executes business logic appropriate to your application**

`QuoteService.java` performs the following business logic:

1. **Keyword Validation:** Checks if the user's keyword is in the list of 28 supported keywords
2. **API Request:** Makes an HTTP GET request to ZenQuotes API: `https://zenquotes.io/api/random`
3. **Response Processing:** Parses the JSON response and extracts the quote and author
4. **Smart Messaging:** Returns appropriate notes based on keyword validation
5. **Rate Limiting Protection:** Only calls the API once per request to avoid the 5 requests/30 seconds limit

---

**d. Replies to the Android application with an XML or JSON formatted response**

Response JSON format:

```json
{
  "success": true,
  "quote": "Sometimes, the only way to evolve is to open ourselves fully.",
  "author": "Kamal Ravikant",
  "note": "Inspirational quote about: confidence",
  "keyword": "confidence"
}
```

---

## To document the rest of the requirements:

### 3. Handle error conditions

The application handles multiple error conditions:

**Android App Error Handling:**
- Network connection failures with user-friendly error messages
- Invalid server responses with detailed error information
- Timeout handling (10 second timeout for both connect and read operations)
- JSON parsing errors caught with try-catch blocks
- All errors displayed to user via TextView with Toast notifications

**Web Service Error Handling:**
- Input validation and sanitization to prevent injection attacks
- ZenQuotes API failures caught and logged
- Database connection errors handled gracefully
- HTTP 500 returned for server errors with JSON error response
- All exceptions logged to console for debugging

Example error response:

```json
{
  "success": false,
  "error": "Failed to fetch quote: API returned error code: 429",
  "keyword": "test"
}
```

---

### 4. Log useful information

The web service logs **8 pieces of information** for each request (exceeding the required 6):

1. **timestamp** - Date and time of the request
2. **userKeyword** - The search keyword provided by the user
3. **userAgent** - Device information from the User-Agent header
4. **apiRequestTime** - Timestamp when ZenQuotes API call started
5. **apiResponseTime** - Timestamp when ZenQuotes API call completed
6. **apiLatency** - Calculated latency in milliseconds
7. **quoteReturned** - The actual quote text returned to the user
8. **quoteAuthor** - The author of the quote
9. **apiSuccess** - Boolean indicating whether the API call succeeded

**Rationale:** These fields enable comprehensive analytics including performance monitoring (latency), user behavior analysis (keywords), error tracking (success rate), and content auditing (quotes served).

---

### 5. Store the log information in a database

**MongoDB Atlas Connection String:**

```
mongodb+srv://tongbi:Bt115226@cluster0.ogbhamt.mongodb.net/?appName=Cluster0
```

- **Database Name:** `quoteapp`
- **Collection Name:** `logs`
- **Cluster Configuration:** MongoDB Atlas with 3 shards for high availability

Each log entry is stored as a BSON document with the 8 fields mentioned above.

---

### 6. Display operations analytics and full logs on a web-based dashboard

**Dashboard URL:** `https://fictional-meme-4jvv999q4jwwhjw6q-8080.app.github.dev/dashboard`

The dashboard provides **5 analytics** (exceeding the required 3) plus a complete formatted log table:

**Analytics Displayed:**

1. **Total Requests** - Total number of API calls made
2. **Average API Latency** - Mean response time from ZenQuotes API in milliseconds
3. **API Success Rate** - Percentage of successful API calls
4. **Top 5 Keywords** - Most frequently searched keywords
5. **Top 5 Authors** - Most frequently returned quote authors

**Formatted Logs Table:**

The dashboard displays all logs in an HTML table with the following columns:
- Timestamp (formatted as readable date/time)
- User Keyword
- Quote
- Author
- API Latency (ms)
- Status (Success/Failed with color coding)
- User Agent

**Here are screenshots of the dashboard:**

![Dashboard Analytics](docs/dashboard-screenshot-1.png)
*Figure 5: Dashboard analytics showing total requests, average latency, and success rate*

![Dashboard Top Keywords and Authors](docs/dashboard-screenshot-2.png)
*Figure 6: Top 5 keywords and top 5 authors statistics*

![Dashboard Request Logs](docs/dashboard-screenshot-3.png)
*Figure 7: Detailed request logs table with timestamps, keywords, quotes, and latency*

The dashboard is implemented using:
- **DashboardServlet.java** - Controller that retrieves analytics from MongoDB
- **dashboard.jsp** - View that renders the HTML table and analytics cards
- **CSS styling** - Color-coded cards for different metrics, responsive table design

---

## Technologies Used:

- **Android:** Java, Android SDK 34 (min SDK 24), Gson 2.10.1, Material Design, AndroidX
- **Web Service:** Java 17, Apache Tomcat 9.0, Servlet API 4.0.1, Maven
- **Database:** MongoDB Atlas (Cloud) with 3 shards
- **Third-Party API:** ZenQuotes API (https://zenquotes.io/api/random)
- **Deployment:** GitHub Codespaces with Docker containerization

---

## Conclusion:

This mobile-to-cloud application successfully demonstrates:
- ✅ Native Android development with 7+ view types
- ✅ RESTful web service with proper MVC architecture
- ✅ Third-party API integration (ZenQuotes)
- ✅ Cloud database storage (MongoDB Atlas with 3 shards)
- ✅ Comprehensive logging (8 data points)
- ✅ Rich analytics dashboard (5 metrics + full logs)
- ✅ Error handling and input validation
- ✅ Deployment to GitHub Codespaces
- ✅ Smart keyword validation with 28 supported topics

The application provides a smooth user experience with inspirational quotes while maintaining robust backend logging and analytics capabilities for monitoring and improvement.

---

**Author:** Tong Bi  
**Andrew ID:** tongbi  
**Course:** 95-702 Distributed Systems  
**Project:** Project 4 Task 2  
**Date:** November 26, 2025
