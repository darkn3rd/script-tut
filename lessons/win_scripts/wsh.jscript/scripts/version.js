var engine = ScriptEngine();
var major  = ScriptEngineMajorVersion();
var minor  = ScriptEngineMinorVersion();
var build  = ScriptEngineBuildVersion();

WScript.Echo(engine + " Version " + major + "." + minor + "." + build);
