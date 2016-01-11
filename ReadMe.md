#Delphi7 Batch Build Scripts
This is a base to create your own build scripts for the *Delphi 7* project groups.
Typical example is an Application and its' Test. The task here is to build 
each project and check the Test result.

This scripts allow you to run build with CI servers, 
e.g. [Jenkins](https://jenkins-ci.org/). Output goes to a console stdout 
so you can check build details in the `Console Output`. 


## Pre-conditions
1. Create a system environment variable `Delphi7Bin` with path to `Delphi 7/Bin`. 
Usually the `Delphi 7/Bin` is located in `c:\Program Files\Borland\Delphi7\Bin\`
or `c:\Program Files(x86)\Borland\Delphi7\Bin\`
2. Install [madExcept](http://madshi.net/madCollection.exe) exception handler. 
It's requred to patch the compiled exe after build to allow madExcept debug 
the application during execution.
*Note:* You can remove madExcept patching by deleting `:madExceptPatchBinary` block 
and madExcept paths from `INCLUDE_DIRS` in `BuildMyApp.bat` .

##Usage
* To build all targets exec `BuildAll.bat`
* To build one project run relevant batch file, e.g. `BuildMyApp.bat`, 
`TestMyApp.bat`.
* To add new build target:
1. Create a copy of `BuildMyApp.bat`. 
2. Rename it as you need.
3. Add created batch filename to the buildTargets variable in BuildAll.bat   
4. Try build.
