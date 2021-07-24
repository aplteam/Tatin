:Namespace Tatin
⍝ The ]Tatin user commands for managing packages.\\
⍝ * 0.29.1 - 2021-06-24
⍝   * `Ping` was buggy
⍝ * 0.29.0 - 2021-06-14
⍝   * New user command `Ping` added
⍝ * 0.28.2 - 2021-05-31
⍝   * Wording changed in CheckForLaterVersion's help
⍝ * 0.28.1 - 2021-05-24
⍝   * User command now prints a reasonable text message to the session in case of success rather than am HTTP code
⍝ * 0.28.0 - 2021-05-23
⍝   * The ReInstallDependencies command got an option -dry
⍝   * Help for user command s polished
⍝   * Bug fix: VALUE RROR in ReinstallDependencies due to a typo
⍝ * 0.27.0 - 2021-04-25
⍝   * `ListVersion` extended
⍝ * 0.26.0 - 2021-04-19
⍝   * Check added to `InstallPackage` regarding "installFolder"
⍝ * 0.25.0 - 2021-04-07
⍝   * ]ReinstallDependencies ikmplemented
⍝   * -raw added to `CheckForLaterVersion`
⍝ * 0.23.0 - 2021-04-02
⍝   * ]LoadDependencies now has an overwrite flag
⍝ * 0.22.0 - 2021-04-01
⍝   * ]GetDeletePolicy polished and help added
⍝ * 0.21.0 - 2021-03-24
⍝   * User command "DeletePackage" added
⍝   * User command "GetDeletePolicy" added
⍝ * 0.20.0 - 2021-03-20
⍝   * `Pack` polished
⍝   * Bug fixes:
⍝     * `api` was mishandled when editing a JSON package config file.
⍝ * 0.19.0 - 2021-03-16
⍝   * User command `CheckForBetterVersion` renamed to `CheckForLaterVersion`
⍝   * Couple of minor changes
⍝ * 0.18.1 - 2021-03-10
⍝   * Bug fix for publishing a package
⍝ * 0.18.0 - 2021-03-01
⍝   * PackageConfig now looks into the current directory if no argument was specified
⍝ * 0.17.2 - 2021-02-17
⍝   * Minor improvements in user command help
⍝ * 0.17.1 - 2021-02-18
⍝   * Some changes to the ]TATIN.PackageConfig command
⍝   * Documentation polished
⍝ * 0.17.0 - 2021-02-10
⍝   * User command ]TATIN.DeletePackage added
⍝   * User command ]TATIN.Documentation added
⍝   * Flag -edit added to ]TATIN.UserSettings
⍝   * Bug fix: ]TATIN.UserSettings accepted flags but ignored them
⍝ * 0.16.0 - 2021-02-05
⍝   * ]TATIN.Version enhanced
⍝ * 0.15.0 - 2021-02-01
⍝   * `Publish` now accepts a folder that contains a Tatin package
⍝   * Help for ListRegistries polished
⍝ * 0.14.0 - 2021-01-22
⍝   * User commands ]TATIN.Init and ]TATIN.CheckForBetterVersion added.
⍝ * 0.13.2 - 2021-01-19
⍝   * `UnInstall` was visible when it shouldn't have been
⍝ * 0.13.1 - 2021-01-10
⍝   * LoadPackage's help page improved.
⍝ * 0.13.0 - 2021-01-02
⍝   * Some minor improvements
⍝ * 0.12.0 - 2020-12-15
⍝   * New option -noaggr aded to ListPackages
⍝ * 0.11.0 - 2020-12-09
⍝   * `ListPackages` now allows call without an argument. A list of registries is presented then for user selection.
⍝ * 0.10.1 - 2020-11-06
⍝   * Typos in help fixed
⍝   * Help page for `ListVersions` added
⍝ * 0.10.0 - 2020-08-28
⍝   * Method `UninstallPackage` added
⍝ * 0.9.0 - 2020-08-20
⍝   * ListRegistry now accepts a flag -all
⍝ * 0.8.2 - 2020-08-18
⍝   * `ListPackages` throws an error in case the -tags keyword was set but it is not an HTTP request
⍝ * 0.8.1 - 2020-08-15
⍝   * ]tatin.version fixed.
⍝ * 0.8.0 - 2020-08-15
⍝   * ]tatin.UserSettings simplified.
⍝ * 0.7.0 - 2020-08-09
⍝   * ListPackages now honours the -group and the -tags options
⍝ * 0.6.2 - 2020-08-04
⍝   * `UserSettings` replaces API-keys by stars when printing to the session
⍝   * Internal change: "TC" is now "TC" (Tatin Client)
⍝ * 0.6.1 - 2020-07-28
⍝   * Shows only under 18.0 and better now.
⍝ * 0.6.0 - 2020-07-19

    ⎕IO←1 ⋄ ⎕ML←1

    NM←'tatin'
    RS←'#._tatin' ⍝ target root space for packages
    SupportedExtensions←'.aplc' '.apln' '.apli' '.aplf' '.aplo' '.apla' '.charlist' '.charmat' '.charstring' '.dyalog'
    RegKey←'HKCU\Software\Tatin\ConfigPath'

    ∇ r←List;c
      r←⍬
     
      :If IfAtLeastVersion 18
   ⍝ Name, group, short description and parsing rules
     
          c←⎕NS ⍬
          c.Name←'LoadTatin'
          c.Desc←'Loads the Tatin client into ⎕SE, resulting in ⎕SE.Tatin, and initializes it'
          c.Parse←'1s -force'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListRegistries'
          c.Desc←'Lists all registries defined in the user settings'
          c.Parse←'0 -raw -all'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListPackages'
          c.Desc←'Lists all packages in the Registry specified in the argument'
          c.Parse←'1s -raw -group= -tags= -noaggr'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'LoadPackage'
          c.Desc←'Load the package specified in the argument and all dependencies into the WS or ⎕SE'
          c.Parse←'2 -nobetas'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListVersions'
          c.Desc←'Lists all versions of the specified package'
          c.Parse←'1 -date'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'InstallPackage'
          c.Desc←'Install a package and all its dependencies into a given folder'
          c.Parse←'2 -nobetas -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'LoadDependencies'
          c.Desc←'Takes a folder (⍵[1]) with installed packages and loads all of them into ⍵[2].'
          c.Parse←'2 -overwrite'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'UserSettings'
          c.Desc←'The user settings and the fully qualified filenanme are printed to ⎕SE as JSON'
          c.Parse←'0 -edit -apikey'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'PackageConfig'
          c.Desc←'Retrieve (HTTP) or create and/or edit a package config file for a specific package'
          c.Parse←'1s -delete -edit -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'PackageDependencies'
          c.Desc←'Create and/or edit a package dependency file for a specific folder'
          c.Parse←'1 -delete -edit -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Pack'
          c.Desc←'Packs (zips) all required files found in ⍵[1] into the folder ⍵[2]'
          c.Parse←'2s'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'PublishPackage'
          c.Desc←'Publish a package (package folder or ZIP file) to a particular Registry'
          c.Parse←'2 -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Version'
          c.Desc←'Prints name, version number and version date of the client to the session'
          c.Parse←'1s'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListTags'
          c.Desc←'Lists all tags used in all packages'
          c.Parse←'1s -tags='
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Init'
          c.Desc←'(Re)-establish the user settings'
          c.Parse←'1s'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'CheckForLaterVersion'
          c.Desc←'Check whether there are later versions of a package available'
          c.Parse←'1 -major -dependencies -raw'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Documentation'
          c.Desc←'Loads the documentation center into the default browser'
          c.Parse←''
          r,←c
     
          c←⎕NS ⍬
          c.Name←'DeletePackage'
          c.Desc←'Delete a package from a Tatin Registry'
          c.Parse←'1'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'GetDeletePolicy'
          c.Desc←'Asks the server about its "Delete" policy'
          c.Parse←'1s'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'UninstallPackage'
          c.Desc←'Uninstalls a package and its dependencies'
          c.Parse←'2'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ReinstallDependencies'
          c.Desc←'Install all packages again according to the dependency file'
          c.Parse←'2s -nobetas -dry -force'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Ping'
          c.Desc←'Ping a Tatin Registry with very little overhead'
          c.Parse←'1s -all'
          r,←c
     
          r.Group←⊂NM
     
      :EndIf
     
    ∇

    ∇ {r}←Run(Cmd Input);ns;flag
      :If 0=⎕SE.⎕NC'Tatin'
      :AndIf 'loadtatin'≢⎕C Cmd
          flag←LoadTatin''
      :EndIf
      :If 'loadtatin'≡⎕C Cmd
          Input.force LoadTatin(1+(0≡Input._1)∨0=≢Input._1)⊃Input._1''
          r←''
      :Else
          TC←⎕SE._Tatin.Client
          :If 0=⎕SE._Tatin.RumbaLean.⎕NC'DRC'
              ⎕SE._Tatin.Admin.InitConga ⍬
          :EndIf
          r←((⍎Cmd)__ExecAsTatinUserCommand)Input
      :EndIf
    ∇


    ∇ r←(fns __ExecAsTatinUserCommand)arg
    ⍝ Fancy name that we can work out whether a Tatin function was called via the User Command framework.
    ⍝ That makes a difference regarding messages printed to the session.
     
      r←fns arg   ⍝ <===
     
    ⍝Done
    ∇

    ∇ {r}←{forceLoad}LoadTatin path2Config;buff;home;settings
      r←1
      forceLoad←{0<⎕NC ⍵:⍎⍵ ⋄ 0}'forceLoad'
      LoadTatin_ forceLoad
      home←⍎'Tatin'⎕SE.⎕NS''
      :If 0=≢path2Config
          path2Config←TC.FindUserSettings ⎕AN
      :EndIf
      'Create!'TC.F.CheckPath path2Config
      path2Config ⎕SE._Tatin.Admin.EstablishClientInQuadSE home
     ⍝Done
    ∇

    ∇ r←Version Arg;⎕TRAP;registries;registry;alias
      ⎕TRAP←0 'S'
      :If (,'*')≡,Arg._1
          r←⊂(⊂'{Client}'),TC.Reg.Version
          registries←1 TC.ListRegistries 0
          :For registry alias :In ↓registries[;1 2]
              :If 0≠≢'http[s]://'⎕S 0⊣registry  ⍝ Not local?
                  :Trap 0
                      r,←⊂(⊂registry),TC.GetServerVersion registry
                  :Else
                      r,←⊂registry'' '*** Could not be accessed'
                  :EndTrap
              :EndIf
          :EndFor
          r←(↑r)[;1 3 4]
      :ElseIf 0≡Arg._1
          r←TC.Reg.Version
      :Else
          r←TC.GetServerVersion Arg._1
      :EndIf
    ∇

    ∇ {r}←LoadTatin_ forceLoad;filename
      r←1
      filename←(1⊃⎕NPARTS ##.SourceFile),'Tatin/Client.dws'
      :If 0∊⊃∘⎕SE.⎕NC¨'Tatin' '_Tatin'
      :OrIf forceLoad
          ('Workspace not found: ',filename)⎕SIGNAL 98/⍨0=⎕NEXISTS filename
          ⎕SE.⎕EX¨'_Tatin' 'Tatin'
          '_Tatin'⎕SE.⎕CY filename
      :EndIf
      TC←⎕SE._Tatin.Client
    ∇

    ∇ r←ListPackages Arg;registry;parms;caption;width
      r←''
      :If 0≡registry←Arg._1
          →(⍬≡registry←SelectRegistry 0)/0
      :Else
          registry,←(~(¯1↑registry)∊'/\')/'/'
      :EndIf
      registry←EnforceSlash registry
      parms←⎕NS''
      :If 0≢Arg.group
          parms.group←Arg.group
      :EndIf
      :If 0≢Arg.tags
          parms.tags←Arg.tags
      :EndIf
      :If 0≢Arg.noaggr
          parms.aggregate←~Arg.noaggr
      :EndIf
      r←⍪parms TC.ListPackages registry
      :If 0=Arg.raw
          :If 0=≢r
              r←'No packages found'
          :Else
              r(AddHeader)←'Group & Name' '≢ major versions'
              r←⎕FMT r
              caption←' *** Packages from ',registry
              width←(2⊃⍴r)⌈≢caption
              r←(width↑caption),[1]width↑[2]r
          :EndIf
      :EndIf
    ∇

    ∇ r←LoadDependencies Arg;installFolder;f1;f2;targetSpace;saveIn;overwriteFlag
      installFolder←Arg._1
      targetSpace←Arg._2
      overwriteFlag←Arg.overwrite
      installFolder←'apl-dependencies.txt'{⍵↓⍨(-≢⍺)×⍺≡(-≢⍺)↑⍵}installFolder
      f1←TC.F.IsDir installFolder
      f2←(TC.F.IsFile installFolder)∧'.zip'≡⎕C ¯4↑installFolder
      '⍵[1] is neither a folder nor a ZIP file'Assert f1∨f2
      :If (,'#')≢,targetSpace
          '"targetSpace" is not a valid APL name'Assert ¯1≠⎕NC targetSpace
      :EndIf
      saveIn←⍎{⍵↑⍨¯1+⍵⍳'.'}targetSpace
      ({⍵↓⍨⍵⍳'.'}targetSpace)saveIn.⎕NS''
      :If 0=saveIn.⎕NC'targetSpace'
          ((1+≢saveIn)↓targetSpace)saveIn.⎕NS''
      :EndIf
      'Arg[2] must not be scripted'Assert IsScripted⍎targetSpace
      r←TC.LoadDependencies installFolder targetSpace overwriteFlag
      r←⍪r
    ∇

    ∇ r←CheckForLaterVersion Arg;path;majorFlag;question;this;dependencies;raw;b
      r←''
      path←Arg._1
      (majorFlag raw dependencies)←Arg.(major raw dependencies)
      :If majorFlag
          r←majorFlag TC.CheckForLaterVersion path dependencies
          r←↑(0<≢¨r)/r
      :Else
          r←TC.CheckForLaterVersion path dependencies
          r←↑(0<≢¨r)/r
          :If 0  ⍝TODO⍝  May be one day we support this, may be not
              :If 0<≢r
                  :If 1=≢r
                      question←'There is a later version:',⎕UCS 13
                      question,←'  ',(∊r),⎕UCS 13
                      question,←'Would you like to install this later version?'
                  :Else
                      question←'There are later versions:',⎕UCS 13
                      question,←∊'  '∘,¨r,¨⎕UCS 13
                      question,←'Would you like to install ALL these later versions?'
                      :If 1 ∆YesOrNo question
                          ∘∘∘
                      :ElseIf 1 ∆YesOrNo'Would you like to install SOME of these later versions?'
                          :For this :In r
                              ∘∘∘
                          :EndFor
                      :EndIf
                  :EndIf
              :AndIf 1 ∆YesOrNo question
                  ∘∘∘
              :EndIf
          :EndIf
      :EndIf
      :If ~raw
      :AndIf 0<≢r
          r←'Installed' 'Best' 'URL' '?'⍪' '⍪r
          r[2;]←(⌈⌿≢¨r)⍴¨'-'
          b←1≡¨r[;4]
          r[⍸b;4]←'*'
          r[2↓⍸~b;4]←⊂''
      :EndIf
    ∇

    ∇ r←ReinstallDependencies Args;installFolder;registry;refs;noBetas;deps;dry;msg;force
      r←''
      'Mandatory argument (install directory) must not be empty'Assert 0<≢installFolder←Args._1
      :If 0≡Args._2
          registry←''
      :Else
          registry←Args._2
      :EndIf
      dry←0 Args.Switch'dry'
      force←0 Args.Switch'force'
      noBetas←0 Args.Switch'nobetas'
      installFolder←'apl-dependencies.txt'{⍵↓⍨(-≢⍺)×⍺≡⎕C(-≢⍺)↑⍵}installFolder
      'Not a directory'Assert TC.F.IsDir installFolder
      'Directory does not host a file apl-dependencies.txt'Assert TC.F.IsFile installFolder,'/apl-dependencies.txt'
      deps←⊃TC.F.NGET(installFolder,'/apl-dependencies.txt')1
      'Dependency file is empty'Assert 0<≢deps
      :If dry
          r←noBetas TC.PretendReInstallDependencies installFolder registry
      :Else
          :If force
          :OrIf ∆YesOrNo'Re-install ',(⍕≢deps),' Tatin packages in ',installFolder,'?'
              r←noBetas TC.ReInstallDependencies installFolder registry
              :If ~force
                  ⎕←'*** Done'
              :EndIf
          :EndIf
      :EndIf
    ∇

    ∇ r←DeletePackage Arg;path
      path←Arg._1
      r←TC.DeletePackage path
      :If 200=⊃r
          r←'Package was successfully deleted'
      :EndIf
     ⍝Done
    ∇

    ∇ r←GetDeletePolicy Arg;uri
      uri←Arg._1
      :If 0≡Arg._1
          →(⍬≡uri←SelectRegistry 0)/0
      :EndIf
      'The "Delete" policy can only be requested from a Tatin server'Assert TC.Reg.IsHTTP uri
      r←TC.GetDeletePolicy uri
    ∇

    ∇ zipFilename←Pack Arg;filename;sourcePath;targetPath;prompt;msg
      (sourcePath targetPath)←Arg.(_1 _2)
      prompt←0
      :If 0≡sourcePath
      :OrIf (,'.')≡,sourcePath
      :OrIf 0=≢sourcePath
          sourcePath←TC.F.PWD
          prompt∨←1
      :EndIf
      :If 0≡targetPath
      :OrIf (,'.')≡,targetPath
      :OrIf 0=≢targetPath
          targetPath←sourcePath
          prompt∨←1
      :EndIf
      (sourcePath targetPath)←AddSlash¨sourcePath targetPath
      'Source path (⍵[1]) is not a directory'Assert TC.F.IsDir sourcePath
      filename←sourcePath,TC.CFG_Name
      ('Could not find a file "',TC.CFG_Name,'" in ',sourcePath)Assert TC.F.IsFile filename
      :If ~(1↑targetPath)∊'/\'
      :AndIf (1↑1↓targetPath)≠':'
          targetPath←sourcePath,targetPath
      :EndIf
      (sourcePath targetPath)←{⊃1 ⎕NPARTS ⍵,'/'}¨sourcePath targetPath
      :If prompt
          msg←'Sure that you want to pack ',sourcePath,' into '
          :If sourcePath≡targetPath
              msg,←'the same directory?'
          :Else
              msg,←targetPath,'?'
          :EndIf
      :AndIf 0=1 ∆YesOrNo msg
          :Return
      :EndIf
      :If 0=⎕NEXISTS targetPath
      :AndIf 1 ∆YesOrNo'Target directory does not exist yet; create it?'
          TC.F.MkDir targetPath
      :EndIf
      'Target path (⍵[2]) is not a directory'Assert TC.F.IsDir targetPath
      zipFilename←TC.Pack sourcePath targetPath
    ∇

    ∇ r←PublishPackage Arg;url;url_;qdmx;statusCode;list;source;msg;rc;zipFilename;firstFlag;packageID
      r←''
      (source url)←Arg.(_1 _2)
      :If (,'?')≡,url
          :If 0=≢url←SelectRegistry 1
              :Return
          :EndIf
      :EndIf
      :If ~TC.Reg.IsHTTP url
      :AndIf ~TC.Reg.IsFILE url
          url←{∧/'[]'∊⍵:⍵ ⋄ '[',⍵,']'}url
      :EndIf
      url_←TC.ReplaceRegistryAlias url
      ('"',url,'" is not a Registry')Assert 0<≢url_
     
      :If TC.F.IsDir source
          ('"',source,'" does not contain a Tatin package')Assert TC.F.IsFile source,'/',TC.CFG_Name
      :Else
          ('"',source,'" is not a ZIP file')Assert'.zip'≡⎕C ¯4↑source
      :EndIf
      firstFlag←1
     ∆Again:
      :Trap 98
          (rc msg zipFilename)←TC.PublishPackage source url
          :If 200≡rc
              r←'Package published on ',url_
          :Else
              r←msg,'; RC=',⍕rc
          :EndIf
      :Else
          qdmx←⎕DMX
          :If 'HTTP status code:'{⍺≡(≢⍺)↑⍵}qdmx.EM
              statusCode←⊃⊃(//)⎕VFI ¯3↑qdmx.EM
              :Select statusCode
              :Case 400
                  r←'Bad request'
              :Case 401
                  r←'Your are not authorized to publish at ',url_
              :Case 500
                  r←'The server ',url_,' reported an internal error'
              :Else
                  qdmx.EM ⎕SIGNAL 98
              :EndSelect
          :Else
              :If firstFlag
              :AndIf 'Server: The package has already been published'{⍺≡(≢⍺)↑⍵}qdmx.EM
              :AndIf 'Any'≡⎕SE.Tatin.GetDeletePolicy url_
                  packageID←2⊃⎕NPARTS source
              :AndIf ∆YesOrNo packageID,' already published on ',url_,'; overwrite?'
                  firstFlag←0
                  (rc msg)←⎕SE.Tatin.DeletePackage url_,packageID
                  :If 200=rc
                      →∆Again
                  :Else
                      ⎕←'Delete attempt failed with status ',(⍕rc),'; publishing therefore not possible'
                      :Return
                  :EndIf
              :EndIf
              :If ∨/'<title>'⍷qdmx.EM
                  r←GetTitleFromHtml qdmx.EM
              :ElseIf 0<≢r←qdmx.EM
                  r←qdmx.EM
              :EndIf
          :EndIf
      :EndTrap
    ∇

    ∇ r←UninstallPackage Arg;path;packageID
    ⍝ Attempt to un-installe the top-level package `packageID` from the folder `path`
      (path packageID)←Arg.(_1 _2)
      r←1⊃TC.UnInstallPackage path packageID
    ∇

    ∇ r←ListRegistries Arg;type;rawFlag
      type←rawFlag←0
      :If 0≢Arg.Switch'raw'
          rawFlag←Arg.Switch'raw'
      :EndIf
      :If 0≢Arg.Switch'all'
          type←Arg.Switch'all'
      :EndIf
      r←rawFlag TC.ListRegistries type
    ∇

    ∇ {r}←Init Arg
      :If 0≡Arg._1
          r←TC.Init''
      :Else
          r←TC.Init Arg._1
      :EndIf
    ∇

    ∇ r←ListTags Arg;parms;registry
      r←''
      parms←⎕NS''
      parms.tags←''
      :If 0≡registry←Arg._1
          →(⍬≡registry←SelectRegistry 0)/0
      :Else
          registry,←(~(¯1↑registry)∊'/\')/'/'
      :EndIf
      :If 0≢Arg.tags
      :AndIf 0<≢Arg.tags
          parms.tags←Arg.tags
      :EndIf
      r←⍪parms TC.ListTags registry
    ∇

    ∇ r←ListVersions Arg;qdmx;dateFlag
      ⎕SIGNAL 0
      dateFlag←Arg.Switch'date'
      :Trap 98
          :If dateFlag
              r←dateFlag TC.ListVersions Arg._1
          :Else
              r←⍪TC.ListVersions Arg._1
          :EndIf
      :Else
          qdmx←⎕DMX
          :If 0=≢qdmx.EM
              ('Not found: ',Arg._1)⎕SIGNAL 98
          :Else
              qdmx.EM ⎕SIGNAL 98
          :EndIf
      :EndTrap
    ∇

    ∇ r←Documentation Arg
      r←0 0⍴⍬
      {}⎕SE._Tatin.APLTreeUtils2.GoToWebPage'https://tatin.dev/v1/documentation'   ⍝TODO⍝
    ∇

    ∇ r←LoadPackage Arg;targetSpace;identifier;saveIn
      (identifier targetSpace)←Arg.(_1 _2)
      :If ~(⊂,1 ⎕C targetSpace)∊,¨'#' '⎕SE'
          '"targetSpace" is not a valid APL name'Assert ¯1≠⎕NC targetSpace
      :EndIf
      saveIn←⍎{⍵↑⍨¯1+⍵⍳'.'}targetSpace
      :If ~(⊂1 ⎕C targetSpace)∊,¨'#' '⎕SE'
      :AndIf 0=saveIn.⎕NC'targetSpace'
          '"targetSpace" does not specify a fully qualified namespace in either # or ⎕SE'Assert'.'∊targetSpace
          ((1+≢saveIn)↓targetSpace)saveIn.⎕NS''
      :EndIf
      r←Arg.nobetas TC.LoadPackage identifier targetSpace
    ∇

    ∇ r←PackageConfig Arg;path;ns;newFlag;origData;success;newData;msg;qdmx;filename;what;uri;list;flag;data
      r←⍬
      :If (,0)≡,what←Arg._1
          what←TC.F.PWD
      :ElseIf ∧/'[]'∊what
          what←TC.ReplaceRegistryAlias what
      :EndIf
      :If TC.Reg.IsHTTP what
          r←TC.ReadPackageConfigFile_ what
      :Else
          path←what
          filename←path,'/',TC.CFG_Name
          :If Arg.delete
              'File not found'Assert TC.F.IsFile filename
              msg←'Sure you want to delete "',filename,'" ?'
              :If Arg.quiet
              :OrIf 0 ∆YesOrNo msg
                  TC.F.DeleteFile filename
              :EndIf
          :Else
              :If 0=TC.F.IsDir path
                  :If Arg.quiet
                  :OrIf ∆YesOrNo'The directory does not exist yet. Would you like to create it?'
                      'Could not create the directory'Assert TC.F.MkDir path
                  :Else
                      ⎕←'Cancelled'
                      :Return ⍝ Give up
                  :EndIf
              :EndIf
              :If TC.F.IsFile filename
                  ns←TC.ReadPackageConfigFile path
                  newFlag←0
              :Else
                  :If ~Arg.quiet
                  :AndIf 0=1 ∆YesOrNo'There is no file ',TC.CFG_Name,' yet; would you like to create it?'
                      ⎕←'Cancelled'
                      :Return
                  :EndIf
                  ns←TC.InitPackageConfig ⍬
                  newFlag←1
              :EndIf
              :If Arg.edit∨newFlag
                  data←origData←TC.Reg.JSON ns
                  :Repeat
                      (success newData)←(CheckPackageConfigFile EditJson)'PackageConfigFile'data path
                      flag←1
                      :If success
                          :If 0<≢∊newData
                          :AndIf newFlag∨newData≢origData
                              ns←⎕JSON⍠('Dialect' 'JSON5')⊣newData
                              :Trap 98
                                  1 TC.WritePackageConfigFile path ns
                              :Else
                                  qdmx←⎕DMX
                                  ⎕←qdmx.EM
                                  :If 0=1 ∆YesOrNo'Would you like to try to fix the problem in the editor? (n=abandon changes)'
                                      ⎕←'Cancelled, no change'
                                  :Else
                                      flag←0
                                      data←newData
                                  :EndIf
                              :EndTrap
                          :EndIf
                      :Else
                          ⎕←'No change'
                      :EndIf
                  :Until flag
              :Else
                  r←⎕JSON⍠('Dialect' 'JSON5')('Compact' 0)⊣ns
              :EndIf
          :EndIf
      :EndIf
    ∇

    ∇ r←PackageDependencies Arg;path;newFlag;origData;success;newData;msg;temp;filename
      r←⍬
      path←Arg._1
      filename←path,'/apl-dependencies.txt'
      :If Arg.delete
          'File not found'Assert TC.F.IsFile filename
          msg←'Sure you want to delete the package dependency file in "',filename,'" ?'
          :If Arg.quiet
          :OrIf 0 ∆YesOrNo msg
              TC.F.DeleteFile filename
          :EndIf
      :ElseIf Arg.edit
          'Path does not exist'Assert TC.F.IsDir path
          temp←⎕NS'EditText'
          :If TC.F.IsFile filename
              origData←1⊃TC.F.NGET filename 1
              newFlag←0
          :Else
              origData←,⊂''
              newFlag←1
          :EndIf
          (success newData)←(CheckDependencies EditText)'PackageDependencies'origData
          :If 0<≢∊newData
          :AndIf newFlag∨newData≢origData
              (⊂newData)TC.F.NPUT filename 1
          :EndIf
      :Else
          'File not found'Assert TC.F.IsFile filename
          r←⊃TC.F.NGET filename
      :EndIf
    ∇

    ∇ r←InstallPackage Arg;identifier;installFolder
      (identifier installFolder)←Arg.(_1 _2)
      'Install folder is invalid'Assert~(⊂,1 ⎕C installFolder)∊,¨'#' '⎕SE'
      :If ~TC.F.IsDir installFolder
          :If 0=Arg.quiet
          :AndIf 1 ∆YesOrNo'Install folder <',installFolder,'> does not yet exist; create?'
              'Create!'TC.F.CheckPath installFolder
          :EndIf
      :EndIf
      r←TC.InstallPackage identifier installFolder
    ∇

    ∇ r←UserSettings Arg;origData;filename;ns;new;buff
      r←''
      filename←TC.F.NormalizePath TC.MyUserSettings.path2config
      ('User setting file "',filename,'" does not exist?!')Assert ⎕NEXISTS filename
      origData←1⊃⎕NGET filename
      :If Arg.edit
          :If 0=≢new←EditJSON origData
              ⎕←'Cancelled without a change'
          :Else
              :If new≢origData
              :AndIf 1 ∆YesOrNo'Do you want to save your changes to disk?'
                  (⊂new)⎕NPUT filename 1
              :AndIf 1 ∆YesOrNo'Saved! Would you like to refresh the user settings in ⎕SE?'
                  TC.Init ⍬
                  ⎕←'User settings in ⎕SE updated'
              :EndIf
          :EndIf
      :Else
          :If ~Arg.apikey
              origData←'api_key["]*: "[^"]+'⎕R'api_key: "***'⊣origData          ⍝ Replace API key by Asterisks
          :EndIf
          buff←(⎕UCS 10)(≠⊆⊢)origData
          buff←(';'≠⊃¨buff)⌿buff
          r←⍪(⊂'User settings in <',filename,'> :'),buff
      :EndIf
    ∇

    ∇ r←Ping Arg;registry;registries
      r←⍬
      registry←Arg._1
      :If Arg.all
          r←0 2⍴⍬
          :If 0<≢registries←GetListOfRegistriesForSelection 0
          :AndIf 0<≢registries←(TC.Reg.IsHTTP¨registries[;1])⌿registries
              ⎕←'Questioning ',(⍕≢registries),' Tatin Registr',((1+1=≢registries)⊃'ies' 'y'),'...'
              r←{⍵,[1.5]⎕TSYNC{TC.Ping ⍵}¨&⍵}registries[;1]
          :EndIf
      :Else
          :If 0≡registry
          :AndIf 0=≢registry←SelectRegistry 0
              :Return
          :EndIf
          :If 0≠≢registry
              r←TC.Ping registry
          :EndIf
      :EndIf
    ∇

    ∇ (success newData)←(CheckFns EditJson)(name origData path);temp;msg;flag;json
    ⍝ Operator that allows the user to edit `origData` which is supposed to be JSON.\\
    ⍝ After editing it the function checks whether it is still valid JSON.
    ⍝ The user must either fix any problems or make sure that the JSON is empty,
    ⍝ in which case no action is taken
      temp←⎕SE.⎕NS''
      temp.⎕FX ⎕CR'ED'
      ⍎'temp.',name,'←origData'
      flag←1
      success←0
      newData←''
      :Repeat
          temp.ED name
          :If origData≢temp.⍎name
              json←temp.⍎name
          :AndIf 0<≢(∊json)~' '
              :If ~success←IsValidJSON json
                  msg←'This is not valid JSON; do you want to fix the problem? N=abandon changes'
                  flag←~∆YesOrNo msg
              :Else
                  (msg json)←CheckFns json path
                  :If 0<≢msg
                      flag←~1 ∆YesOrNo msg,'; want to try fixing the problem (n=abandon changes) ?'
                  :Else
                      flag←1
                      newData←json
                  :EndIf
              :EndIf
          :Else
              flag←1
          :EndIf
      :Until flag
    ∇

    ∇ (success newData)←(CheckFns EditText)(name origData);temp;msg;flag;txt
    ⍝ Operator that allows the user to edit `origData`. The function `CheckFns` is supposes to either
    ⍝ return an empty char vector (interpret3d as "okay") or an error message.\\
    ⍝ If you don't want to perform a check specify `{''}` as left operand.\\
    ⍝ The user must either fix any problems or make sure that the text is empty,
    ⍝ in which case no action is taken
      temp←⎕SE.⎕NS''
      temp.⎕FX ⎕CR'ED'
      ⍎'temp.',name,'←origData'
      flag←1
      success←0
      newData←''
      :Repeat
          temp.ED name
          :If origData≢temp.⍎name
              txt←⊆temp.⍎name
              txt←(0<≢¨txt)/txt
              txt{TC.A.(dlb dtb)⍵}¨txt
          :AndIf 0<≢(∊txt)~' '
              :If 0<≢msg←CheckFns txt
                  ⎕←msg
                  flag←~∆YesOrNo'Woulde you like to fix the problem? (N=abandon changes)'
              :Else
                  flag←1
                  newData←txt
              :EndIf
          :EndIf
      :Until flag
    ∇

    ∇ r←level Help Cmd;TC
      r←''
      :If 0=⎕SE.⎕NC'_Tatin'
          ⎕SE.UCMD'Tatin.LoadTatin'
      :EndIf
      TC←⎕SE._Tatin.Client
      :Select ⎕C Cmd
      :Case ⎕C'LoadTatin'
          r,←⊂'This loads the Tatin client into ⎕SE and initializes it if it''s not already there.'
          r,←⊂'Allows accessing the Tatin API via ⎕SE.Tatin.'
          r,←⊂''
          r,←⊂'By default the user config file is expected in the user''s home folder, and it will be'
          r,←⊂'created there if it does not already exists.'
          r,←⊂'Instead you may specify a different folder. Note that this is NOT a permanent change;'
          r,←⊂'if you want the change to be permanent specify it via the ]TATIN.UserSettings command'
          r,←⊂'with a -permanent flag.'
          r,←⊂''
          r,←⊂'The -force flag allows you to enforce the load even if ⎕SE.Tatin already exists.'
      :Case ⎕C'ListRegistries'
          r,←⊂'Lists URI, alias, priority and port of all Registries defined in the user settings.'
          r,←⊂'The result is ordered by priority: the first one is scanned first etc.'
          r,←⊂'Note that Registry with a priority of 0  will not participate in any scan of Registries.'
          r,←⊂''
          r,←⊂'* By default the output is beautified; specify -raw if you want just a raw table'
          r,←⊂'* By default all data but the API key are listed. Specify -all if you want the API key'
          r,←⊂'  columnsto be listed as well.'
      :Case ⎕C'ListPackages'
          r,←⊂'Lists all packages in the Registry specified as an argument. If no Registry was specified'
          r,←⊂'then the user will be prompted for the Registry, eccept when there is just one anyway.'
          r,←⊂''
          r,←⊂'It does not matter whether you specify / or \ in a path, or whether it has or has'
          r,←⊂'not a trailing separator: Tatin is taking care of that.'
          r,←⊂''
          r,←⊂'By default all packages are listed. You can influence the output in two ways:'
          r,←⊂' * -group={groupname} will restrict the list the packages with the given group name.'
          r,←⊂' * -tags=foo,goo will restrict the output to packages that carry the tags "foo" & "goo".'
          r,←⊂''
          r,←⊂'* By default the output is aggregated. Specify -noaggr if you want the full list.'
          r,←⊂'* By default the output is beautified. Specify -raw if you want just a raw list.'
      :Case ⎕C'LoadPackage'
          r,←⊂'Load the specified package and all its dependencies into the workspace'
          r,←⊂'Requires two arguments:'
          r,←⊂''
          r,←⊂'A) First argument:'
          r,←(3⍴' ')∘,¨HelpOnPackageID ⍬
          r,←⊂''
          r,←⊂'B) Second argument: target namespace'
          r,←⊂'   Must be the fully qualified name of a namespace the package will be loaded into.'
          r,←⊂'   May be # or ⎕SE or a sub-namespace of any level'
          r,←⊂''
          r,←⊂'Valid examples are:'
          r,←⊂'  ]TATIN.LoadPackage aplteam-APLTreeUtils-2.0.0 #'
          r,←⊂'  ]TATIN.LoadPackage [tatin]/aplteam-APLTreeUtils2-1.0.0 #'
          r,←⊂'  ]TATIN.LoadPackage [tatin]aplteam-APLTreeUtils2-1.0.0 #'
          r,←⊂'  ]TATIN.LoadPackage [tatin]aplteam-APLTreeUtils2-1.0 #'
          r,←⊂'  ]TATIN.LoadPackage [tatin]aplteam-APLTreeUtils2-1 #'
          r,←⊂'  ]TATIN.LoadPackage [tatin]aplteam-APLTreeUtils2 #'
          r,←⊂'  ]TATIN.LoadPackage [tatin]APLTreeUtils2 #'
          r,←⊂'  ]TATIN.LoadPackage [tatin]A@APLTreeUtils2 #'
          r,←⊂'  ]TATIN.LoadPackage APLTreeUtils2 #'
          r,←⊂'  ]TATIN.LoadPackage A@APLTreeUtils2 #'
          r,←⊂'  ]TATIN.LoadPackage file:///pathTo/MyReg/aplteam-APLTreeUtils2-1.0.0/ #'
          r,←⊂''
          r,←⊂'Returns fully qualified name of the package established in the target space'
      :Case ⎕C'InstallPackage'
          r,←⊂'Installs the given package and all its dependencies into the given folder.'
          r,←⊂''
          r,←⊂'A) First argument:'
          r,←(3⍴' ')∘,¨HelpOnPackageID ⍬
          r,←⊂''
          r,←⊂'B) Second argument'
          r,←⊂'   The second argument must be the path to a folder into which the packages are'
          r,←⊂'   going to be installed'
          r,←⊂''
          r,←⊂'Valid examples are:'
          r,←⊂'  ]TATIN.InstallPackage aplteam-APLTreeUtils-2.0.0 /pathTo/folder'
          r,←⊂'  ]TATIN.InstallPackage [tatin]/aplteam-APLTreeUtils2-1.0.0 /pathTo/folder'
          r,←⊂'  ]TATIN.InstallPackage [tatin]aplteam-APLTreeUtils2-1.0.0 /pathTo/folder'
          r,←⊂'  ]TATIN.InstallPackage [tatin]aplteam-APLTreeUtils2-1.0 /pathTo/folder'
          r,←⊂'  ]TATIN.InstallPackage [tatin]aplteam-APLTreeUtils2-1 /pathTo/folder'
          r,←⊂'  ]TATIN.InstallPackage [tatin]aplteam-APLTreeUtils2 /pathTo/folder'
          r,←⊂'  ]TATIN.InstallPackage [tatin]APLTreeUtils2 /pathTo/folder'
          r,←⊂'  ]TATIN.InstallPackage [tatin]A@APLTreeUtils2 /pathTo/folder'
          r,←⊂'  ]TATIN.InstallPackage APLTreeUtils2 /pathTo/folder'
          r,←⊂'  ]TATIN.InstallPackage A@APLTreeUtils2 /pathTo/folder'
          r,←⊂'  ]TATIN.InstallPackage file:///pathTo/MyReg/aplteam-APLTreeUtils2-1.0.0/ /installFolder'
          r,←⊂''
          r,←⊂'The -quiet flag comes handy with test cases.'
      :Case ⎕C'LoadDependencies'
          r,←⊂'Takes two arguments:'
          r,←⊂'[1] A folder into which one or more packages have been installed.'
          r,←⊂'[2] A namespace into which the packages are going to be loaded.'
          r,←⊂''
          r,←⊂'By default a package is not loaded if it already exists. You can enforce the load by'
          r,←⊂'specifying the -overwrite flag.'
      :Case ⎕C'UserSettings'
          r,←⊂'Prints the user settings to the session in JSON format.'
          r,←⊂'By default the API key is replaced by asterisks; specify -apikey to overwrite this.'
          r,←⊂''
          r,←⊂'If you want to do anything more than just printing the settings to the session then'
          r,←⊂'you are advised to use the API. Note that there is a dedicated document for how to'
          r,←⊂'use the API, and what for.'
          r,←⊂''
          r,←⊂'If you want to change the settings anyway you can add -edit in order to get the data'
          r,←⊂'into the editor and make changes. In this case the API key will always show.'
          r,←⊂'If you did change the data, you will first be prompted for saving the changes on disk'
          r,←⊂'and then for executing ]TATIN.Init in order to refresh the user settings in the ⎕SE.'
      :Case ⎕C'PackageConfig'
          r,←⊂'The argument, if specified, may be an HTTP request or a path.'
          r,←⊂'* In case of an HTTP request the package config file is returned as JSON.'
          r,←⊂'  Specifying any of the options has no effect.'
          r,←⊂'* In case of a path it must point to a folder that contains a Tatin package.'
          r,←⊂'  The contents of the file "',TC.CFG_Name,'" in that folder is returned.'
          r,←⊂'  In case the file does not exist yet it will be created.'
          r,←⊂''
          r,←⊂'In case no argument is specified the command tries to find a package config file in'
          r,←⊂'the current directory.'
          r,←⊂''
          r,←⊂'You may edit the file by specifying the -edit flag.'
          r,←⊂'In case you want to delete the file: specify the -delete flag.'
          r,←⊂''
          r,←⊂'In case of success a text vector with NLs in it is returned, otherwise an empty vector.'
      :Case ⎕C'UninstallPackage'
          r,←⊂'Requires two arguments:'
          r,←⊂'* Path to a folder with installed packages'
          r,←⊂'* A package identifier; can be one of:'
          r,←⊂'  * Name of the package to be un-installed. If {group} and {name} can identify the'
          r,←⊂'    package uniquely then there is no need to specify {version}. Even just {name}'
          r,←⊂'    might suffice.'
          r,←⊂'  * An alias. Post- or prefix with a "@" in order to be recognized as an alias.'
          r,←⊂''
          r,←⊂'This command un-installs the given package and all its dependencies but only if those'
          r,←⊂'are neither top-level packages nor required by any other package.'
      :Case ⎕C'PackageDependencies'
          r,←⊂'Takes a path to a folder and returns the contents of the file "apl-dependencies.txt".'
          r,←⊂'You may edit the file by specifying the -edit flag. In case the file does not already'
          r,←⊂'exist it is created.'
          r,←⊂''
          r,←⊂'After the edit the changes are checked for being complete and syntactically correct'
          r,←⊂'JSON, and if they are then they are saved to the given folder.'
          r,←⊂''
          r,←⊂'In case you want to delete the file specify the -delete flag.'
          r,←⊂''
          r,←⊂'Note that the -quiet flag prevents the "Are you sure?" question that is usually asked'
          r,←⊂'in conjunction with the -delete flag; this is probably only useful with test cases.'
      :Case ⎕C'Pack'
          r,←⊂'Creates a ZIP file from the directory ⍵[1] that is a package, and saves it in ⍵[2].'
          r,←⊂'Requires directory ⍵[1] to host a file "',TC.CFG_Name,'" defining the package.'
          r,←⊂''
          r,←⊂'* If ⍵[2] is not specified the pack file will be created in ⍵[1], but the user will be prompted.'
          r,←⊂'* If ⍵[1] is not specified it will act on the current directory, but the user will be prompted.'
      :Case ⎕C'PublishPackage'
          r,←⊂'Publish a package to a particular Registry Server.'
          r,←⊂'Such a package can be one of:'
          r,←⊂'* ZIP file, typically created by calling ]TATIN.Pack'
          r,←⊂'* Folder that contains everything that defines a package; in this case the required ZIP is'
          r,←⊂'  created by "PublishPackage"'
          r,←⊂''
          r,←⊂'Requires two arguments:'
          r,←⊂'* Path to ZIP file or package folder'
          r,←⊂'* URL or alias of a Registry Server or a "?"; you may or may not embrace it with []'
          r,←⊂''
          r,←⊂'The name of the resulting package is extracted from the ZIP file which therefore must conform'
          r,←⊂'to the Tatin rules.'
          r,←⊂''
          r,←⊂'The -quiet flag suppresses the "Are you sure?" question (test cases).'
      :Case ⎕C'ListVersions'
          r,←⊂'List all versions of the given package. You must specify the package as in'
          r,←⊂'[registry]{group}-{package}'
          r,←⊂''
          r,←⊂'If version precedence cannot be established from the version numbers alone (often a problem with'
          r,←⊂'beta versions) then the publishing date is taken into account.'
          r,←⊂'Specify the -date flag if you want the publishing date to be included.'
      :Case ⎕C'Version'
          r,←⊂'Prints name, version number and version date of the client to the session.'
          r,←⊂''
          r,←⊂'* Specify a URL or n alias if you are after the version number of a Tatin server'
          r,←⊂'* Specify * if you are after the version numbers of all Tatin servers'
      :Case ⎕C'ListTags'
          r,←⊂'List all unique tags used in all packages, sorted alphabetically.'
          r,←⊂''
          r,←⊂'If no Registry is specified as argument the user will be prompted unless there is only one'
          r,←⊂'Registry anyway.'
          r,←⊂''
          r,←⊂'You can specify one or more tags like -tags=foo,goo'
          r,←⊂'In that case all tags are listed from packages that carry both "foo" & "goo".'
      :Case ⎕C'Init'
          r,←⊂'Re-establishes the user settings in ⎕SE. Call this in case the user settings got changed on file'
          r,←⊂'and you want to incorporate the changes in the current session.'
          r,←⊂''
          r,←⊂'Without an argument Init prcesses the default user settings file.'
          r,←⊂'Insetad you can specify a directory that contains a file tatin-client.json as argument.'
      :Case ⎕C'CheckForLaterVersion'
          r,←⊂'Takes the path to a folder with a file "apl-buildlist.json" as argument.'
          r,←⊂'Checks the packages specified in that file for later versions.'
          r,←⊂'Packages installed from  ZIP files are ignored: Tatin does not know where to look.'
          r,←⊂''
          r,←⊂'Returns information only for packages a later version was found for.'
          r,←⊂''
          r,←⊂'-major:        by default later MAJOR versions are ignored, but this default behaviour can be changed '
          r,←⊂'               by specifying the flag -major: then only later major versions are reported.'
          r,←⊂''
          r,←⊂'-dependencies: by default only principal packages are checked. You may include dependencies by'
          r,←⊂'               specifying this flag.'
          r,←⊂''
          r,←⊂'-raw:          by default the output is beautified; specify -raw if you want just a raw table.'
      :Case ⎕C'DeletePackage'
          r,←⊂'Takes a path pointing to a package.'
          r,←⊂'Examples:'
          r,←⊂']Tatin.DeletePackage C:\MyTatinServer\Registry\aplteam-foo-1.0.0'
          r,←⊂']Tatin.DeletePackage https:/test.tatin.dev/aplteam-foo-1.0.0'
          r,←⊂']Tatin.DeletePackage [test-tatin]aplteam-foo-1.0.0'
          r,←⊂''
          r,←⊂'Note that whether a package can be deleted or not depends on the delete policy of the given'
          r,←⊂'server. A server may allow no deletion at all, or just beta versions or everything.'
      :Case ⎕C'GetDeletePolicy'
          r,←⊂'Requests which "Delete" policy is operated by a server.'
          r,←⊂'If no server is specified the user will be prompted, unless there is just one server anyway.'
      :Case ⎕C'Documentation'
          r,←⊂'Puts https://tatin.dev/v1/documentation into the default browser'
      :Case ⎕C'ReinstallDependencies'
          r,←⊂''
          r,←⊂'Takes a folder as mandatory argument. That folder must host a file apl-dependencies.txt'
          r,←⊂'All files and folders but the dependency file are removed from the folder and then the'
          r,←⊂'packages are installed from scratch.'
          r,←⊂''
          r,←⊂'Note that this does not install any better versions ever. In fact as a side effect of minimmal'
          r,←⊂'version selection you might end up with an older version under specific (and rare) circumstances.'
          r,←⊂''
          r,←⊂'All defined Registries are scanned but one can specify a particular Registry as second'
          r,←⊂'(optional) argument.'
          r,←⊂''
          r,←⊂'Examples:'
          r,←⊂']Tatin.ReinstallDependencies /path2/installfolder/'
          r,←⊂']Tatin.ReinstallDependencies /path2/installfolder/ [tatin]'
          r,←⊂']Tatin.ReinstallDependencies /path2/installfolder/ [tatin] -nobetas'
          r,←⊂''
          r,←⊂'-force prevent the command from asking the user, and does not report to the session either.'
          r,←⊂'-dry   makes the user command report what it would do without actually doing anything at all.'
          r,←⊂''
          r,←⊂'By default betas are included but this can be changed by specifying the -nobetas flag.'
      :Case ⎕C'Ping'
          r,←⊂'Useful to find out whether a Tatin Server is alive and respondig. Returns a Boolean (1=success)'
          r,←⊂''
          r,←⊂'You may specify a Registry alias or a Registry URL.'
          r,←⊂'If you specify no argument you will be prompted for a Registry'
          r,←⊂''
          r,←⊂'You may also specify a flag -all. If you do a matrix with two columns is returned:'
          r,←⊂' [;1] is a Boolean (a=success)'
          r,←⊂' [;2] is a Registry URL or, if there is one defined, an alias'
          r,←⊂''
          r,←⊂'Note that if -all is specified then any argument is ignored.'
      :Else
          r←'Unknown command: ',Cmd
      :EndSelect
    ∇

    ∇ r←HelpOnPackageID dummy
      r←''
      r,←⊂'You may specify an alias for the package in question by putting it to the front'
      r,←⊂'and separate it with an @.'
      r,←⊂''
      r,←⊂'Not that if neither a Registry nor a ZIP file is specified but just a package ID'
      r,←⊂'(partly or fully) then all defined Registries with a priority of greater than 0'
      r,←⊂'are scanned; the first hit wins.'
      r,←⊂''
      r,←⊂'It may be:'
      r,←⊂''
      r,←⊂'* A full package ID.'
      r,←⊂''
      r,←⊂'  A full package ID has three ingredients: {group}-{name}-{major.minor.patch}.'
      r,←⊂''
      r,←⊂'* You may also specify an incomplete package ID in terms of no patch number, or'
      r,←⊂'  neither minor nor patch number, or no version information at all, and leave it'
      r,←⊂'  it to Tatin to establish the latest version itself.'
      r,←⊂''
      r,←⊂'* You may also omit the group. This will fail in case the same package name is used'
      r,←⊂'  in two or more different groups but will succeed otherwise.'
      r,←⊂''
      r,←⊂'* Either a full path or a URL in front of the package ID.'
      r,←⊂''
      r,←⊂'By default beta versions are included. Specify -nobetas in order to suppress those.'
    ∇

    ∇ yesOrNo←{default}∆YesOrNo question;isOkay;answer;add;dtb;answer2
    ⍝ Ask a simple question and allows just "Yes" or "No" as answers.
    ⍝ You may specify a default via the optional left argument which when specified
    ⍝ rules what happens when the user just presses <enter>.
    ⍝ `default` must be either 1 (yes) or 0 (no).
    ⍝ Note that this function does not work as expected when traced!
      isOkay←0
      default←{0<⎕NC ⍵:⍎⍵ ⋄ ''}'default'
      isOkay←0
      :If ~0∊⍴default
          'Left argument must be a scalar'⎕SIGNAL 98/⍨1≠⍴,default
      :AndIf ~default∊0 1
          'The left argument. if specified, must be a Boolean or empty'⎕SIGNAL 98
      :EndIf
      :If 0=≢default
          add←' (y/n) '
      :Else
          :If default
              add←' (Y/n) '
          :Else
              add←' (y/N) '
          :EndIf
      :EndIf
      :If 1<≡question
          ((⍴question)⊃question)←((⍴question)⊃question),add
          question←⍪question
      :Else
          question←question,add
      :EndIf
      :Repeat
          ⍞←question
          answer←⍞
          :If answer≡question                        ⍝ Did...  (since version 18.0 trailing blanks are not removed anynmore)
          :OrIf (≢answer)=¯1+≢question               ⍝ ..the ...
          :OrIf 0=≢answer                            ⍝ ...user just...
              dtb←{⍵↓⍨-+/∧\' '=⌽⍵}
              answer2←dtb answer
          :OrIf answer2≡((-≢answer2)↑dtb question)   ⍝ ...press <enter>?
              :If 0≠≢default
                  yesOrNo←default
                  isOkay←1
              :EndIf
          :Else
              answer←¯1↑{⍵↓⍨-+/∧\' '=⌽⍵}answer
              :If answer∊'YyNn'
                  isOkay←1
                  yesOrNo←answer∊'Yy'
              :EndIf
          :EndIf
      :Until isOkay
    ∇

    ∇ errMsg←CheckDependencies txt;f1;f2;f3;f
    ⍝ Every single line must have at least a group name and a package name
    ⍝ but optionally also major.minor.patch
      f1←TC.Reg.IsValidPackageID_Complete¨txt
      f2←TC.Reg.IsValidPackageID_WithMajorNo¨txt
      f3←TC.Reg.IsValidPackageID_WithoutVersionNo¨txt
      errMsg←''
      :If ∨/~f←f1+f2+f3
          :If 1=+/~f
              errMsg←'Not a valid package ID: ',⊃(~f)/txt
          :Else
              errMsg←'Not valid package IDs: ',⊃{⍺',',⍵}/(~f)/txt
          :EndIf
      :EndIf
    ∇

    ∇ (msg json)←CheckPackageConfigFile(json path);cfg2;ns;extensions;⎕TRAP;list
    ⍝ Returns an empty vector if everything is okay and an error message otherwise
      msg←''
      ns←⎕JSON⍠('Dialect' 'JSON5')⊣json
      :Trap 98
          cfg2←TC.InitPackageConfig ns
          'name'TC.ValidateName ns.name
          'group'TC.ValidateName ns.group
          {}'api'TC.ValidateName⍣(0<≢ns.api)⊣ns.api
          TC.ValidateVersion ns.version
          ns←TC.ValidateTags ns
          ns←TC.ValidateDescription ns
          :If 0=≢ns.source
              list←(1+≢path)↓¨⊃TC.F.Dir path,'\'
              list~←⊂TC.CFG_Name
              :If 1=≢list
              :AndIf ((⊂3⊃⎕NPARTS⊃list)∊'.apln' '.aplc')∨TC.F.IsDir path,⊃list
                  ns.source←⊃list
              :Else
                  msg←'Invalid: "source"'
                  :Return
              :EndIf
          :EndIf
          {}{{'source'TC.ValidateName ⍵}⍣(0<≢⍵)⊣⍵}ns.source~'/\'
          :If '.'∊ns.source
              '"source" carries an invalid extension'Assert(⊂3⊃⎕NPARTS ns.source)∊SupportedExtensions
          :EndIf
          json←TC.Reg.JSON ns
      :Else
          msg←⎕DMX.EM
      :EndTrap
    ∇

    Assert←{⍺←'' ⋄ (,1)≡,⍵:r←1 ⋄ ⎕ML←3 ⋄ ⍺ ⎕SIGNAL 1↓(↑∊⍵),98}
    AddHeader←{0=≢⍺:⍺ ⋄(⍵,[0.5]'-'⍴¨⍨≢¨⍵)⍪⍺}
    EnforceSlash←{'/'@(⍸'\'=⍵)⊣⍵}
    IsScripted←{0::1 ⋄0⊣⎕src ⍵}
    ED←{⎕ED⍠('EditName' 'Disallow')⊣⍵}
    IsValidJSON←{0::0 ⋄ 1⊣TC.Reg.JSON ⍵}
    IfAtLeastVersion←{⍵≤{⊃(//)⎕VFI ⍵/⍨2>+\'.'=⍵}2⊃# ⎕WG'APLVersion'}

    ∇ index←{x}Select options;flag;answer;question;value;bool;⎕ML;⎕IO;manyFlag;mustFlag;caption
    ⍝ Presents `options` as a numbered list and allows the user to select either exactly one or multiple ones.\\
    ⍝ One is the default.\\
    ⍝ The optional left argument allows you to specify more options:
    ⍝ * `manyFlag` defaults to 0 (meaning just one item might be selected) or 1, in which case multiple items can be specified.
    ⍝ * `mustFlag` forces the user to select at least one  option.
    ⍝ * `caption` is shown above the options.
    ⍝ `options` must not have more than 999 items.
    ⍝ If the user aborts by entering nothing or a "q" (for "quit") `index will be `⍬`.
      x←{0<⎕NC ⍵:⊆⍎⍵ ⋄ ''}'x'
      (caption manyFlag mustFlag)←x,(⍴,x)↓'' 0 0
      ⎕IO←1 ⋄ ⎕ML←1
      manyFlag←{0<⎕NC ⍵:⍎⍵ ⋄ 0}'manyFlag'
      'Invalid right argument; must be a vector of text vectors.'⎕SIGNAL 98/⍨2≠≡options
      'Right argument has more than 999 items'⎕SIGNAL 98/⍨999<≢options
      flag←0
      :Repeat
          ⎕←{⍵↑'--- ',caption,((0≠≢caption)/' '),⍵⍴'-'}⎕PW-1
          ⎕←⍪{((⊂'. '),¨⍨(⊂3 0)⍕¨⍳⍴⍵),¨⍵}options
          ⎕←''
          question←'Select one ',(manyFlag/'or more '),'item',((manyFlag)/'s'),' '
          question,←((manyFlag∨~mustFlag)/'('),((~mustFlag)/'q=quit'),((manyFlag∧~mustFlag)/', '),(manyFlag/'a=all'),((manyFlag∨~mustFlag)/')'),' :'
          :If 0<≢answer←⍞,0/⍞←question
              answer←(⍴question)↓answer
              :If 1=≢answer
              :AndIf answer∊'Qq',manyFlag/'Aa'
                  :If answer∊'Qq'
                      :If 0=mustFlag
                          index←⍬
                          flag←1
                      :EndIf
                  :Else
                      index←⍳≢options
                      flag←1
                  :EndIf
              :Else
                  (bool value)←⎕VFI answer
                  :If ∧/bool
                  :AndIf manyFlag∨1=+/bool
                      value←bool/value
                  :AndIf ∧/value∊⍳⍴options
                      index←value
                      flag←0≠≢index
                  :EndIf
              :EndIf
          :EndIf
      :Until flag
      index←{1<≢⍵:⍵ ⋄ ⊃⍵}⍣(⍬≢index)⊣index
    ∇

    ∇ r←GetListOfRegistriesForSelection type
      r←1 TC.ListRegistries type
      r[;2]←{0=≢⍵:'' ⋄ '[',⍵,']'}¨r[;2]
    ∇

    ∇ registry←SelectRegistry type;row;list
      :If 1=≢list←GetListOfRegistriesForSelection type
          registry←1⊃list[1;]
      :Else
          :If ⍬≡row←'Select Tatin Registry'Select↓⎕FMT⌽list[;1 2]
              registry←⍬
          :Else
              registry←1⊃list[row;]
          :EndIf
      :EndIf
    ∇

    ∇ r←GetTitleFromHtml html;offset
      offset←⊃'<title[^>]*>([^<]+)'⎕S 0⍠('Greedy' 0)('IC' 1)('Mode' 'M')⊣html
      r←offset↓html
      r↓⍨←r⍳'>'
      r↑⍨←¯1+r⍳'>'
      r↑⍨←¯1+r⍳'<'
      ⍝Done
    ∇

    ∇ r←EditJSON data;ns;flag
      flag←0
      ns←#.⎕NS''
      ns.UserSettings←data
      :Repeat
          ns.⎕ED'UserSettings'
          :If 0=≢ns.UserSettings
              r←⍬
              flag←1
          :Else
              :If {0::1 ⋄ 0⊣JSON ⍵}{b←';'≠⊃¨d←(⎕UCS 10)(≠⊆⊢)⍵ ⋄ 1↓⊃,/(⎕UCS 10),¨b/d}ns.UserSettings
                  :If ~1 ∆YesOrNo'The JSON is invalid; would you like to edit it again? ("N"=drop out without change)'
                      r←''
                      flag←1
                  :EndIf
              :Else
                  r←ns.UserSettings
                  flag←1
              :EndIf
          :EndIf
      :Until flag
    ⍝Done
    ∇

    JSON←{⎕JSON⍠('Dialect' 'JSON5')⊣⍵}

    AddSlash←{0=≢⍵:⍵ ⋄ ⍵,(~(¯1↑⍵)∊'/\')/'/'}

:EndNamespace
