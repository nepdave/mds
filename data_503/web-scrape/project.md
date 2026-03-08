Assignment 7: Scraping the Top Vinyl Releases of the 2010s
Overview
In this assignment you will use the Web Scraper Chrome/Edge/Firefox extension to build a sitemap that scrapes the most collected releases on Discogs Links to an external site.. You will practice creating element container selectors, text selectors, and link selectors that navigate to detail pages to extract additional data.

Objectives
Build a multi-level Web Scraper sitemap from scratch
Use an Element selector as a container for repeating items
Use a Link selector to follow album links to detail pages
Extract text data from both listing pages and detail pages
Export scraped data as a CSV file
Prerequisites
Webscraper Extension on a supported browser:  Chrome Links to an external site., Edge Links to an external site., Firefox Links to an external site.
Access the DevTools
Ctrl+Shift+I on Windows/Linux
Cmd+Opt+I on macOS
Instructions
Step 1: Open the Search Page
Navigate to the following URL in your browser. This shows releases sorted by the number of people who have them in their collection (most collected first):

https://www.discogs.com/search?sort=have%2Cdesc&type=release&page=1
You should see a grid or list of releases with album artwork, album names, and artist names. Verify this before proceeding.



Step 2: Create a New Sitemap
Open Chrome DevTools (F12 or Cmd+Opt+I) and click the Web Scraper tab.
Click Create new sitemap → Create Sitemap.
Set the sitemap name to: discogs_releases
Set the start URL to:
https://www.discogs.com/search?sort=have%2Cdesc&type=release&page=[1-4]
The [1-4] notation tells Web Scraper to generate four URLs (page 1, page 2, page 3, page 4), effectively scraping four pages of results (~100 releases total).

Click Create Sitemap.
Demo of Step 2:


Step 3: Create the Element Container Selector
Each release on the search results page is displayed inside its own card or row. We need a container selector that captures each individual release as a repeating element.

In your sitemap, click Add new selector.
Set the selector ID to: element
Set the type to: Element (scroll)
The parent selector should be: _root
Click Select and click on one of the release cards in the search results. You want to select the container <div> that wraps a single release (it should have role="listitem").
The CSS selector should be: div[role='listitem']
Check the Multiple checkbox — this tells Web Scraper there are many of these on the page.
Check the Scroll down to load more elements checkbox, since results may lazy-load.
Use Element preview to confirm that all release cards on the page are highlighted (you should see ~25 highlighted items).
Click Save selector.
Demo of Step 3:



Step 4: Create the Album Name Selector
Now we extract the album title from inside each element container.

Click into the element selector (navigate into it), then click Add new selector.
Set the selector ID to: album_name
Set the type to: Text
The parent selector should be: element
Click Select and click on an album title in one of the release cards. The album name is typically a link with the class line-clamp-2.
The CSS selector should be: a.line-clamp-2
Leave Multiple unchecked (one album name per card).
Use Data preview to verify you see real album names.
Click Save selector.
Demo of Step 4:



Step 5: Create the Artist Name Selector
Still inside the element selector, click Add new selector.
Set the selector ID to: artist_name
Set the type to: Text
The parent selector should be: element
Click Select and click on an artist name in one of the release cards. The artist name is a link with the class block.
The CSS selector should be: a.block
Leave Multiple unchecked.
Use Data preview to verify you see real artist names.
Click Save selector.
Demo of Step 5:



Step 6: Create the Album Link Selector
This selector follows a link from the search results page into each album's detail page. Selectors that are children of this link selector will extract data from the detail page.

Still inside the element selector, click Add new selector.
Set the selector ID to: album_link
Set the type to: Link
The parent selector should be: element
Click Select and click on the main clickable area of a release card (the album image or the card wrapper link). Look for a link with the class group.
The CSS selector should be: a.group
Set the link type to: linkFromHref
Check the Multiple checkbox.
Click Save selector.
Demo of Step 6:



Step 7: Create the Average Rating Selector (Detail Page)
Now we need to extract data from the album detail page. To do this, we create child selectors under album_link.

Click into the album_link selector (navigate into it), then click Add new selector.
Set the selector ID to: avg_rating
Set the type to: Text
The parent selector should be: album_link
To build this selector, you need to manually visit a release detail page. Click on any album in the search results to open its detail page.
On the detail page, find the Rating section. There will be a numerical average rating (e.g., "4.18").
The CSS selector for the average rating is: .section_Odw8o div div ul:nth-of-type(1) span:nth-of-type(2)
Leave Multiple unchecked.
Use Element preview on the detail page to confirm the correct value is highlighted.
Click Save selector.
Demo of Step 7:



Step 8: Create the Number of Ratings Selector (Detail Page)
Still inside the album_link selector, click Add new selector.
Set the selector ID to: num_ratings
Set the type to: Text
The parent selector should be: album_link
On the detail page, find the release statistics section. Look for the total number of ratings (e.g., "1,247 Ratings").
The CSS selector is: #release-stats li:nth-of-type(4) a
Leave Multiple unchecked.
Use Element preview on the detail page to confirm the correct value is highlighted.
Click Save selector.
Selector Tree Summary
Your final selector tree should look like this:

_root
 └── element          (Element, Multiple, Scroll)    CSS: div[role='listitem']
      ├── album_name  (Text)                         CSS: a.line-clamp-2
      ├── artist_name (Text)                         CSS: a.block
      └── album_link  (Link, Multiple, linkFromHref) CSS: a.group
           ├── avg_rating  (Text)                    CSS: .section_Odw8o div div ul:nth-of-type(1) span:nth-of-type(2)
           └── num_ratings (Text)                    CSS: #release-stats li:nth-of-type(4) a
Demo of Step 8:


Step 9: Run the Scrape
Go back to the sitemap root and click Scrape.
Set Request interval: 2000 ms
Set Page load delay: 2000 ms
Click Start scraping.
A new browser window will open. Do not close it — let the scraper work through both pages and all the detail pages.
Wait for the scrape to finish. This may take several minutes since it visits each album's detail page individually.
Demo of Step 9:



 

Step 10: Export to CSV
Once the scrape completes, click the Sitemap menu and select Browse to preview the data.
Verify that you see columns for album_name, artist_name, album_link, avg_rating, and num_ratings.
Click Sitemap menu and then Export data, and select .CSV.
Save the file as discogs_releases.csv.
Demo of Step 10:



 

Deliverable
Upload your exported CSV file containing approximately 100 records (four pages of results). Each row should include:

Column	Description	Example
album_name	Album title	Random Access Memories
artist_name	Artist or band name	Daft Punk
album_link	URL to the album detail page	https://www.discogs.com/release/...
avg_rating	Average user rating	4.18
num_ratings	Total number of ratings	1,247
Grading
Criteria	Points
CSV uploaded with ~50 rows	40
Contains album_name and artist_name columns with valid data	20
Contains avg_rating and num_ratings from detail pages	30
Data is reasonably clean (no empty/broken rows)	10
Total	100
Tips
Start with just page [1-1] while testing your selectors. Switch to [1-2] for the final scrape.
If a CSS selector does not highlight the right element, try using the P (parent) or C (child) keys while the Select tool is active.
Discogs may rate-limit you. Keep the request interval at 2000 ms or higher.
If your scrape returns blank avg_rating or num_ratings, the detail page CSS selectors may need adjustment. Manually visit a detail page and use Element Preview to troubleshoot.
The element selector with "Scroll down" enabled helps capture all items if the page lazy-loads content.
