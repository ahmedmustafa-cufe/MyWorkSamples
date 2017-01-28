/*
	'Search8' Search Engine - code sample
	(using servlets)
*/

// Import required java libraries
import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import java.util.*;

// Extend HttpServlet class
public class Search8Class extends HttpServlet 
{ 
  public void init() throws ServletException
  {
	  // nothing
  }

  public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
  {
	  // 1- read variables from Request
	  String q = request.getParameter("q");
	  String ph = request.getParameter("ph");
	  
	  boolean phrase = false;
	  
	  if(ph == "on")
		  phrase = true;
	  
	  // 2- send data to search engine (q_process) & retrieve results
	  query_process qp = new query_process();
	  Vector<displayLink> results = new Vector<displayLink> ();
	  results = qp.q_process(q, phrase);
	  int number_of_results = results.size();
	  
	  // 3- show data on the html page	  
	  
	  String html = "<!doctype html>"
		+	"<html>"
			  
			+	"<head>"
				+	"<title> Search8 </title>"
				+	"<meta charset=\"utf-8\">"
		        +	"<link rel=\"stylesheet\" href=\"css/reset.css\"/>"
				+	"<link rel=\"stylesheet\" href=\"css/results_style.css\">"
		        +	"<script type=\"text/javascript\" src=\"js/jquery-1.11.1.min.js\"></script>"
		        +	"<script type=\"text/javascript\" src=\"js/results-script.js\"></script>"				
			+	"</head>"
			
			+	"<body>"
				+	"<div id=\"title\">"
					+	"<h1>"
						+	"<a href=\"index.html\">"
							+	"Search<span>8</span>"
						+	"</a>"
			        +	"</h1>"
		        +	"</div>"
	  
		  		+	"<div id=\"query_show\">"
		            +	"<p>Showing results for: <span id=\"query\">" + q + "</span></p>"
	            +	"</div>"
	            
		        +	"<div id=\"all_results\">";
	  
	  //results part
	  String r_title;
	  String r_body;
	  String r_url;
	  
	  for(int i=number_of_results-1; i>=0; i--)
	  {
		  r_title = results.elementAt(i).title;
		  r_body = results.elementAt(i).body;
		  r_url = results.elementAt(i).link;
		  
				  html += "<div class=\"result "+ (number_of_results-i) +" \">"
						  
			                + "<h1 class=\"result_title\">"
				                + "<a class=\"result_title_url\" href=\""+r_url+"\">"
					                + r_title
				                + "</a>"
			                + "</h1>"
			
			                + "<h2 class=\"result_url\">"
				                + r_url
			                + "</h2>"
			
			                + "<p class=\"result_content\">"
				                + r_body
			                + "</p>"
		                
		                + "</div>";
	  }
	  
	  html += 		"</div>";
	  
	  //pages
	  html += 		"<div class=\"pages \" id=\""+number_of_results+" \">"
			+		"</div>";
	  
	  html +=	"</body>"
		+	"</html>";
	  
	  
	  // 4- send response to user	  
      response.setContentType("text/html");
      PrintWriter out = response.getWriter();
      out.println(html);
  }
  
  public void destroy()
  {
      // nothing
  }
}