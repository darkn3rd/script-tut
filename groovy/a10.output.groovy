#!/usr/bin/env groovy
/* output message to standard error
 *  Note: Test by redirecting stdout to nowhere; Examples:
 *  Unix/Linux: groovy script > /dev/null
 *  Windows:    groovy script > NUL 
 */   
System.err.println  "This is a test of the emergency script system." + \
                    "  This is only a test."