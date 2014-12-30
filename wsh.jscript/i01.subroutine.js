// Add method to Date class
Date.prototype.getMonthName = function(lang) {
   // default to 'en' if no option
   lang = lang && (lang in Date.locale) ? lang : 'en'; 
   // reference months w. specified lang
   return Date.locale[lang].months[this.getMonth()];   
};

// Add property to Date Class
Date.locale = {
    en: {
       months: ['January', 'February', 'March', 'April', 
                'May', 'June', 'July', 'August', 'September', 
                'October', 'November', 'December']
    }
};


// create subroutine
function show_date() 
{
  var today = new Date();
  B = today.getMonthName();   // Call newly added property
  d = today.getDate();
  Y = today.getFullYear();

  WScript.Echo("Today is " + B + " " + d + ", " + Y + ".");  // output result
}

// call the subroutine 
show_date();
